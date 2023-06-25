extends CogniteGraphNode


var action: int
var action_target: int


func _ready():
	for tag in Decision.ActionTarget.keys() as Array[String]:
		$action.add_item(tag.to_snake_case().replace("_", " "))
		
	for tag in Decision.Action.keys() as Array[String]:
		$action_target.add_item(tag.to_pascal_case())


func _on_action_item_selected(index):
	action = index -1


func _on_action_target_item_selected(index):
	action_target = index -1


func _on_directive_text_submitted(new_text):
	pass # Replace with function body.
