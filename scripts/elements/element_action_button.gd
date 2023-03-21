extends Button


@export var action: Arena.ElementActions


func _pressed():
	Gameplay._action_pressed(action)
	get_parent().visible = false
