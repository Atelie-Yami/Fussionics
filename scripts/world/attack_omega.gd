extends TextureRect

const ANIMATION_SPEED := 2.5

var time := 0.0
var animation := 0.0


func _init():
	Gameplay.set_to_default.connect(_set_to_default)
	visibility_changed.connect(_visibility_changed)


func _set_to_default():
	visible = false


func _visibility_changed():
	time = 0.0
	set_process(visible)


func _process(delta):
	time += delta
	animation = cos(time * ANIMATION_SPEED)
	modulate.a = abs(animation)


func _gui_input(event: InputEvent):
	if event.is_action_pressed("mouse_click"):
		Gameplay.arena.direct_attack(Gameplay.selected_element.grid_position)
		Gameplay.action_state = 0
		visible = false
