@tool
extends CogniteGraphNode


@onready var directive = $directive
@onready var value = $value


func construct():
	for tag in Decision.Directive.keys() as Array[String]:
		directive.add_item(tag.to_pascal_case())
	
	if graph_resource.graph_nodes[name]["properties"].has("directive"):
		directive.selected = graph_resource.graph_nodes[name]["properties"]["directive"]
	
	if graph_resource.graph_nodes[name]["properties"].has("value"):
		value.text = graph_resource.graph_nodes[name]["properties"]["value"]


func _on_directive_item_selected(index):
	graph_resource.graph_nodes[name]["properties"]["directive"] = index


func _on_value_text_changed(new_text):
	graph_resource.graph_nodes[name]["properties"]["value"] = new_text
