extends Node2D

const ARENA_POSITION := Vector2(605, 320)

var time: float = 0.0

@onready var world: Gameplay = $".."
@onready var visualizer = $visualizer
@onready var button_actions := [$element_action, $element_action2, $element_action3, $element_action4, $element_action5]

func _ready():
	world.show_action_buttons.connect(_show_action_buttons)
	world.is_element_selected.connect(_element_selected)


func _element_selected(value: bool):
	visible = value
	set_process(value)


func _process(delta):
	if Gameplay.selected_element:
		global_position = Gameplay.selected_element.global_position + Vector2(40, 40)
	
	time += delta
	var _scale = abs(cos(time * 4.0)) * 0.1
	visualizer.scale = Vector2(1.0 + _scale, 1.0 + _scale)


func _notification(what: int):
	if what == NOTIFICATION_DRAG_BEGIN:
		visible = false


func _show_action_buttons(actions: Array[Gameplay.ElementActions]):
	if BaseEffect.is_processing_tasks or Gameplay.arena.action_in_process:
		return
	
	button_actions.map(func(c): c.visible = false)
	
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
		button_actions[action].position = (polar * 80) - Vector2(25, 25)
		button_actions[action].visible = true
		count += 1


func _turn_machine_end_turn(player):
	Gameplay.action_state = 0
