
import os
import re
import csv
from itertools import combinations

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

DEPENDENCY_DIR = os.path.join(
    ROOT, "results", "dependencies"
)

OUTPUT_CSV = os.path.join(
    DEPENDENCY_DIR, "multimetric_sensitivity.csv"
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

METRICS = [
    "Instructions",
    "Loads",
    "Stores",
    "Branches",
    "Calls",
    "IR Size",
]


def analyze_ir(filepath):

    with open(filepath, "r") as file:
        lines = file.readlines()

    instructions = []
    inside_function = False

    for line in lines:

        stripped = line.strip()

        if stripped.startswith("define "):
            inside_function = True
            continue

        if inside_function and stripped == "}":
            inside_function = False
            continue

        if not inside_function:
            continue

        if (
            not stripped
            or stripped.startswith(";")
            or stripped.endswith(":")
        ):
            continue

        instructions.append(stripped)

    return {
        "Instructions": len(instructions),

        "Loads": sum(
            bool(re.search(r"\bload\b", line))
            for line in instructions
        ),

        "Stores": sum(
            bool(re.search(r"\bstore\b", line))
            for line in instructions
        ),

        "Branches": sum(
            bool(re.search(
                r"\b(br|switch|indirectbr)\b", line
            ))
            for line in instructions
        ),

        "Calls": sum(
            bool(re.search(
                r"\b(call|invoke|callbr)\b", line
            ))
            for line in instructions
        ),

        "IR Size": os.path.getsize(filepath),
    }


def normalized_difference(value_a, value_b):

    denominator = max(abs(value_a), abs(value_b), 1)

    return (
        abs(value_a - value_b) / denominator
    ) * 100


def main():

    results = []

    print("=" * 65)
    print("SCOS MULTI-METRIC PASS ORDER ANALYSIS")
    print("=" * 65)

    for pass_a, pass_b in combinations(PASSES, 2):

        path_ab = os.path.join(
            DEPENDENCY_DIR,
            f"{pass_a}_{pass_b}.ll"
        )

        path_ba = os.path.join(
            DEPENDENCY_DIR,
            f"{pass_b}_{pass_a}.ll"
        )

        if not os.path.exists(path_ab) or not os.path.exists(path_ba):
            raise FileNotFoundError(
                f"Missing pipeline output for {pass_a}, {pass_b}"
            )

        metrics_ab = analyze_ir(path_ab)
        metrics_ba = analyze_ir(path_ba)

        differences = {}

        for metric in METRICS:

            differences[metric] = normalized_difference(
                metrics_ab[metric],
                metrics_ba[metric]
            )

        # Equal-weight average of the six normalized differences.
        # This is a heuristic sensitivity score, not a proven dependency.
        overall_score = sum(
            differences.values()
        ) / len(METRICS)

        row = {
            "Pass A": pass_a,
            "Pass B": pass_b,
        }

        for metric in METRICS:

            row[f"{metric} - A then B"] = metrics_ab[metric]
            row[f"{metric} - B then A"] = metrics_ba[metric]
            row[f"{metric} Sensitivity (%)"] = round(
                differences[metric], 2
            )

        row["Overall Sensitivity Score"] = round(
            overall_score, 2
        )

        results.append(row)

    results.sort(
        key=lambda row: row["Overall Sensitivity Score"],
        reverse=True
    )

    with open(OUTPUT_CSV, "w", newline="") as file:

        writer = csv.DictWriter(
            file,
            fieldnames=list(results[0].keys())
        )

        writer.writeheader()
        writer.writerows(results)

    print("\nPASS PAIR SENSITIVITY RANKING")
    print("-" * 65)

    for row in results:

        print(
            f"{row['Pass A']:15} <-> "
            f"{row['Pass B']:15} | "
            f"Score: {row['Overall Sensitivity Score']:.2f}"
        )

    print("\nSaved results:")
    print(OUTPUT_CSV)


if __name__ == "__main__":
    main()

