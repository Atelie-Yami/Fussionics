extends TextureRect

const ANIMATION_SPEED := 2.5

var time := 0.0
var animation := 0.0


func _init():
	Gameplay.attack_omega_handler = self
	visibility_changed.connect(_visibility_changed)


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
		visible = false
