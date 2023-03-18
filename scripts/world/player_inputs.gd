class_name PlayerInputs extends Control


var elements: Array[ElementNode]

@onready var arena = $"../../arena"


func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		set_my_turn(true)
		
		arena.create_element(randi_range(0, 118), 0, Vector2i(randi_range(0, 7), randi_range(0, 4)))
	
	if Input.is_action_just_pressed("ui_cancel"):
		set_my_turn(false)
		Gameplay.selected_element = null


func set_my_turn(active: bool):
#	if not elements.is_empty():
	elements.map(func(e): e.active = active)


