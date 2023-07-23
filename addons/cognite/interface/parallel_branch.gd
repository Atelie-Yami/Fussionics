@tool
extends CogniteGraphNode


var priority: int
@onready var priority_node = $priority


func construct():
	if graph_resource.graph_nodes[name].properties.has("priority"):
		priority_node.selected = graph_resource.graph_nodes[name].properties["priority"]


func _on_priority_item_selected(index):
	graph_resource.graph_nodes[name].properties["priority"] = index
	priority = index

