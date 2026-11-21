import streamlit as st
import pandas as pd
import os
import json
import matplotlib.pyplot as plt

# Project paths
ROOT = os.path.dirname(os.path.abspath(__file__))

RESULTS = os.path.join(
    ROOT, "results", "multi_benchmark"
)

COMBINED_CSV = os.path.join(
    RESULTS, "all_workloads.csv"
)

RECOMMENDATIONS_CSV = os.path.join(
    RESULTS, "recommendations.csv"
)

GRAPH_IMAGE = os.path.join(
    ROOT, "graphs", "multimetric_optimization_graph.png"
)

# Page configuration
st.set_page_config(
    page_title="SCOS Dashboard",
    page_icon="⚙️",
    layout="wide"
)

# Load data
@st.cache_data
def load_data():

    performance = pd.read_csv(COMBINED_CSV)
    recommendations = pd.read_csv(RECOMMENDATIONS_CSV)

    return performance, recommendations


st.title("⚙️ SCOS")
st.subheader("Smart Compiler Optimization System")

st.markdown(
    "Analyze compiler optimization passes, compare performance "
    "and explore workload-specific recommendations."
)

if not os.path.exists(COMBINED_CSV):
    st.error("Benchmark results not found. Run multi_benchmark.py first.")
    st.stop()

if not os.path.exists(RECOMMENDATIONS_CSV):
    st.error("Recommendations not found. Run multi_recommendation.py first.")
    st.stop()

performance, recommendations = load_data()

# Sidebar navigation
st.sidebar.title("SCOS Navigation")

page = st.sidebar.radio(
    "Select Dashboard",
    [
        "Overview",
        "Performance Analysis",
        "Recommendations",
        "Optimization Graph",
        "Reports"
    ]
)

# Overview

# Overview
if page == "Overview":

    st.header("SCOS Project Overview")

    st.markdown(
        "An experimental compiler optimization system that "
        "analyzes LLVM passes, evaluates optimization sequences, "
        "and recommends strategies using benchmark results."
    )

    st.divider()

    # KPI cards
    col1, col2, col3, col4 = st.columns(4)

    col1.metric(
        "Benchmark Workloads",
        performance["Workload"].nunique()
    )

    col2.metric(
        "Optimization Passes",
        7
    )

    col3.metric(
        "Sequences Evaluated",
        performance["Workload"].nunique() * 252
    )

    col4.metric(
        "Performance Records",
        len(performance)
    )

    st.divider()

    # Cross-workload performance comparison
    st.subheader("Compiler Performance Across Workloads")

    standard = performance[
        performance["Program"].isin(
            ["LLVM O1", "LLVM O2", "LLVM O3"]
        )
    ]

    speedup_table = standard.pivot(
        index="Workload",
        columns="Program",
        values="Speedup vs O0"
    )

    speedup_table = speedup_table[
        ["LLVM O1", "LLVM O2", "LLVM O3"]
    ]

    st.caption(
        "Speedup relative to the unoptimized O0 baseline. "
        "Values above 1.0 indicate faster execution."
    )

    # Grouped performance comparison chart

    fig, ax = plt.subplots(figsize=(12, 5))

    fig.patch.set_facecolor("#0e1117")
    ax.set_facecolor("#0e1117")

    x = range(len(speedup_table.index))
    width = 0.23

    colors = ["#56B4E9", "#E69F00", "#009E73"]

    for i, level in enumerate(["LLVM O1", "LLVM O2", "LLVM O3"]):

        values = speedup_table[level]

        bars = ax.bar(
            [position + (i - 1) * width for position in x],
            values,
            width,
            label=level,
            color=colors[i]
        )

        ax.bar_label(
            bars,
            fmt="%.2fx",
            padding=3,
            fontsize=8,
            color="white"
        )

    ax.axhline(
        y=1.0,
        color="white",
        linestyle="--",
        alpha=0.6,
        label="Baseline (1.0x)"
    )

    ax.set_xticks(list(x))
    ax.set_xticklabels(
        [name.replace("_", " ").title()
        for name in speedup_table.index],
        color="white"
    )

    ax.set_ylabel("Speedup vs O0", color="white")
    ax.set_title(
        "LLVM Optimization Performance Across Workloads",
        color="white"
    )

    ax.tick_params(axis="y", colors="white")

    ax.legend(
        facecolor="#161B22",
        labelcolor="white"
    )

    ax.grid(axis="y", alpha=0.2)
    ax.set_axisbelow(True)

    fig.tight_layout()

    st.pyplot(fig, width="stretch")

    plt.close(fig)

    st.divider()

    # Workload recommendations
    st.subheader("Workload-Specific Recommendations")

    display_recommendations = recommendations[
        [
            "Workload",
            "Status",
            "Recommended Program",
            "Speedup",
            "Best Custom Sequence"
        ]
    ].copy()

    st.dataframe(
        display_recommendations,
        hide_index=True,
        width="stretch"
    )

    st.divider()

    # Project methodology
    st.subheader("How SCOS Works")

    col1, col2 = st.columns(2)

    with col1:

        st.markdown("### 01. LLVM IR Analysis")

        st.write(
            "Converts C programs into LLVM Intermediate "
            "Representation and analyzes instruction-level changes."
        )

        st.markdown("### 02. Pass Interaction Analysis")

        st.write(
            "Studies how optimization-pass ordering affects "
            "multiple LLVM IR characteristics."
        )

    with col2:

        st.markdown("### 03. Sequence Exploration")

        st.write(
            "Evaluates ordered combinations of LLVM optimization "
            "passes and identifies promising candidates."
        )

        st.markdown("### 04. Performance Recommendations")

        st.write(
            "Benchmarks candidate sequences against standard "
            "LLVM pipelines and generates workload-specific recommendations."
        )

    st.divider()

    st.caption(
        "SCOS | Smart Compiler Optimization System | "
        "Compiler Design Research Project"
    )

# Performance analysis
elif page == "Performance Analysis":

    st.header("Performance Analysis")

    workload = st.selectbox(
        "Select Benchmark Workload",
        sorted(performance["Workload"].unique())
    )

    filtered = performance[
        performance["Workload"] == workload
    ].sort_values("Median Time (seconds)")

    st.subheader(f"Results: {workload.replace('_', ' ').title()}")

    # Prepare chart data
    chart_data = filtered.head(10).copy()

    chart_data["Program Label"] = chart_data["Program"].apply(
        lambda name: name if len(name) <= 40 else name[:37] + "..."
    )

    # Create horizontal bar chart
    fig, ax = plt.subplots(figsize=(12, 6))

    fig.patch.set_facecolor("#0e1117")
    ax.set_facecolor("#0e1117")

    ax.barh(
        chart_data["Program Label"],
        chart_data["Median Time (seconds)"],
        color="#56B4E9"
    )

    ax.invert_yaxis()

    ax.set_xlabel(
        "Median Execution Time (seconds)",
        color="white"
    )

    ax.set_title(
        "Optimization Performance Comparison",
        color="white"
    )

    ax.tick_params(axis="both", colors="white")

    for spine in ax.spines.values():
        spine.set_color("#555555")

    ax.grid(axis="x", alpha=0.2)
    ax.set_axisbelow(True)

    fig.tight_layout()

    st.pyplot(fig, width="stretch")

    plt.close(fig)

    st.subheader("Detailed Results")

    st.dataframe(
        filtered,
        hide_index=True,
        width="stretch"
    )

# Recommendations
elif page == "Recommendations":

    st.header("Optimization Recommendations")

    for _, row in recommendations.iterrows():

        with st.container(border=True):

            st.subheader(
                row["Workload"].replace("_", " ").title()
            )

            st.write("**Status:**", row["Status"])

            st.write(
                "**Recommended Strategy:**",
                row["Recommended Program"]
            )

            st.metric(
                "Speedup vs Original O0",
                f"{row['Speedup']:.4f}x",
                f"{row['Improvement (%)']:.2f}%"
            )

            st.write(
                "**Best Custom Sequence:**",
                row["Best Custom Sequence"]
            )

            st.write(
                "**Best Custom Speedup:**",
                f"{row['Best Custom Speedup']:.4f}x"
            )

    st.caption(
        "Recommendations are experimental and apply to the "
        "benchmark workloads and measurement conditions tested."
    )


# Optimization graph
elif page == "Optimization Graph":

    st.header("Optimization Dependence Graph")

    if os.path.exists(GRAPH_IMAGE):

        st.image(
            GRAPH_IMAGE,
            caption="Multi-Metric Pass Order Sensitivity Graph",
            width="stretch"
        )

    else:

        st.warning("Optimization graph has not been generated yet.")

    st.write(
        "Nodes represent LLVM optimization passes. "
        "Weighted edges represent measured pass-order sensitivity."
    )


# Reports
elif page == "Reports":

    st.header("Download SCOS Reports")

    files = [
        (
            "Combined Benchmark Results",
            COMBINED_CSV,
            "all_workloads.csv"
        ),
        (
            "Workload Recommendations",
            RECOMMENDATIONS_CSV,
            "recommendations.csv"
        ),
        (
            "Recommendation JSON",
            os.path.join(RESULTS, "recommendations.json"),
            "recommendations.json"
        ),
        (
            "Recommendation Report",
            os.path.join(RESULTS, "recommendation_report.txt"),
            "recommendation_report.txt"
        )
    ]

    for label, path, filename in files:

        if os.path.exists(path):

            with open(path, "rb") as file:

                st.download_button(
                    label=f"Download {label}",
                    data=file.read(),
                    file_name=filename,
                    key=filename
                )

        else:

            st.warning(f"{filename} is not available.")

st.sidebar.divider()
st.sidebar.caption("SCOS | Compiler Design Research Project")
