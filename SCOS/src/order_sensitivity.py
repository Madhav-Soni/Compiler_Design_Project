import os
import csv
from itertools import combinations

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

INPUT_CSV = os.path.join(
    ROOT,
    "results",
    "dependencies",
    "dependency_results.csv"
)

OUTPUT_CSV = os.path.join(
    ROOT,
    "results",
    "dependencies",
    "order_sensitivity.csv"
)


def load_results():

    results = {}

    with open(INPUT_CSV, "r") as file:

        reader = csv.DictReader(file)

        for row in reader:

            key = (row["Pass A"], row["Pass B"])

            results[key] = int(row["IR Size"])

    return results


def main():

    results = load_results()

    passes = sorted(
        set(pass_a for pass_a, pass_b in results.keys())
    )

    sensitivity_results = []

    print("SCOS PASS ORDER SENSITIVITY ANALYSIS")
    print("=" * 60)

    for pass_a, pass_b in combinations(passes, 2):

        size_ab = results[(pass_a, pass_b)]
        size_ba = results[(pass_b, pass_a)]

        difference = abs(size_ab - size_ba)

        result = {
            "Pass A": pass_a,
            "Pass B": pass_b,
            "A then B": size_ab,
            "B then A": size_ba,
            "Sensitivity Score": difference
        }

        sensitivity_results.append(result)

        print(
            f"{pass_a:15} <-> {pass_b:15} "
            f"| Score: {difference}"
        )

    sensitivity_results.sort(
        key=lambda x: x["Sensitivity Score"],
        reverse=True
    )

    print("\nMOST ORDER-SENSITIVE PASS PAIRS")
    print("=" * 60)

    for result in sensitivity_results:

        if result["Sensitivity Score"] > 0:

            print(
                f"{result['Pass A']} <-> {result['Pass B']} "
                f"| {result['Sensitivity Score']} bytes"
            )

    with open(OUTPUT_CSV, "w", newline="") as file:

        fieldnames = [
            "Pass A",
            "Pass B",
            "A then B",
            "B then A",
            "Sensitivity Score"
        ]

        writer = csv.DictWriter(
            file,
            fieldnames=fieldnames
        )

        writer.writeheader()
        writer.writerows(sensitivity_results)

    print(f"\nSaved to: {OUTPUT_CSV}")


if __name__ == "__main__":
    main()
