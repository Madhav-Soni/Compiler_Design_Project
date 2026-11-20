import os
import re
import csv

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

INPUT_IR = os.path.join(ROOT, "results", "benchmark_pass_input.ll")
PASS_DIR = os.path.join(ROOT, "results", "pass_tests")
OUTPUT_CSV = os.path.join(ROOT, "results", "ir_analysis.csv")

PASSES = [
    "mem2reg",
    "sroa",
    "instcombine",
    "simplifycfg",
    "dce",
    "adce",
    "gvn",
]


def analyze_ir(filepath):

    with open(filepath, "r") as file:
        content = file.read()

    lines = content.splitlines()

    # LLVM instructions usually begin with an assignment
    # or an instruction keyword
    instructions = [
        line.strip()
        for line in lines
        if re.match(r"^\s+%.*=\s", line)
    ]

    return {
        "IR Lines": len(lines),
        "Instructions": len(instructions),
        "Load Instructions": sum(
            " = load " in line for line in instructions
        ),
        "Store Instructions": sum(
            "store " in line for line in lines
        ),
        "Branch Instructions": sum(
            "br " in line for line in lines
        ),
        "Call Instructions": sum(
            "call " in line for line in instructions
        ),
        "IR Size (Bytes)": os.path.getsize(filepath),
    }


def main():

    files = {
        "Original": INPUT_IR
    }

    for pass_name in PASSES:

        files[pass_name] = os.path.join(
            PASS_DIR,
            f"benchmark_{pass_name}.ll"
        )

    results = []

    for name, filepath in files.items():

        metrics = analyze_ir(filepath)

        metrics["Pass"] = name

        results.append(metrics)

        print(f"\n{name}")
        print("-" * 40)

        for metric, value in metrics.items():

            if metric != "Pass":
                print(f"{metric}: {value}")

    with open(OUTPUT_CSV, "w", newline="") as file:

        fieldnames = [
            "Pass",
            "IR Lines",
            "Instructions",
            "Load Instructions",
            "Store Instructions",
            "Branch Instructions",
            "Call Instructions",
            "IR Size (Bytes)",
        ]

        writer = csv.DictWriter(
            file,
            fieldnames=fieldnames
        )

        writer.writeheader()
        writer.writerows(results)

    print(f"\nAnalysis saved to: {OUTPUT_CSV}")


if __name__ == "__main__":
    main()
