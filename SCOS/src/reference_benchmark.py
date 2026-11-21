
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

SOURCE = os.path.join(
    ROOT, "benchmarks", "benchmark.c"
)

RESULTS_DIR = os.path.join(
    ROOT, "results", "reference"
)

OUTPUT_CSV = os.path.join(
    RESULTS_DIR, "compiler_benchmarks.csv"
)

LEVELS = ["-O0", "-O1", "-O2", "-O3"]

WARMUP_RUNS = 2
BENCHMARK_RUNS = 15

os.makedirs(RESULTS_DIR, exist_ok=True)


def compile_program(level):

    executable = os.path.join(
        RESULTS_DIR,
        f"benchmark_{level.replace('-', '')}"
    )

    subprocess.run(
        [CLANG, SOURCE, level, "-o", executable],
        check=True,
        capture_output=True,
        text=True
    )

    return executable


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

    print("=" * 60)
    print("SCOS STANDARD LLVM OPTIMIZATION BENCHMARK")
    print("=" * 60)

    programs = []

    for level in LEVELS:

        print(f"\nCompiling {level}...")

        executable = compile_program(level)

        programs.append({
            "Optimization": level,
            "Executable": executable
        })

    expected_output, _ = execute_program(
        programs[0]["Executable"]
    )

    # Verify identical output at every optimization level
    for program in programs:

        output, _ = execute_program(
            program["Executable"]
        )

        if output != expected_output:
            raise RuntimeError(
                f"Output mismatch at {program['Optimization']}"
            )

    print("\nAll optimization levels produce identical output.")

    # Warm-up
    for program in programs:

        for _ in range(WARMUP_RUNS):
            execute_program(program["Executable"])

    measurements = {
        program["Optimization"]: []
        for program in programs
    }

    rng = random.Random(42)

    print("\nRunning randomized measurements...")

    for round_number in range(BENCHMARK_RUNS):

        current_round = programs.copy()
        rng.shuffle(current_round)

        for program in current_round:

            output, elapsed = execute_program(
                program["Executable"]
            )

            if output != expected_output:
                raise RuntimeError("Output mismatch!")

            measurements[
                program["Optimization"]
            ].append(elapsed)

        print(
            f"Completed round {round_number + 1}/"
            f"{BENCHMARK_RUNS}"
        )

    baseline = statistics.median(
        measurements["-O0"]
    )

    results = []

    for program in programs:

        level = program["Optimization"]
        times = measurements[level]

        median_time = statistics.median(times)

        results.append({
            "Optimization": level,
            "Median Time (seconds)": median_time,
            "Mean Time (seconds)": statistics.mean(times),
            "Min Time (seconds)": min(times),
            "Max Time (seconds)": max(times),
            "Binary Size (bytes)": os.path.getsize(
                program["Executable"]
            ),
            "Speedup vs O0": baseline / median_time
        })

    with open(OUTPUT_CSV, "w", newline="") as file:

        writer = csv.DictWriter(
            file,
            fieldnames=list(results[0].keys())
        )

        writer.writeheader()
        writer.writerows(results)

    print("\n" + "=" * 60)
    print("STANDARD LLVM BENCHMARK RESULTS")
    print("=" * 60)

    for row in results:

        print(
            f"{row['Optimization']:5} | "
            f"{row['Median Time (seconds)']:.8f} sec | "
            f"{row['Speedup vs O0']:.4f}x | "
            f"{row['Binary Size (bytes)']} bytes"
        )

    print("\nSaved to:")
    print(OUTPUT_CSV)


if __name__ == "__main__":
    main()
