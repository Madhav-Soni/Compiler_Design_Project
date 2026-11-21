
import os
import csv
import time
import random
import statistics
import subprocess

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

LLVM_BIN = subprocess.check_output(
    ["brew", "--prefix", "llvm"],
    text=True
).strip() + "/bin"

CLANG = os.path.join(LLVM_BIN, "clang")

SEQUENCE_DIR = os.path.join(ROOT, "results", "sequences")
BIN_DIR = os.path.join(ROOT, "results", "fair_benchmark")

INPUT_IR = os.path.join(
    ROOT, "results", "benchmark_pass_input.ll"
)

SEQUENCE_CSV = os.path.join(
    SEQUENCE_DIR, "sequence_results.csv"
)

OUTPUT_CSV = os.path.join(
    ROOT, "results", "fair_comparison.csv"
)

REFERENCE_PIPELINES = {
    "LLVM O1": os.path.join(ROOT, "results", "default_O1.ll"),
    "LLVM O2": os.path.join(ROOT, "results", "default_O2.ll"),
    "LLVM O3": os.path.join(ROOT, "results", "default_O3.ll"),
}

WARMUP_RUNS = 2
BENCHMARK_RUNS = 15
TOP_CANDIDATES = 15

rng = random.Random(42)

os.makedirs(BIN_DIR, exist_ok=True)


def compile_ir(ir_file, executable):

    subprocess.run(
        [CLANG, "-O0", ir_file, "-o", executable],
        check=True,
        capture_output=True,
        text=True
    )


def execute_program(executable):

    start = time.perf_counter()

    result = subprocess.run(
        [executable],
        capture_output=True,
        text=True,
        check=True,
        timeout=120
    )

    elapsed = time.perf_counter() - start

    return result.stdout, elapsed


def main():

    print("=" * 70)
    print("SCOS FAIR OPTIMIZATION COMPARISON")
    print("=" * 70)

    programs = []

    # Original unoptimized IR
    programs.append({
        "Name": "Original O0 IR",
        "IR": INPUT_IR
    })

    # Custom SCOS sequences
    with open(SEQUENCE_CSV, "r") as file:

        candidates = list(csv.DictReader(file))[
            :TOP_CANDIDATES
        ]

    for candidate in candidates:

        sequence = candidate["Sequence"]

        filename = sequence.replace(" -> ", "__") + ".ll"

        programs.append({
            "Name": sequence,
            "IR": os.path.join(SEQUENCE_DIR, filename)
        })

    # Standard LLVM pipelines
    for name, ir_file in REFERENCE_PIPELINES.items():

        programs.append({
            "Name": name,
            "IR": ir_file
        })

    # Compile every program using the same backend setting
    print(f"\nCompiling {len(programs)} programs...")

    for index, program in enumerate(programs):

        executable = os.path.join(
            BIN_DIR, f"program_{index}"
        )

        if not os.path.isfile(program["IR"]):
            raise FileNotFoundError(program["IR"])

        compile_ir(program["IR"], executable)

        program["Executable"] = executable
        program["Binary Size"] = os.path.getsize(executable)

        print(f"Compiled: {program['Name']}")

    # Establish expected output
    expected_output, _ = execute_program(
        programs[0]["Executable"]
    )

    print("\nChecking output consistency...")

    for program in programs:

        output, _ = execute_program(
            program["Executable"]
        )

        if output != expected_output:
            raise RuntimeError(
                f"Output mismatch: {program['Name']}"
            )

    print("All programs produce identical output.")

    # Warm-up
    print("\nWarming up...")

    for program in programs:

        for _ in range(WARMUP_RUNS):

            execute_program(program["Executable"])

    measurements = {
        program["Name"]: []
        for program in programs
    }

    # Randomized measurements
    print("\nStarting randomized measurements...")

    for round_number in range(BENCHMARK_RUNS):

        current_round = programs.copy()
        rng.shuffle(current_round)

        for program in current_round:

            output, elapsed = execute_program(
                program["Executable"]
            )

            if output != expected_output:
                raise RuntimeError(
                    f"Output mismatch: {program['Name']}"
                )

            measurements[program["Name"]].append(elapsed)

        print(
            f"Completed round {round_number + 1}/"
            f"{BENCHMARK_RUNS}"
        )

    baseline_median = statistics.median(
        measurements["Original O0 IR"]
    )

    results = []

    for program in programs:

        times = measurements[program["Name"]]

        median_time = statistics.median(times)

        results.append({
            "Program": program["Name"],
            "Median Time (seconds)": median_time,
            "Mean Time (seconds)": statistics.mean(times),
            "Minimum Time (seconds)": min(times),
            "Maximum Time (seconds)": max(times),
            "Binary Size (bytes)": program["Binary Size"],
            "Speedup vs Original O0": (
                baseline_median / median_time
            )
        })

    results.sort(
        key=lambda row: row["Median Time (seconds)"]
    )

    with open(OUTPUT_CSV, "w", newline="") as file:

        writer = csv.DictWriter(
            file,
            fieldnames=list(results[0].keys())
        )

        writer.writeheader()
        writer.writerows(results)

    print("\n" + "=" * 70)
    print("FINAL PERFORMANCE RANKING")
    print("=" * 70)

    print(
        f"\nOriginal O0 median: "
        f"{baseline_median:.8f} seconds"
    )

    for index, row in enumerate(results, start=1):

        print(
            f"\n{index}. {row['Program']}"
            f"\n   Median: "
            f"{row['Median Time (seconds)']:.8f} sec"
            f"\n   Speedup: "
            f"{row['Speedup vs Original O0']:.4f}x"
        )

    print("\nResults saved to:")
    print(OUTPUT_CSV)


if __name__ == "__main__":
    main()
