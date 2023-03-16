class_name Arena extends Node2D

signal end_game(winner: int)

const GRID_OFFSET := Vector2i(605, 320)
const SLOT_SIZE := Vector2i(90, 90)

class Slot:
	var player: PlayerController.Players
	var element: Element
	var molecule: Molecule
	
	var can_act: bool
	
	func _init(_e: Element, _p: PlayerController.Players):
		element = _e; player = _p


## {Vector2i position : Slot slot}
var elements: Dictionary

@onready var player_controller: Array[PlayerInputs] = [
	$PlayerController/player_A_controller as PlayerInputs,
	$PlayerController/player_B_controller as PlayerInputs
]


func check_slot_empty(slot: Vector2i): return not elements.has(slot)


func move_element(pre_slot: Vector2i, final_slot: Vector2i):
	if not check_slot_empty(final_slot) or  elements[pre_slot].element.has_link: return
	
	var slot = elements[pre_slot]
	elements.erase(pre_slot)
	elements[final_slot] = slot
	
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
	
	element.atomic_number = atomic_number
	Gameplay.selected_element = element
	
	elements[_position] = slot
	
	player_controller[player].add_child(element)
	player_controller[player].elements.append(element)
	
	match _position.y:
		10: # slot 1, fusão, Player A
			pass
		
		11: # slot 2, fusão, Player A
			pass
		
		12: # slot 1, accelr, Player A
			pass
		
		13: # slot 2, accelr, Player A
			pass
		
		14: # slot 1, fusão, Player B
			pass
		
		15: # slot 2, fusão, Player B
			pass
		
		16: # slot 1, accelr, Player B
			pass
		
		17: # slot 2, accelr, Player B
			pass
		
		_:
			element.global_position = (SLOT_SIZE * _position) + GRID_OFFSET
