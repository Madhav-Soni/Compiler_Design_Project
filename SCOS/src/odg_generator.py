
import os
import csv
import networkx as nx
import matplotlib.pyplot as plt

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

INPUT_CSV = os.path.join(
    ROOT,
    "results",
    "dependencies",
    "order_sensitivity.csv"
)

GRAPH_DIR = os.path.join(ROOT, "graphs")

os.makedirs(GRAPH_DIR, exist_ok=True)

OUTPUT_PNG = os.path.join(
    GRAPH_DIR,
    "optimization_dependence_graph.png"
)

OUTPUT_GRAPHML = os.path.join(
    GRAPH_DIR,
    "optimization_dependence_graph.graphml"
)


def build_graph():

    graph = nx.Graph()

    with open(INPUT_CSV, "r") as file:

        reader = csv.DictReader(file)

        for row in reader:

            pass_a = row["Pass A"]
            pass_b = row["Pass B"]

            score = int(row["Sensitivity Score"])

            graph.add_node(pass_a)
            graph.add_node(pass_b)

            # Ignore pairs with zero measured sensitivity
            if score > 0:

                graph.add_edge(
                    pass_a,
                    pass_b,
                    weight=score
                )

    return graph




def generate_visualization(graph):

    if graph.number_of_edges() == 0:
        raise ValueError("No positive-sensitivity edges found.")

    # Identify connected components
    components = sorted(
        nx.connected_components(graph),
        key=len,
        reverse=True
    )

    position = {}

    # Arrange the largest connected component in a circle
    main_graph = graph.subgraph(components[0])

    main_position = nx.circular_layout(
        main_graph,
        scale=2.5
    )

    position.update(main_position)

    # Position remaining components separately
    for index, component in enumerate(components[1:]):

        subgraph = graph.subgraph(component)

        center_x = -4.2 if index % 2 == 0 else 4.2
        center_y = 2.8

        sub_position = nx.circular_layout(
            subgraph,
            scale=0.7
        )

        for node, (x, y) in sub_position.items():

            position[node] = (
                x + center_x,
                y + center_y
            )

    edge_weights = [
        data["weight"]
        for _, _, data in graph.edges(data=True)
    ]

    max_weight = max(edge_weights)

    edge_widths = [
        1.5 + 4 * (weight / max_weight)
        for weight in edge_weights
    ]

    plt.figure(figsize=(14, 10))

    # Draw edges
    nx.draw_networkx_edges(
        graph,
        position,
        width=edge_widths,
        edge_color="steelblue",
        alpha=0.75
    )

    # Draw nodes
    nx.draw_networkx_nodes(
        graph,
        position,
        node_size=2800,
        node_color="skyblue",
        edgecolors="black",
        linewidths=1.5
    )

    # Draw node labels
    nx.draw_networkx_labels(
        graph,
        position,
        font_size=10,
        font_weight="bold"
    )

    # Draw edge weights
    edge_labels = {
        (u, v): f"{data['weight']} bytes"
        for u, v, data in graph.edges(data=True)
    }

    nx.draw_networkx_edge_labels(
        graph,
        position,
        edge_labels=edge_labels,
        font_size=9,
        rotate=False,
        bbox={
            "facecolor": "white",
            "edgecolor": "none",
            "alpha": 0.9,
            "pad": 2
        }
    )

    plt.title(
        "SCOS - Optimization Pass Order Sensitivity Graph",
        fontsize=15,
        fontweight="bold",
        pad=20
    )

    plt.axis("off")
    plt.tight_layout()

    plt.savefig(
        OUTPUT_PNG,
        dpi=300,
        bbox_inches="tight"
    )

    plt.close()



def main():

    print("=" * 55)
    print("SCOS OPTIMIZATION DEPENDENCE GRAPH GENERATOR")
    print("=" * 55)

    if not os.path.exists(INPUT_CSV):
        raise FileNotFoundError(
            f"Missing input file: {INPUT_CSV}"
        )

    graph = build_graph()

    generate_visualization(graph)

    nx.write_graphml(graph, OUTPUT_GRAPHML)

    print(f"Nodes: {graph.number_of_nodes()}")
    print(f"Edges: {graph.number_of_edges()}")

    print("\nPass relationships:")

    for u, v, data in sorted(
        graph.edges(data=True),
        key=lambda edge: edge[2]["weight"],
        reverse=True
    ):

        print(
            f"{u} <-> {v}: "
            f"{data['weight']} bytes"
        )

    print("\nGraph saved successfully:")
    print(OUTPUT_PNG)

    print("\nGraphML saved:")
    print(OUTPUT_GRAPHML)


if __name__ == "__main__":
    main()

