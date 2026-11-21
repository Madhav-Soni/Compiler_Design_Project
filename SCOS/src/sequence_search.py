
import os
import csv
import subprocess
from itertools import permutations

from pair_metrics import analyze_ir

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

LLVM_BIN = subprocess.check_output(
    ["brew", "--prefix", "llvm"],
    text=True
).strip() + "/bin"

OPT = os.path.join(LLVM_BIN, "opt")

INPUT_IR = os.path.join(
    ROOT,
    "results",
    "benchmark_pass_input.ll"
)

SEQUENCE_DIR = os.path.join(
    ROOT,
    "results",
    "sequences"
)

OUTPUT_CSV = os.path.join(
    SEQUENCE_DIR,
    "sequence_results.csv"
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

os.makedirs(SEQUENCE_DIR, exist_ok=True)


def evaluate_sequence(sequence):

    sequence_name = "__".join(sequence)

    output_file = os.path.join(
        SEQUENCE_DIR,
        f"{sequence_name}.ll"
    )

    pipeline = ",".join(sequence)

    command = [
        OPT,
        f"-passes={pipeline}",
        INPUT_IR,
        "-S",
        "-o",
        output_file
    ]

    subprocess.run(
        command,
        check=True,
        capture_output=True,
        text=True
    )

    metrics = analyze_ir(output_file)

    return {
        "Sequence Length": len(sequence),
        "Sequence": " -> ".join(sequence),
        **metrics
    }


def main():

    print("=" * 65)
    print("SCOS OPTIMIZATION SEQUENCE SEARCH ENGINE")
    print("=" * 65)

    baseline = analyze_ir(INPUT_IR)

    results = []
    failed = 0

    for length in [2, 3]:

        sequences = list(permutations(PASSES, length))

        print(
            f"\nTesting {len(sequences)} sequences "
            f"of length {length}..."
        )

        for sequence in sequences:

            try:

                metrics = evaluate_sequence(sequence)

                metrics["Instruction Reduction"] = (
                    baseline["Instructions"]
                    - metrics["Instructions"]
                )

                metrics["IR Size Reduction"] = (
                    baseline["IR Size"]
                    - metrics["IR Size"]
                )

                results.append(metrics)

            except subprocess.CalledProcessError as error:

                failed += 1

                print(
                    f"Failed: {' -> '.join(sequence)}"
                )

    # Rank by instruction count, then IR size.
    # This is structural ranking, not runtime ranking.
    results.sort(
        key=lambda row: (
            row["Instructions"],
            row["IR Size"]
        )
    )

    if not results:
        raise RuntimeError("No optimization sequences succeeded.")

    fieldnames = [
        "Sequence Length",
        "Sequence",
        "Instructions",
        "Loads",
        "Stores",
        "Branches",
        "Calls",
        "IR Size",
        "Instruction Reduction",
        "IR Size Reduction",
    ]

    with open(OUTPUT_CSV, "w", newline="") as file:

        writer = csv.DictWriter(
            file,
            fieldnames=fieldnames
        )

        writer.writeheader()
        writer.writerows(results)

    print("\nTOP 15 STRUCTURAL CANDIDATES")
    print("-" * 65)

    for index, row in enumerate(results[:15], start=1):

        print(
            f"{index:2}. {row['Sequence']}"
            f" | Instructions: {row['Instructions']}"
            f" | IR Size: {row['IR Size']} bytes"
        )

    print("\nSuccessful sequences:", len(results))
    print("Failed sequences:", failed)
    print("\nResults saved to:")
    print(OUTPUT_CSV)


if __name__ == "__main__":
    main()
