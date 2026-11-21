
import os
import csv
import time
import random
import statistics
import subprocess

from itertools import permutations
from pair_metrics import analyze_ir

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

LLVM_BIN = subprocess.check_output(
    ["brew", "--prefix", "llvm"],
    text=True
).strip() + "/bin"

CLANG = os.path.join(LLVM_BIN, "clang")
OPT = os.path.join(LLVM_BIN, "opt")

OUTPUT_ROOT = os.path.join(
    ROOT, "results", "multi_benchmark"
)

PASSES = [
    "mem2reg",
    "sroa",
    "instcombine",
    "simplifycfg",
    "dce",
    "adce",
    "gvn",
]

WORKLOADS = {
    "arithmetic": {
        "source": "benchmarks/workloads/arithmetic.c",
        "args": ["50000000", "12345"],
    },
    "branch_heavy": {
        "source": "benchmarks/workloads/branch_heavy.c",
        "args": ["50000000", "12345"],
    },
    "array_processing": {
        "source": "benchmarks/workloads/array_processing.c",
        "args": ["1000000", "12345"],
    },
    "function_heavy": {
        "source": "benchmarks/workloads/function_heavy.c",
        "args": ["10000000", "12345"],
    },
}

TOP_CANDIDATES = 15
WARMUP_RUNS = 2
BENCHMARK_RUNS = 11


def run_command(command):

    subprocess.run(
        command,
        check=True,
        capture_output=True,
        text=True
    )


def generate_ir(source, output):

    run_command([
        CLANG,
        "-S",
        "-emit-llvm",
        "-O0",
        "-Xclang",
        "-disable-O0-optnone",
        source,
        "-o",
        output,
    ])


def generate_candidates(input_ir, folder):

    candidates = []

    index = 0

    print("\nSearching optimization sequences...")

    for length in [2, 3]:

        sequences = list(permutations(PASSES, length))

        for sequence in sequences:

            index += 1

            output = os.path.join(
                folder,
                f"candidate_{index:03d}.ll"
            )

            pipeline = ",".join(sequence)

            run_command([
                OPT,
                f"-passes={pipeline}",
                input_ir,
                "-S",
                "-o",
                output,
            ])

            metrics = analyze_ir(output)

            candidates.append({
                "Sequence": " -> ".join(sequence),
                "IR": output,
                "Instructions": metrics["Instructions"],
                "IR Size": metrics["IR Size"],
            })

    candidates.sort(
        key=lambda row: (
            row["Instructions"],
            row["IR Size"]
        )
    )

    # Save structural search results
    search_csv = os.path.join(
        folder,
        "structural_search.csv"
    )

    with open(search_csv, "w", newline="") as file:

        writer = csv.DictWriter(
            file,
            fieldnames=[
                "Sequence",
                "Instructions",
                "IR Size",
            ]
        )

        writer.writeheader()

        writer.writerows([
            {
                "Sequence": row["Sequence"],
                "Instructions": row["Instructions"],
                "IR Size": row["IR Size"],
            }
            for row in candidates
        ])

    print("Sequences tested:", len(candidates))

    return candidates[:TOP_CANDIDATES]


def prepare_programs(input_ir, candidates, folder):

    programs = []

    definitions = [
        ("Original O0", input_ir)
    ]

    # Standard LLVM pipelines
    for level in ["O1", "O2", "O3"]:

        output = os.path.join(
            folder,
            f"default_{level}.ll"
        )

        run_command([
            OPT,
            f"-passes=default<{level}>",
            input_ir,
            "-S",
            "-o",
            output,
        ])

        definitions.append((
            f"LLVM {level}",
            output
        ))

    # Custom candidates
    for index, candidate in enumerate(candidates, start=1):

        definitions.append((
            candidate["Sequence"],
            candidate["IR"]
        ))

    for index, (name, ir_file) in enumerate(definitions):

        executable = os.path.join(
            folder,
            f"program_{index:02d}"
        )

        run_command([
            CLANG,
            "-O0",
            ir_file,
            "-o",
            executable,
        ])

        programs.append({
            "Name": name,
            "Executable": executable,
            "Binary Size": os.path.getsize(executable),
        })

    return programs


def execute_program(executable, arguments):

    start = time.perf_counter()

    result = subprocess.run(
        [executable] + arguments,
        capture_output=True,
        text=True,
        check=True,
        timeout=180
    )

    elapsed = time.perf_counter() - start

    return result.stdout, elapsed


def benchmark_workload(name, config):

    print("\n" + "=" * 70)
    print("WORKLOAD:", name.upper())
    print("=" * 70)

    folder = os.path.join(OUTPUT_ROOT, name)
    ir_folder = os.path.join(folder, "ir")

    os.makedirs(ir_folder, exist_ok=True)

    source = os.path.join(ROOT, config["source"])

    input_ir = os.path.join(
        ir_folder,
        "original_O0.ll"
    )

    print("\nGenerating LLVM IR...")

    generate_ir(source, input_ir)

    print("Generating custom candidates...")

    candidates = generate_candidates(
        input_ir,
        ir_folder
    )

    print("Preparing executables...")

    programs = prepare_programs(
        input_ir,
        candidates,
        folder
    )

    arguments = config["args"]

    # Baseline output
    expected_output, _ = execute_program(
        programs[0]["Executable"],
        arguments
    )

    print("\nVerifying program outputs...")

    for program in programs:

        output, _ = execute_program(
            program["Executable"],
            arguments
        )

        if output != expected_output:

            raise RuntimeError(
                f"Output mismatch: {name} / {program['Name']}"
            )

    print("All programs produced identical output.")

    # Warm-up
    print("\nWarming up...")

    for program in programs:

        for _ in range(WARMUP_RUNS):

            execute_program(
                program["Executable"],
                arguments
            )

    measurements = {
        program["Name"]: []
        for program in programs
    }

    rng = random.Random(42 + len(name))

    print("\nStarting randomized measurements...")

    for round_number in range(BENCHMARK_RUNS):

        current_round = programs.copy()

        rng.shuffle(current_round)

        for program in current_round:

            output, elapsed = execute_program(
                program["Executable"],
                arguments
            )

            if output != expected_output:
                raise RuntimeError("Output mismatch detected!")

            measurements[
                program["Name"]
            ].append(elapsed)

        print(
            f"Completed round {round_number + 1}/"
            f"{BENCHMARK_RUNS}"
        )

    baseline_time = statistics.median(
        measurements["Original O0"]
    )

    results = []

    for program in programs:

        times = measurements[program["Name"]]

        median_time = statistics.median(times)

        results.append({
            "Workload": name,
            "Program": program["Name"],
            "Median Time (seconds)": median_time,
            "Mean Time (seconds)": statistics.mean(times),
            "Binary Size (bytes)": program["Binary Size"],
            "Speedup vs O0": baseline_time / median_time,
        })

    results.sort(
        key=lambda row: row["Median Time (seconds)"]
    )

    # Save per-workload results
    result_csv = os.path.join(
        folder,
        "benchmark_results.csv"
    )

    with open(result_csv, "w", newline="") as file:

        writer = csv.DictWriter(
            file,
            fieldnames=list(results[0].keys())
        )

        writer.writeheader()
        writer.writerows(results)

    print("\nTOP 5 RESULTS")

    for row in results[:5]:

        print(
            f"{row['Program']} | "
            f"{row['Median Time (seconds)']:.8f} sec | "
            f"{row['Speedup vs O0']:.4f}x"
        )

    print("\nSaved:", result_csv)

    return results


def main():

    os.makedirs(OUTPUT_ROOT, exist_ok=True)

    print("=" * 70)
    print("SCOS MULTI-WORKLOAD EVALUATION ENGINE")
    print("=" * 70)

    all_results = []

    for name, config in WORKLOADS.items():

        results = benchmark_workload(
            name,
            config
        )

        all_results.extend(results)

    # Save combined results
    combined_csv = os.path.join(
        OUTPUT_ROOT,
        "all_workloads.csv"
    )

    with open(combined_csv, "w", newline="") as file:

        writer = csv.DictWriter(
            file,
            fieldnames=list(all_results[0].keys())
        )

        writer.writeheader()
        writer.writerows(all_results)

    print("\n" + "=" * 70)
    print("SCOS MULTI-WORKLOAD EVALUATION COMPLETED")
    print("=" * 70)

    print("Total workloads:", len(WORKLOADS))
    print("Total result records:", len(all_results))
    print("\nCombined report:")
    print(combined_csv)


if __name__ == "__main__":
    main()
