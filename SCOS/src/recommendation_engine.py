
import os
import csv
import json

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

INPUT_CSV = os.path.join(
    ROOT, "results", "fair_comparison.csv"
)

OUTPUT_DIR = os.path.join(ROOT, "results")

REPORT_FILE = os.path.join(
    OUTPUT_DIR, "scos_recommendation.txt"
)

JSON_FILE = os.path.join(
    OUTPUT_DIR, "scos_recommendation.json"
)

MIN_IMPROVEMENT = 5.0


def load_results():

    with open(INPUT_CSV, "r") as file:

        reader = csv.DictReader(file)

        return [
            {
                **row,
                "runtime": float(row["Median Time (seconds)"]),
                "speedup": float(row["Speedup vs Original O0"])
            }
            for row in reader
        ]


def main():

    results = load_results()

    baseline = next(
        row for row in results
        if row["Program"] == "Original O0 IR"
    )

    baseline_time = baseline["runtime"]

    candidates = [
        row for row in results
        if row["Program"] != "Original O0 IR"
    ]

    # Identify the fastest measured candidate
    fastest = min(
        candidates,
        key=lambda row: row["runtime"]
    )

    # Conservative recommendation threshold
    eligible = [
        row for row in candidates
        if (baseline_time - row["runtime"])
        / baseline_time * 100 >= MIN_IMPROVEMENT
    ]

    if eligible:

        recommendation = min(
            eligible,
            key=lambda row: row["runtime"]
        )

        status = "OPTIMIZATION RECOMMENDED"

    else:

        recommendation = baseline
        status = "KEEP BASELINE"

    # Identify the best custom SCOS sequence
    custom_candidates = [
        row for row in candidates
        if not row["Program"].startswith("LLVM ")
    ]

    best_custom = min(
        custom_candidates,
        key=lambda row: row["runtime"]
    )

    best_custom_improvement = (
        (baseline_time - best_custom["runtime"])
        / baseline_time
    ) * 100

    report = {
        "status": status,
        "recommended_program": recommendation["Program"],
        "baseline_runtime": baseline_time,
        "recommended_runtime": recommendation["runtime"],
        "recommended_speedup": recommendation["speedup"],
        "minimum_improvement_percent": MIN_IMPROVEMENT,
        "fastest_measured_candidate": fastest["Program"],
        "best_custom_sequence": best_custom["Program"],
        "best_custom_improvement_percent": round(
            best_custom_improvement, 2
        ),
        "eligible_candidates": [
            row["Program"] for row in eligible
        ]
    }

    # Save JSON result
    with open(JSON_FILE, "w") as file:

        json.dump(report, file, indent=4)

    # Create readable report
    lines = [
        "=" * 60,
        "SCOS OPTIMIZATION RECOMMENDATION REPORT",
        "=" * 60,
        "",
        f"Status: {status}",
        "",
        f"Baseline runtime: {baseline_time:.8f} seconds",
        f"Recommended program: {recommendation['Program']}",
        f"Recommended runtime: {recommendation['runtime']:.8f} seconds",
        f"Speedup: {recommendation['speedup']:.4f}x",
        "",
        f"Required improvement: {MIN_IMPROVEMENT:.1f}%",
        f"Fastest measured candidate: {fastest['Program']}",
        "",
        f"Best custom sequence: {best_custom['Program']}",
        f"Custom sequence improvement: {best_custom_improvement:.2f}%",
        "",
        "Decision:",
    ]

    if recommendation["Program"] == "Original O0 IR":

        lines.append(
            "No candidate passed the minimum improvement threshold."
        )

        lines.append(
            "SCOS recommends retaining the original baseline."
        )

    else:

        lines.append(
            f"SCOS recommends {recommendation['Program']}."
        )

    lines.extend([
        "",
        "Note: This recommendation is preliminary and applies",
        "only to the tested benchmark and measurement conditions.",
        "Validate with additional workloads and repeated trials.",
    ])

    with open(REPORT_FILE, "w") as file:
        file.write("\n".join(lines))

    print("\n".join(lines))

    print("\nReports saved:")
    print(REPORT_FILE)
    print(JSON_FILE)


if __name__ == "__main__":
    main()
