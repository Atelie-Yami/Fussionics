@tool
extends EditorPlugin



var interface := preload("res://addons/cognite/interface/graph_editor.tscn").instantiate()

func _enter_tree():
	add_control_to_bottom_panel(interface, "Cognite")


func _exit_tree():
	remove_control_from_bottom_panel(interface)
	
