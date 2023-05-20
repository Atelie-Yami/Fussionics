class_name VFX extends Node2D

enum Type {
	ANY, LIGHTNING, ELECTRICITY, LASER, ORB, EXPLOSION, PROJECTILE, FIRE,
}

const HALOS_PARTICLES_PARTICLES := preload("res://scenes/vfx/halos_particles_get_widget.tscn")
const START_SKILL_PARTICLES := preload("res://scenes/vfx/start_skill_particles.tscn")
const SUNDRY_PARTICLES := preload("res://scenes/vfx/sundry_particles.tscn")
const MORE_PARTICLES := preload("res://scenes/vfx/more_particles.tscn")
const ELEMENT_DEAD := preload("res://scenes/vfx/element_dead.tscn")

var particles_2_RID: RID
var canvas_item_particles_2_RID: RID

@onready var skill_defended: GPUParticles2D = $skill_defended
@onready var skill_start_1: GPUParticles2D = $skill_start_1
@onready var element_instanciated = $element_instanciated
@onready var get_widget = $get_widget

@onready var _timer = $Timer


func handler_attack(attacker: Element, target: Vector2):
	var _position := attacker.global_position + Vector2(40, 40)
	var efx := AttackBaseEFX.new()
	
	efx.position = _position
	efx.target = target
	add_child(efx)
	
	_timer.start(efx.life_time + 0.07)
	await _timer.timeout


func emit_defended_vfx(_position: Vector2):
	skill_defended.emit_particle(Transform2D(0.0, _position), Vector2.ONE, Color.WHITE, Color.WHITE, GPUParticles2D.EMIT_FLAG_POSITION)
	
	var timer := Timer.new()
	add_child(timer)
	timer.start(0.22)
	await timer.timeout


func emit_element_instanciated(_position: Vector2, color: Color):
	element_instanciated.emit_particle(
			Transform2D(0.0, _position),
			Vector2.ONE, Color.WHITE, Color.WHITE, GPUParticles2D.EMIT_FLAG_POSITION
	)
	var particles = SUNDRY_PARTICLES.instantiate()
	add_child(particles)
	particles.global_position = _position
	
	particles.modulate = color
	element_instanciated.modulate = color


func emit_start_vfx(element: Element):
	var _position := element.global_position + Vector2(40, 40)
	
	var skill_start_2: GPUParticles2D = START_SKILL_PARTICLES.instantiate()
	add_child(skill_start_2)
	skill_start_2.position = _position
	
	var timer := Timer.new()
	add_child(timer)
	timer.start(0.25)
	await timer.timeout
	
	skill_start_1.emit_particle(Transform2D(0.0, _position), Vector2.ONE, Color.WHITE, Color.WHITE, GPUParticles2D.EMIT_FLAG_POSITION)
	
	timer.start(0.2)
	await timer.timeout
	
	var ghost := ElementGhost.new()
	ghost.atomic_number = element.atomic_number
	ghost.eletrons = element.eletrons
	ghost.neutrons = element.neutrons
	element.add_child(ghost)
	
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(ghost, "scale", Vector2(1.3, 1.3), 0.3)
	tween.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(ghost, "modulate:a", 0.0, 0.3)
	tween.finished.connect(ghost.queue_free)
	
	timer.start(0.15)
	await timer.timeout
	timer.queue_free()


func emit_end_vfx(element: Element):
	element.is_dead_flag = true
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(element, "factor_dead", 1.5, 0.3)
	tween.parallel().tween_property(element, "scale", Vector2(1.15, 1.15), 0.3)
	var timer := Timer.new()
	add_child(timer)
	
	timer.start(0.28)
	await timer.timeout
	
	element.visible = false
	var dead_particles := ELEMENT_DEAD.instantiate()
	add_child(dead_particles)
	dead_particles.position = element.global_position + Vector2(40, 40)
	dead_particles.emitting = true
	
	timer.start(0.03)
	await timer.timeout
	
	timer.queue_free()


func emit_get_widget(_position: Vector2, color: Color):
	get_widget.emit_particle(
			Transform2D(0.0, _position), Vector2.ONE, Color.WHITE, Color.WHITE,
			GPUParticles2D.EMIT_FLAG_POSITION
	)
	get_widget.modulate = color
	
	var particles = MORE_PARTICLES.instantiate()
	particles.amount = randi_range(4, 7)
	add_child(particles)
	particles.global_position = _position
	particles.modulate = color
	
	var particles2 = HALOS_PARTICLES_PARTICLES.instantiate()
	particles2.amount = randi_range(3, 5)
	add_child(particles2)
	particles2.global_position = _position
	particles2.modulate = color
