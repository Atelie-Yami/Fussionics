class_name ArenaSlot extends RefCounted


var player: PlayerController.Players
var element: Element
var molecule: Molecule

var skill_used: bool = false
var eletrons_charged: bool
var can_act: bool = true
var has_attacked: bool
var defend_mode: bool


func _init(_e: Element, _p: PlayerController.Players):
	element = _e; player = _p
	element.mouse_entered.connect(_mouse_hover.bind(true))
	element.mouse_exited.connect(_mouse_hover.bind(false))


func _mouse_hover(entered: bool):
	if molecule and is_instance_valid(molecule.border_line):
		molecule.border_line.visible = entered


func disable():
		element.active = false
		has_attacked = false
		skill_used = true
		can_act = false
