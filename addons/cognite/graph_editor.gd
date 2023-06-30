@tool
extends Control

enum PortTypes {
	VARIANT = 99,  # 8835ff
	ANALISYS = 0,  # d2fff0
	DECISION = 40, # ffe671
	ARRAY = 56,    # d95400
	INT = 87,      # ff3030
	MOLECULE = 63, # ff3fff
	ELEMENT = 1,   # 04c000
	
}

@onready var graph_edit = $GraphEdit
@onready var label = $Label


func show_editor(source: Resource):
	graph_edit.visible = true
	label.visible = false
	graph_edit.load_resource(source)


func resource_removed(source: Resource):
	if graph_edit.current_resource == source:
		graph_edit.visible = false
		label.visible = true
