import subprocess
import time
import statistics
import csv
import os

# Project paths
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SOURCE = os.path.join(ROOT, "benchmarks", "benchmark.c")
RESULTS_DIR = os.path.join(ROOT, "results")

# LLVM compiler
LLVM_BIN = subprocess.check_output(
    ["brew", "--prefix", "llvm"],
    text=True
).strip() + "/bin"

CLANG = os.path.join(LLVM_BIN, "clang")

# Optimization levels to test
OPTIMIZATION_LEVELS = ["-O0", "-O1", "-O2", "-O3"]

# Number of executions for each binary
RUNS = 7


def compile_program(level):
    """Compile the C benchmark with a given optimization level."""

    executable = os.path.join(
        RESULTS_DIR,
        f"benchmark_{level.replace('-', '')}"
    )

    command = [
        CLANG,
        SOURCE,
        level,
        "-o",
        executable
    ]

    subprocess.run(command, check=True, capture_output=True)

    return executable


def execute_program(executable):
    """Execute program and return its output and execution time."""

    start = time.perf_counter()

    result = subprocess.run(
        [executable],
        capture_output=True,
        text=True,
        check=True
    )

    end = time.perf_counter()

    return result.stdout, end - start


def benchmark(executable):
    """Run program multiple times and calculate median time."""

    times = []
    expected_output = None

    for _ in range(RUNS):
        output, execution_time = execute_program(executable)

        # Verify output consistency
        if expected_output is None:
            expected_output = output
        elif output != expected_output:
            raise RuntimeError("Output mismatch detected!")

        times.append(execution_time)

    return statistics.median(times), expected_output


def main():

    results = []

    print("=" * 60)
    print("       SCOS COMPILER BENCHMARK ENGINE")
    print("=" * 60)

    for level in OPTIMIZATION_LEVELS:

        print(f"\nTesting {level}...")

        executable = compile_program(level)

        median_time, output = benchmark(executable)

        binary_size = os.path.getsize(executable)

        result = {
            "Optimization": level,
            "Median Time (seconds)": median_time,
            "Binary Size (bytes)": binary_size
        }

        results.append(result)

        print(f"Median execution time: {median_time:.8f} seconds")
        print(f"Binary size: {binary_size} bytes")

    # Save results to CSV
    csv_path = os.path.join(RESULTS_DIR, "benchmark_results.csv")

    with open(csv_path, "w", newline="") as file:

        writer = csv.DictWriter(
            file,
            fieldnames=[
                "Optimization",
                "Median Time (seconds)",
                "Binary Size (bytes)"
            ]
        )

        writer.writeheader()
        writer.writerows(results)

    # Display summary
    print("\n" + "=" * 60)
    print("BENCHMARK SUMMARY")
    print("=" * 60)

    for result in results:
        print(
            f"{result['Optimization']:>4} | "
            f"{result['Median Time (seconds)']:.8f} sec | "
            f"{result['Binary Size (bytes)']} bytes"
        )

    print(f"\nResults saved to: {csv_path}")


if __name__ == "__main__":
    main()
