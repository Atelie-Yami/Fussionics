extends Node


@export var arena_path: NodePath
@onready var arena: Arena = get_node(arena_path)


func _ready():
	arena.elements_update.connect(_elements_update)


func _elements_update():
	var f1 = arena.elements.has(Vector2i())


func accelr_elements(element_A: Element, element_B: Element):
	var final_position: Vector2
	final_position.y = element_A.global_position.y
	final_position.x = (element_A.global_position.x + element_B.global_position.x) / 2.0
	
	var tween := create_tween()
#	tween.tween_property()
