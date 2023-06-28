@tool
extends EditorPlugin

var inspector_response := preload("res://addons/cognite/inspector_response.gd").new()
var interface := preload("res://addons/cognite/interface/graph_editor.tscn").instantiate()
var selection: EditorSelection


func _enter_tree():
	add_control_to_bottom_panel(interface, "Cognite")
	
	var icon = get_editor_interface().get_base_control().get_theme_icon("GDScript", "EditorIcons")
	add_custom_type("CogniteSource", "Resource", preload("res://addons/cognite/cognite_source.gd"), icon)
	
	selection = get_editor_interface().get_selection()
	selection.selection_changed.connect(_EditorInterface_selection_changed)
	
	inspector_response.interface = interface
	inspector_response.plugin = self
	
	add_inspector_plugin(inspector_response)
	get_editor_interface().get_file_system_dock().resource_removed.connect(interface.resource_removed)


func _exit_tree():
	remove_inspector_plugin(inspector_response)
	remove_control_from_bottom_panel(interface)
	remove_custom_type("CogniteSource")


func _EditorInterface_selection_changed():
	pass
