extends CogniteGraphNode


var selected_number: int
@onready var line_edit = $LineEdit


func _on_line_edit_text_changed(new_text):
	selected_number = int(new_text)
	line_edit.text = str(selected_number)
	line_edit.caret_column = 999 # move o cursos para o final da linha


func _on_close_request():
	pass # Replace with function body.
