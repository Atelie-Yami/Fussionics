class_name VFX extends Node2D

enum Type {
	ANY, LIGHTNING, ELECTRICITY, LASER, ORB, EXPLOSION, PROJECTILE, FIRE,
}

const START_SKILL_PARTICLES := preload("res://scenes/vfx/start_skill_particles.tscn")
const ELEMENT_DEAD := preload("res://scenes/vfx/element_dead.tscn")

var particles_2_RID: RID
var canvas_item_particles_2_RID: RID

@onready var skill_start_1: GPUParticles2D = $skill_start_1

@onready var _timer = $Timer



func handler(actuators: Array[Element], targets: Array[Vector2], type: Type, id: int):
	for e in actuators:
		var timer := Timer.new()
		add_child(timer)
		emit_start_vfx(e, timer)
	
	_timer.start(0.6)
	await _timer.timeout


func emit_start_vfx(element: Element, timer: Timer):
	var _position := element.global_position + Vector2(40, 40)
	
	var skill_start_2: GPUParticles2D = START_SKILL_PARTICLES.instantiate()
	add_child(skill_start_2)
	skill_start_2.position = _position
	
	timer.start(0.25)
	await timer.timeout
	
	skill_start_1.emit_particle(Transform2D(0.0, _position), Vector2.ONE, Color.WHITE, Color.WHITE, GPUParticles2D.EMIT_FLAG_POSITION)
	
	timer.start(0.2)
	await timer.timeout
	timer.queue_free()
	
	var ghost := Element.new()
	ghost.atomic_number = element.atomic_number
	ghost.eletrons = element.eletrons
	ghost.neutrons = element.neutrons
	element.add_child(ghost)
	
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(ghost, "scale", Vector2(1.3, 1.3), 0.3)
	tween.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(ghost, "modulate:a", 0.0, 0.3)
	tween.finished.connect(ghost.queue_free)


func emit_end_vfx(element: Element):
	element.is_dead_flag = true
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(element, "factor_dead", 10, 0.3)
	await tween.finished
	
	element.visible = false
	var dead_particles := ELEMENT_DEAD.instantiate()
	add_child(dead_particles)
	dead_particles.position = element.global_position + Vector2(40, 40)
