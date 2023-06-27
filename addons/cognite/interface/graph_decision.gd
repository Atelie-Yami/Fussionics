@tool
extends CogniteGraphNode


var action: int
var action_target: int


func construct():
	for tag in Decision.ActionTarget.keys() as Array[String]:
		$action.add_item(tag.to_snake_case().replace("_", " "))
		
	for tag in Decision.Action.keys() as Array[String]:
		$action_target.add_item(tag.to_pascal_case())
	
	if graph_resource.graph_nodes[name]["properties"].has("action"):
		$action.selected = graph_resource.graph_nodes[name]["properties"]["action"]
	
	if graph_resource.graph_nodes[name]["properties"].has("action_target"):
		$action_target.selected = graph_resource.graph_nodes[name]["properties"]["action_target"]


func _on_action_item_selected(index):
	graph_resource.graph_nodes[name]["properties"]["action"] = index
	action = index -1


func _on_action_target_item_selected(index):
	graph_resource.graph_nodes[name]["properties"]["action_target"] = index
	action_target = index -1


