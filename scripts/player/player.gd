class_name Player extends Node

signal dead

enum Players {A, B}

const MAX_LIFE := 30
const ENERGY_MAX := 16

var energy_max := 1
var energy := 1

@export var player: Players

var life: int = MAX_LIFE:
	set(value):
		life = max(value, 0)
		
		if life == 0:
			dead.emit()

@onready var arena: Arena = $"../arena"


func set_turn(active: bool):
	for pos in arena.elements:
		var slot = arena.elements[pos]
		if slot.player == player:
			slot.element.active = active
			
			if active:
				slot.skill_used = false
				slot.can_act = true


func take_damage(danage: int):
	life -= danage


func heal(_heal: int):
	life = min(life + _heal, MAX_LIFE)


func spend_energy(_energy: int):
	energy -= _energy


func gain_energy(_energy: int):
	energy += _energy


func play():
	arena.create_element(
			randi_range(0, 10), PlayerController.Players.B, 
			Vector2i(randi_range(0, 7), randi_range(0, 4)), false
	)
