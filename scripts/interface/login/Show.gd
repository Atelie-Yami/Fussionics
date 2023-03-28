extends Node

@export var Node_Show : NodePath

@onready var node_real = get_node(Node_Show)

func _pressed():
	node_real.visible = !node_real.visible
