class_name Player extends Node2D

signal play

enum Players {A, B}

const MAX_LIFE := 30
const ENERGY_MAX := 16

var energy_max := 2:
	set(value):
		energy_max = min(value, ENERGY_MAX)

var energy := energy_max

@export var player: Players

@export var area_damage_path: NodePath
@onready var area_damage_vfx: TextureRect = get_node(area_damage_path)

@onready var arena: Arena = $"../arena"
@onready var camera_arena = $"../CameraArena"
@onready var particles = $omega/particles
@onready var omega = $omega
@onready var dead = $dead

var life: int = MAX_LIFE:
	set(value):
		life = max(value, 0)
		
		if life == 0:
			arena.turn_machine.game_end(player == 1)
			disable_elements()
			dead.play()


func set_turn(active: bool):
	for pos in arena.elements:
		var slot = arena.elements[pos]
		if slot.player == player:
			
			
			slot.element.active = active
			
			if active:
				if slot.defend_mode and slot.molecule:
					slot.molecule.defender = null
				slot.defend_mode = false
				
				slot.eletrons_charged = false
				slot.skill_used = false
				slot.can_act = true
				slot.element.reset()


func disable_elements():
	for pos in arena.elements:
		var slot = arena.elements[pos]
		slot.element.active = false
		slot.skill_used = true
		slot.can_act = false


func take_damage(danage: int):
	life -= danage
	particles.emitting = true
	
	var final_position: Vector2 = omega.position
	omega.position += Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * 50.0
	
	var tween := create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(omega, "position", final_position, 0.4)
	
	area_damage_vfx.modulate.a = 1.0
	var tween2 := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween2.tween_property(area_damage_vfx, "modulate:a", 0.0, 1.0)
	camera_arena.shake(4.0)


func heal(_heal: int):
	life = min(life + _heal, MAX_LIFE)


func spend_energy(_energy: int):
	energy -= _energy


func gain_energy(_energy: int):
	energy += _energy



