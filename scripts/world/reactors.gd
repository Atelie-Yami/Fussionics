extends Node


@export var arena_path: NodePath
@onready var arena: Arena = get_node(arena_path)

@onready var fusion_a = $fusion_A
@onready var fusion_b = $fusion_B
@onready var accelr_a = $accelr_A
@onready var accelr_b = $accelr_B

@onready var camera_arena = $"../CameraArena"


func _ready():
	arena.elements_update.connect(_elements_update)


func _elements_update():
	fusion_a.actived = arena.elements.has(Vector2i(12, 0)) and arena.elements.has(Vector2i(14, 0))
	fusion_b.actived = arena.elements.has(Vector2i( 9, 0)) and arena.elements.has(Vector2i(11, 0))
	
	accelr_a.actived = arena.elements.has(Vector2i(12, 4)) and arena.elements.has(Vector2i(14, 4))
	accelr_b.actived = arena.elements.has(Vector2i( 9, 4)) and arena.elements.has(Vector2i(11, 4))


func fusion_elements(element_A: Element, element_B: Element, element_C: Element, player: int):
	var final_position: Vector2
	final_position.y = element_A.global_position.y
	final_position.x = (element_A.global_position.x + element_B.global_position.x) / 2.0
	
	self. motion(
			create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN),
			element_A, final_position, 0.7
	)
	await motion(
			create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN),
			element_B, final_position, 0.7
	)
	
	(fusion_b if player else fusion_a).start(element_C.glow.modulate)
	camera_arena.shake(2.5)
	element_C.visible = true
	Gameplay.world.vfx.emit_element_instanciated(element_C.global_position + Vector2(40, 40), element_C.legancy.modulate)


func accelr_elements(element_A: Element, element_B: Element, element_C: Element, player: int):
	var final_position: Vector2
	final_position.y = element_A.global_position.y
	final_position.x = (element_A.global_position.x + element_B.global_position.x) / 2.0
	
	self. motion(
			create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT),
			element_A, element_A.global_position - Vector2(90, 0), 0.3
	)
	await motion(
			create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT),
			element_B, element_B.global_position + Vector2(90, 0), 0.3
	)
	
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(element_A, "global_position", final_position, 0.4)
	tween.parallel().tween_property(element_B, "global_position", final_position, 0.4)
	
	(accelr_b if player else accelr_a).start(element_C.glow.modulate)
	
	await tween.finished
	camera_arena.shake(2.5)
	
	element_C.global_position = final_position
	element_A.visible = false
	element_B.visible = false
	element_C.visible = true
	Gameplay.world.vfx.emit_element_instanciated(element_C.global_position + Vector2(40, 40), element_C.legancy.modulate)
	
	await motion(
			create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN),
			element_C, final_position + Vector2(0, 90), 0.4
	)


func motion(tween: Tween, element: Element, final_position: Vector2, time: float):
	tween.tween_property(element, "global_position", final_position, time)
	await tween.finished



