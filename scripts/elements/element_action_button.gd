extends Button


@export var action: Gameplay.ElementActions


func _pressed():
	Gameplay._action_pressed(action)
	get_parent().visible = false
