@tool
extends CogniteGraphNode


var selected_number: int
@onready var line_edit_A = $A
@onready var line_edit_B = $B


func _on_condition_item_selected(index):
	match index:
		1, 2:
			pass


func _on_line_edit_text_changed(new_text: String):
	selected_number = int(new_text)


func _on_close_request():
	pass # Replace with function body.


func _on_a_text_changed(new_text: String):
	selected_number = int(new_text)
	line_edit_A.text = str(selected_number)
	line_edit_A.caret_column = 999 # move o cursos para o final da linha


func _on_b_text_changed(new_text: String):
	selected_number = int(new_text)
	line_edit_B.text = str(selected_number)
	line_edit_B.caret_column = 999 # move o cursos para o final da linha
