@tool
extends CogniteGraphNode

@onready var option_button = $OptionButton


func construct():
	if graph_resource.graph_nodes[name]["properties"].has("match"):
		option_button.selected = graph_resource.graph_nodes[name]["properties"]["match"]


func _on_option_button_item_selected(index):
	graph_resource.graph_nodes[name]["properties"]["match"] = index
