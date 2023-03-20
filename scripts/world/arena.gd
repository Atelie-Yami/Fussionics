class_name Arena extends Control

signal end_game(winner: int)

const GRID_OFFSET := Vector2i(605, 320)
const SLOT_SIZE := Vector2i(90, 90)

class Slot:
	var player: PlayerController.Players
	var element: Element
	var molecule: Molecule
	
	var can_act: bool:
		set(value):
			can_act = value
			
			if not can_act:
				molecule.configuration.map(func(e): e.active = false)
	
	func _init(_e: Element, _p: PlayerController.Players):
		element = _e; player = _p
	


## {Vector2i position : Slot slot}
var elements: Dictionary
var combat_in_process: bool
var game_judge := GameJudge.new()


@onready var player_controller: PlayerController = $"../PlayerController"
@onready var grid_container = $GridContainer


func _ready():
	await  get_tree().create_timer(0.1).timeout
	
	for c in grid_container.get_children():
		await  get_tree().create_timer(0.03).timeout
		c.animation()


func check_slot_empty(slot: Vector2i): return not elements.has(slot)


func move_element(pre_slot: Vector2i, final_slot: Vector2i):
	if not check_slot_empty(final_slot) or elements[pre_slot].element.has_link: return
	
	var slot = elements[pre_slot]
	elements.erase(pre_slot)
	elements[final_slot] = slot
	
	slot.element.grid_position = final_slot
	slot.element.global_position = (SLOT_SIZE * final_slot) + GRID_OFFSET


func remove_element(slot_position: Vector2i):
	var slot: Slot = elements[slot_position]
	if slot.molecule:
		slot.molecule.remove_element(slot.element)
	
	slot.element.queue_free()
	elements.erase(slot_position)


func create_element(atomic_number: int, player: PlayerController.Players, _position: Vector2i):
	if not check_slot_empty(_position): return
	
	var element = ElementNode.new()
	var slot = Slot.new(element, player)
	
	element.grid_position = _position
	element.atomic_number = atomic_number
	elements[_position] = slot
	
	Gameplay.selected_element = element
	player_controller.add_child(element)
	player_controller.current_players[player].elements.append(element)
	
	match _position.y:
		10: # slot 1, fusão, Player A
			pass
		
		11: # slot 2, fusão, Player A
			pass
		
		12: # slot 3, fusão, Player A # slot onde fica o resultado cozido
			pass
		
		13: # slot 1, accelr, Player A
			pass
		
		14: # slot 2, accelr, Player A
			pass
		
		15: # slot 3, accelr, Player A # slot onde fica o resultado cozido
			pass
		
		16: # slot 1, fusão, Player B
			pass
		
		17: # slot 2, fusão, Player B
			pass
		
		18: # slot 3, fusão, Player B # slot onde fica o resultado cozido
			pass
		
		19: #slot 1, accelr, Player B
			pass
		
		20: #slot 2, accelr, Player B
			pass
		
		21: #slot 3, accelr, Player B # slot onde fica o resultado cozido
			pass
		_:
			element.global_position = (SLOT_SIZE * _position) + GRID_OFFSET


## Skill depende da molecula, há moleculas q terão, para isso esse valor vai ser esperado
func attack_element(attacker: Vector2i, defender: Vector2i, skill: int):
	if not elements[attacker].can_act or combat_in_process: return
	
	var slot_attacker = elements[attacker]
	var slot_defender = elements[defender]
	
	slot_attacker.can_act = false
	combat_in_process = true
	
	if slot_attacker.molecule:
		pass
#		attacker.molecule.get_eletron_power()
	
	else:
		var result: GameJudge.Result = game_judge.combat_check_result(slot_attacker.element, slot_defender.element)
		
		match result:
			GameJudge.Result.WINNER: 
				remove_element(defender)
			
			GameJudge.Result.COUNTERATTACK:
				remove_element(attacker)
			
			GameJudge.Result.DRAW:
				return


func _can_drop_data(_p, data):
	return data is ElementNode


func _drop_data(_p, data):
	var final_position: Vector2i = Vector2i(get_global_mouse_position() - Vector2(GRID_OFFSET)) / SLOT_SIZE
	move_element((data as ElementNode).grid_position, final_position)


