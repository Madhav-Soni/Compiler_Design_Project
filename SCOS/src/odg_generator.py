
import os
import csv
import networkx as nx
import matplotlib.pyplot as plt

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

INPUT_CSV = os.path.join(
    ROOT,
    "results",
    "dependencies",
    "multimetric_sensitivity.csv"
)

GRAPH_DIR = os.path.join(ROOT, "graphs")
os.makedirs(GRAPH_DIR, exist_ok=True)

OUTPUT_PNG = os.path.join(
    GRAPH_DIR,
    "multimetric_optimization_graph.png"
)

OUTPUT_GRAPHML = os.path.join(
    GRAPH_DIR,
    "multimetric_optimization_graph.graphml"
)


def build_graph():

    graph = nx.Graph()

    with open(INPUT_CSV, "r") as file:

        reader = csv.DictReader(file)

        for row in reader:

            pass_a = row["Pass A"]
            pass_b = row["Pass B"]

            score = float(
                row["Overall Sensitivity Score"]
            )

            graph.add_node(pass_a)
            graph.add_node(pass_b)

            if score > 0:

                graph.add_edge(
                    pass_a,
                    pass_b,
                    weight=score
                )

    return graph


def calculate_positions(graph):

    components = sorted(
        nx.connected_components(graph),
        key=len,
        reverse=True
    )

    position = {}

    # Main connected component
    main_graph = graph.subgraph(components[0])

    main_position = nx.circular_layout(
        main_graph,
        scale=2.5
    )

    position.update(main_position)

    # Place disconnected nodes separately
    isolated_nodes = [
        node for node in graph.nodes()
        if graph.degree(node) == 0
    ]

    for index, node in enumerate(isolated_nodes):

        x = -4.0 + index * 8.0
        position[node] = (x, 3.0)

    return position


def generate_visualization(graph):

    if graph.number_of_edges() == 0:
        raise ValueError("No positive-sensitivity edges found.")

    position = calculate_positions(graph)

    edge_weights = [
        data["weight"]
        for _, _, data in graph.edges(data=True)
    ]

    max_weight = max(edge_weights)

    edge_widths = [
        1.5 + 5 * (weight / max_weight)
        for weight in edge_weights
    ]

    fig, ax = plt.subplots(
        figsize=(14, 10),
        facecolor="#0e1117"
    )

    ax.set_facecolor("#0e1117")

    nx.draw_networkx_edges(
        graph,
        position,
        width=edge_widths,
        edge_color="#56B4E9",
        alpha=0.8,
        ax=ax
    )

    nx.draw_networkx_nodes(
        graph,
        position,
        node_size=2800,
        node_color="#176B87",
        edgecolors="#56B4E9",
        linewidths=2,
        ax=ax
    )

    nx.draw_networkx_labels(
        graph,
        position,
        font_size=10,
        font_weight="bold",
        font_color="white",
        ax=ax
    )

    edge_labels = {
        (u, v): f"{data['weight']:.2f}"
        for u, v, data in graph.edges(data=True)
    }

    nx.draw_networkx_edge_labels(
        graph,
        position,
        edge_labels=edge_labels,
        font_size=9,
        font_color="white",
        rotate=False,
        bbox={
            "facecolor": "#161B22",
            "edgecolor": "none",
            "alpha": 0.95,
            "pad": 3
        },
        ax=ax
    )

    ax.set_title(
        "SCOS - Multi-Metric Pass Order Sensitivity Graph",
        fontsize=15,
        fontweight="bold",
        color="white",
        pad=20
    )

    ax.axis("off")
    fig.tight_layout()

    plt.savefig(
        OUTPUT_PNG,
        dpi=300,
        bbox_inches="tight",
        facecolor=fig.get_facecolor()
    )

    plt.close(fig)

def main():

    print("=" * 60)
    print("SCOS MULTI-METRIC GRAPH GENERATOR")
    print("=" * 60)

    graph = build_graph()

    generate_visualization(graph)

    nx.write_graphml(graph, OUTPUT_GRAPHML)

    print(f"Nodes: {graph.number_of_nodes()}")
    print(f"Edges: {graph.number_of_edges()}")

    print("\nPass interactions:")

    for u, v, data in sorted(
        graph.edges(data=True),
        key=lambda edge: edge[2]["weight"],
        reverse=True
    ):

        print(
            f"{u} <-> {v}: "
            f"{data['weight']:.2f}"
        )

    print("\nPNG saved:", OUTPUT_PNG)
    print("GraphML saved:", OUTPUT_GRAPHML)


if __name__ == "__main__":
    main()
