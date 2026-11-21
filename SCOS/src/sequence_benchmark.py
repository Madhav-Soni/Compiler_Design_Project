
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
BIN_DIR = os.path.join(SEQUENCE_DIR, "benchmark_bins")

INPUT_IR = os.path.join(
    ROOT, "results", "benchmark_pass_input.ll"
)

SEQUENCE_CSV = os.path.join(
    SEQUENCE_DIR, "sequence_results.csv"
)

OUTPUT_CSV = os.path.join(
    SEQUENCE_DIR, "runtime_results.csv"
)

WARMUP_RUNS = 2
BENCHMARK_RUNS = 15
TOP_CANDIDATES = 15

random_generator = random.Random(42)

os.makedirs(BIN_DIR, exist_ok=True)


def compile_ir(ir_file, executable):

    command = [
        CLANG,
        "-O0",
        ir_file,
        "-o",
        executable
    ]

    subprocess.run(
        command,
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

    end = time.perf_counter()

    return result.stdout, end - start


def main():

    print("=" * 65)
    print("SCOS RANDOMIZED SEQUENCE BENCHMARKER")
    print("=" * 65)

    programs = []

    # Compile baseline
    baseline_executable = os.path.join(
        BIN_DIR, "baseline"
    )

    print("\nCompiling baseline...")

    compile_ir(INPUT_IR, baseline_executable)

    programs.append({
        "Sequence": "Baseline",
        "Executable": baseline_executable
    })

    # Read structurally promising candidates
    with open(SEQUENCE_CSV, "r") as file:

        candidates = list(csv.DictReader(file))[
            :TOP_CANDIDATES
        ]

    # Compile all candidates before measuring
    print(f"\nCompiling {len(candidates)} candidates...")

    for index, candidate in enumerate(candidates, start=1):

        sequence = candidate["Sequence"]

        ir_filename = (
            sequence.replace(" -> ", "__") + ".ll"
        )

        ir_file = os.path.join(
            SEQUENCE_DIR,
            ir_filename
        )

        executable = os.path.join(
            BIN_DIR,
            f"candidate_{index}"
        )

        compile_ir(ir_file, executable)

        programs.append({
            "Sequence": sequence,
            "Executable": executable
        })

    # Verify baseline output
    expected_output, _ = execute_program(
        baseline_executable
    )

    print("\nBaseline output:")
    print(expected_output.strip())

    # Warm up every executable
    print("\nWarming up programs...")

    for program in programs:

        for _ in range(WARMUP_RUNS):

            output, _ = execute_program(
                program["Executable"]
            )

            if output != expected_output:
                raise RuntimeError(
                    f"Output mismatch: {program['Sequence']}"
                )

    # Randomized measurement rounds
    measurements = {
        program["Sequence"]: []
        for program in programs
    }

    print(
        f"\nStarting {BENCHMARK_RUNS} randomized "
        "measurement rounds..."
    )

    for round_number in range(BENCHMARK_RUNS):

        randomized_programs = programs.copy()

        random_generator.shuffle(randomized_programs)

        for program in randomized_programs:

            output, elapsed = execute_program(
                program["Executable"]
            )

            if output != expected_output:
                raise RuntimeError(
                    f"Output mismatch: {program['Sequence']}"
                )

            measurements[
                program["Sequence"]
            ].append(elapsed)

        print(
            f"Completed round {round_number + 1}/"
            f"{BENCHMARK_RUNS}"
        )

    # Calculate results
    baseline_median = statistics.median(
        measurements["Baseline"]
    )

    results = []

    for program in programs:

        sequence = program["Sequence"]
        times = measurements[sequence]

        median_time = statistics.median(times)
        mean_time = statistics.mean(times)

        executable_size = os.path.getsize(
            program["Executable"]
        )

        results.append({
            "Sequence": sequence,
            "Median Time (seconds)": median_time,
            "Mean Time (seconds)": mean_time,
            "Min Time (seconds)": min(times),
            "Max Time (seconds)": max(times),
            "Binary Size (bytes)": executable_size,
            "Speedup vs Baseline": (
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

    print("\n" + "=" * 65)
    print("RUNTIME BENCHMARK RESULTS")
    print("=" * 65)

    print(
        f"\nBaseline median: {baseline_median:.8f} seconds"
    )

    for index, result in enumerate(results, start=1):

        print(
            f"\n{index}. {result['Sequence']}"
            f"\n   Median: "
            f"{result['Median Time (seconds)']:.8f} sec"
            f"\n   Speedup: "
            f"{result['Speedup vs Baseline']:.4f}x"
        )

    print("\nResults saved to:")
    print(OUTPUT_CSV)


if __name__ == "__main__":
    main()
