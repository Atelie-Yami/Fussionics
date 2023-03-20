extends Node



var time: float = 0.0
var token: String
var canvas := CanvasLayer.new()
var element_drag_preview := Node2D.new()
var element_focus := Sprite2D.new()
var selected_element: ElementNode:
	set(value):
		if selected_element: selected_element.selected = false
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
	
	add_child(canvas)
	add_child(element_drag_preview)


func _process(delta):
	if selected_element:
		element_focus.position = selected_element.position + Vector2(40, 40)
		
		time += delta
		var scale = abs(cos(time * 4.0)) * 0.1
		element_focus.scale = Vector2(1.0 + scale, 1.0 + scale)
	
	if element_drag_preview.visible:
		element_drag_preview.position = element_drag_preview.get_global_mouse_position()


func _unhandled_input(event):
	if event.is_action("mouse_click") and event.is_pressed():
		self.selected_element = null


func _notification(what: int):
	if what == NOTIFICATION_DRAG_BEGIN:
		element_drag_preview.visible = true
	
	if what == NOTIFICATION_DRAG_END:
		element_drag_preview.visible = false
		for c in element_drag_preview.get_children(): c.queue_free()


#func pra_depois():
#	var angle = 180
#	var dd = angle / get_child_count()
#	var d = dd * (get_child_count() / 2)
#
#	for i in get_child_count():
#		var rad = deg_to_rad((dd * i) - (angle - (dd / 2)))
#		var polar = Vector2(cos(rad), sin(rad))
#		get_child(i).position = polar * 100
