@tool
extends CogniteGraphNode

@onready var line_edit_A = $A
@onready var line_edit_B = $B
@onready var condition = $condition


func construct():
	if graph_resource.graph_nodes[name]["properties"].has("line_edit_A"):
		line_edit_A.text = str(graph_resource.graph_nodes[name]["properties"]["line_edit_A"])
	
	if graph_resource.graph_nodes[name]["properties"].has("line_edit_B"):
		line_edit_B.text = str(graph_resource.graph_nodes[name]["properties"]["line_edit_B"])
	
	if graph_resource.graph_nodes[name]["properties"].has("condition"):
		condition.selected = graph_resource.graph_nodes[name]["properties"]["condition"]


func _on_condition_item_selected(index):
	graph_resource.graph_nodes[name]["properties"]["condition"] = index


func _on_close_request():
	pass # Replace with function body.


func _on_a_text_changed(new_text: String):
	var selected_number = int(new_text)
	line_edit_A.text = str(selected_number)
	line_edit_A.caret_column = 999 # move o cursos para o final da linha
	graph_resource.graph_nodes[name]["properties"]["line_edit_A"] = selected_number


func _on_b_text_changed(new_text: String):
	var selected_number = int(new_text)
	line_edit_B.text = str(selected_number)
	line_edit_B.caret_column = 999 # move o cursos para o final da linha
	graph_resource.graph_nodes[name]["properties"]["line_edit_B"] = selected_number
