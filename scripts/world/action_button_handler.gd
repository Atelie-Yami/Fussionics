extends Node2D


func _ready():
	Gameplay.show_action_buttons.connect(_show_action_buttons)
	Gameplay.element_selected.connect(_element_selected)


func _element_selected(value: bool):
	visible = value
	set_process(value)


func _process(delta):
	position = Gameplay.element_focus.position


func _notification(what: int):
	if what == NOTIFICATION_DRAG_BEGIN:
		visible = false


func _show_action_buttons(actions: Array[Arena.ElementActions]):
	get_children().map(func(c): c.visible = false)
	
	var size: float = actions.size()
	var angle: float
	match size:
		2:
			angle = 40.0
		3:
			angle = 90.0
		_:
			angle = 180.0
	
	var deg_diff := angle / float(size)
	var count := 0
	
	for action in actions:
		var rad: float = deg_to_rad((deg_diff * count) - (angle - (deg_diff / 2.0)))
		if size == 1:
			rad = deg_to_rad(-90)
		
		else:
			rad = deg_to_rad((deg_diff * count) - (angle - (deg_diff / 2.0)))
		
		var polar = Vector2(cos(rad), sin(rad))
		get_child(action).position = (polar * 80) - Vector2(20, 20)
		get_child(action).visible = true
		count += 1
