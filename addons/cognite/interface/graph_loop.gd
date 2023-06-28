@tool
extends CogniteGraphNode


var selected_number: int
@onready var line_edit = $LineEdit


func construct():
	if graph_resource.graph_nodes[name]["properties"].has("loop"):
		line_edit.text = str(graph_resource.graph_nodes[name]["properties"]["loop"])


func _on_line_edit_text_changed(new_text):
	selected_number = int(new_text)
	line_edit.text = str(selected_number)
	line_edit.caret_column = 999 # move o cursos para o final da linha
	graph_resource.graph_nodes[name]["properties"]["loop"] = selected_number



