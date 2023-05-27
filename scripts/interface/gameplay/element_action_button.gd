extends Button


@export var action: Gameplay.ElementActions


@onready var world: Gameplay = $"../.."


func __pressed():
	world.action_pressed(action)
	get_parent().visible = false
