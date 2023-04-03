extends Button


@export var action: Gameplay.ElementActions



func __pressed():
	Gameplay._action_pressed(action)
	get_parent().visible = false
