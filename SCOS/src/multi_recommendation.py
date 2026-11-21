
import os
import csv
import json
import math
from collections import defaultdict

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

INPUT_CSV = os.path.join(
    ROOT,
    "results",
    "multi_benchmark",
    "all_workloads.csv"
)

OUTPUT_DIR = os.path.join(
    ROOT,
    "results",
    "multi_benchmark"
)

OUTPUT_CSV = os.path.join(
    OUTPUT_DIR,
    "recommendations.csv"
)

OUTPUT_JSON = os.path.join(
    OUTPUT_DIR,
    "recommendations.json"
)

OUTPUT_REPORT = os.path.join(
    OUTPUT_DIR,
    "recommendation_report.txt"
)

MIN_IMPROVEMENT = 5.0


def load_results():

    grouped = defaultdict(list)

    with open(INPUT_CSV, "r") as file:

        reader = csv.DictReader(file)

        for row in reader:

            row["runtime"] = float(
                row["Median Time (seconds)"]
            )

            row["speedup"] = float(
                row["Speedup vs O0"]
            )

            grouped[row["Workload"]].append(row)

    return grouped


def calculate_geomean(values):

    if not values or any(value <= 0 for value in values):
        return None

    return math.exp(
        sum(math.log(value) for value in values) / len(values)
    )


def main():

    grouped = load_results()

    recommendations = []
    standard_results = defaultdict(list)

    print("=" * 65)
    print("SCOS MULTI-WORKLOAD RECOMMENDATION ENGINE")
    print("=" * 65)

    for workload, rows in sorted(grouped.items()):

        baseline = next(
            row for row in rows
            if row["Program"] == "Original O0"
        )

        candidates = [
            row for row in rows
            if row["Program"] != "Original O0"
        ]

        fastest = min(
            candidates,
            key=lambda row: row["runtime"]
        )

        custom_candidates = [
            row for row in candidates
            if not row["Program"].startswith("LLVM ")
        ]

        best_custom = min(
            custom_candidates,
            key=lambda row: row["runtime"]
        )

        improvement = (
            fastest["speedup"] - 1
        ) * 100

        if improvement >= MIN_IMPROVEMENT:

            selected = fastest
            status = "OPTIMIZATION RECOMMENDED"

        else:

            selected = baseline
            status = "KEEP BASELINE"

        record = {
            "Workload": workload,
            "Status": status,
            "Recommended Program": selected["Program"],
            "Baseline Runtime": baseline["runtime"],
            "Recommended Runtime": selected["runtime"],
            "Speedup": selected["speedup"],
            "Improvement (%)": (
                selected["speedup"] - 1
            ) * 100,
            "Best Custom Sequence": best_custom["Program"],
            "Best Custom Speedup": best_custom["speedup"],
            "Fastest Measured Candidate": fastest["Program"],
            "Fastest Candidate Speedup": fastest["speedup"],
        }

        recommendations.append(record)

        print(f"\nWORKLOAD: {workload.upper()}")
        print("-" * 55)
        print(f"Status: {status}")
        print(f"Recommendation: {selected['Program']}")
        print(f"Speedup: {selected['speedup']:.4f}x")
        print(f"Best custom: {best_custom['Program']}")
        print(f"Best custom speedup: {best_custom['speedup']:.4f}x")

        # Collect standard LLVM results for cross-workload analysis
        for row in candidates:

            if row["Program"] in ["LLVM O1", "LLVM O2", "LLVM O3"]:

                standard_results[row["Program"]].append(
                    row["speedup"]
                )

    # Save workload-specific recommendations
    with open(OUTPUT_CSV, "w", newline="") as file:

        writer = csv.DictWriter(
            file,
            fieldnames=list(recommendations[0].keys())
        )

        writer.writeheader()
        writer.writerows(recommendations)

    # Calculate aggregate standard LLVM performance
    aggregate = {}

    print("\n" + "=" * 65)
    print("CROSS-WORKLOAD LLVM PERFORMANCE")
    print("=" * 65)

    for strategy, speedups in sorted(standard_results.items()):

        score = calculate_geomean(speedups)

        aggregate[strategy] = {
            "geometric_mean_speedup": round(score, 4),
            "workloads_evaluated": len(speedups)
        }

        print(
            f"{strategy}: {score:.4f}x "
            f"geometric mean across {len(speedups)} workloads"
        )

    output = {
        "minimum_improvement_threshold_percent": MIN_IMPROVEMENT,
        "workload_recommendations": recommendations,
        "standard_llvm_cross_workload_comparison": aggregate,
        "note": (
            "Recommendations apply to the tested workloads and "
            "measurement conditions. Validate with further trials."
        )
    }

    with open(OUTPUT_JSON, "w") as file:

        json.dump(output, file, indent=4)

    # Human-readable report
    with open(OUTPUT_REPORT, "w") as file:

        file.write("SCOS MULTI-WORKLOAD RECOMMENDATION REPORT\n")
        file.write("=" * 60 + "\n\n")

        for record in recommendations:

            file.write(f"Workload: {record['Workload']}\n")
            file.write(f"Status: {record['Status']}\n")
            file.write(
                f"Recommendation: {record['Recommended Program']}\n"
            )
            file.write(f"Speedup: {record['Speedup']:.4f}x\n")
            file.write(
                f"Best custom sequence: {record['Best Custom Sequence']}\n"
            )
            file.write(
                f"Best custom speedup: {record['Best Custom Speedup']:.4f}x\n"
            )
            file.write("-" * 60 + "\n")

        file.write("\nCROSS-WORKLOAD LLVM COMPARISON\n")

        for strategy, metrics in aggregate.items():

            file.write(
                f"{strategy}: "
                f"{metrics['geometric_mean_speedup']:.4f}x\n"
            )

        file.write(
            "\nRecommendations are experimental and require "
            "validation on additional inputs and machines.\n"
        )

    print("\nReports saved:")
    print(OUTPUT_CSV)
    print(OUTPUT_JSON)
    print(OUTPUT_REPORT)


if __name__ == "__main__":
    main()
