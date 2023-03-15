extends Node

var element_focus := Sprite2D.new()
var time: float = 0.0
var selected_element: ElementNode:
	set(value):
		selected_element = value
		
		if selected_element:
			selected_element.selected = true
			element_focus.visible = true
			element_focus.modulate = selected_element.modulate
		else:
			element_focus.visible = false


func _ready():
	add_child(element_focus)
	element_focus.visible = false
	element_focus.texture = preload("res://assets/img/elements/element_moldure4.png")


func _process(delta):
	if selected_element:
		element_focus.position = selected_element.position + Vector2(40, 40)
		
		time += delta
		var scale = abs(cos(time * 4.0)) * 0.1
		element_focus.scale = Vector2(1.0 + scale, 1.0 + scale)
