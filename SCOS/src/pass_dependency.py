import subprocess
import os
import csv

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

LLVM_BIN = subprocess.check_output(
    ["brew", "--prefix", "llvm"],
    text=True
).strip() + "/bin"

OPT = os.path.join(LLVM_BIN, "opt")

INPUT_IR = os.path.join(ROOT, "results", "benchmark_pass_input.ll")
OUTPUT_DIR = os.path.join(ROOT, "results", "dependencies")

PASSES = [
    "mem2reg",
    "sroa",
    "instcombine",
    "simplifycfg",
    "dce",
    "adce",
    "gvn",
]

os.makedirs(OUTPUT_DIR, exist_ok=True)


def run_pipeline(pipeline, output_file):

    command = [
        OPT,
        f"-passes={pipeline}",
        INPUT_IR,
        "-S",
        "-o",
        output_file
    ]

    subprocess.run(command, check=True, capture_output=True)


def get_size(filepath):

    return os.path.getsize(filepath)


def main():

    results = []

    print("SCOS PASS ORDER DEPENDENCY ANALYSIS")
    print("=" * 50)

    for pass_a in PASSES:

        for pass_b in PASSES:

            if pass_a == pass_b:
                continue

            pipeline = f"{pass_a},{pass_b}"

            output_file = os.path.join(
                OUTPUT_DIR,
                f"{pass_a}_{pass_b}.ll"
            )

            try:

                run_pipeline(pipeline, output_file)

                size = get_size(output_file)

                result = {
                    "Pass A": pass_a,
                    "Pass B": pass_b,
                    "Pipeline": pipeline,
                    "IR Size": size
                }

                results.append(result)

                print(
                    f"{pass_a:15} -> {pass_b:15} "
                    f"| IR Size: {size} bytes"
                )

            except subprocess.CalledProcessError as error:

                print(f"FAILED: {pipeline}")
                print(error.stderr.decode())

    csv_path = os.path.join(
        OUTPUT_DIR,
        "dependency_results.csv"
    )

    with open(csv_path, "w", newline="") as file:

        writer = csv.DictWriter(
            file,
            fieldnames=[
                "Pass A",
                "Pass B",
                "Pipeline",
                "IR Size"
            ]
        )

        writer.writeheader()
        writer.writerows(results)

    print("\nResults saved to:")
    print(csv_path)


if __name__ == "__main__":
    main()
