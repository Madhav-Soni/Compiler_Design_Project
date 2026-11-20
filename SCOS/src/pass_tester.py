import subprocess
import os

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

LLVM_BIN = subprocess.check_output(
    ["brew", "--prefix", "llvm"],
    text=True
).strip() + "/bin"

OPT = os.path.join(LLVM_BIN, "opt")

INPUT_IR = os.path.join(ROOT, "results", "benchmark_pass_input.ll")
OUTPUT_DIR = os.path.join(ROOT, "results", "pass_tests")

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


def run_pass(pass_name):

    output_file = os.path.join(
        OUTPUT_DIR,
        f"benchmark_{pass_name}.ll"
    )

    command = [
        OPT,
        f"-passes={pass_name}",
        INPUT_IR,
        "-S",
        "-o",
        output_file
    ]

    subprocess.run(command, check=True)

    input_size = os.path.getsize(INPUT_IR)
    output_size = os.path.getsize(output_file)

    print(f"Pass: {pass_name}")
    print(f"Input IR size:  {input_size} bytes")
    print(f"Output IR size: {output_size} bytes")
    print(f"Saved: {output_file}")
    print("-" * 40)


def main():

    print("SCOS INDIVIDUAL PASS TESTER")
    print("=" * 40)

    for pass_name in PASSES:

        try:
            run_pass(pass_name)

        except subprocess.CalledProcessError:
            print(f"Pass failed: {pass_name}")
            print("-" * 40)


if __name__ == "__main__":
    main()
