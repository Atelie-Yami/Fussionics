@tool
extends CogniteGraphNode

@onready var field = $field


func construct():
	if graph_resource.graph_nodes[name]["properties"].has("field"):
		field.selected = graph_resource.graph_nodes[name]["properties"]["field"]


func _on_field_item_selected(index):
	graph_resource.graph_nodes[name]["properties"]["field"] = index
