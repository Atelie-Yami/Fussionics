@tool
extends EditorInspectorPlugin


var interface: Control
var plugin: EditorPlugin


func _can_handle(object: Object):
	if object.has_method("is_cognite_resource"):
		interface.load_resource(object)
		plugin.make_bottom_panel_item_visible(interface)
		return true
	
	return false




