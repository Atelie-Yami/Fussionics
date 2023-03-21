class_name Arena extends Control

signal end_game(winner: int)

enum ElementActions {ATTACK, LINK, UNLINK, EFFECT}

const GRID_OFFSET := Vector2i(605, 320)
const SLOT_SIZE := Vector2i(90, 90)

class Slot:
	var player: PlayerController.Players
	var element: Element
	var molecule: Molecule
	
	var skill_used: bool = false
	
	var can_act: bool = true:
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


func _init():
	Gameplay.arena = self


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
	
	element.active = true
	
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


func link_elements(element_a: ElementNode, element_b: ElementNode):
	var slot_a: Slot = elements[element_a.grid_position]
	var slot_b: Slot = elements[element_b.grid_position]
	
	if slot_a.molecule and slot_a.molecule == slot_b.molecule:
		for link in element_a.links:
			var ligament_a = element_a.links[link]
			if not ligament_a:
				continue
			
			for _link in element_b.links:
				var ligament_b = element_b.links[_link]
				if not ligament_b:
					continue
				
				if ligament_a == ligament_b and ligament_a.level < 3:
					ligament_a.evolve_ligament()
					return
		return
	
	if slot_a.molecule and slot_b.molecule:
		slot_a.molecule.configuration.append_array(slot_b.molecule.configuration)
		slot_a.molecule.link_elements(element_a, element_b)
		
		slot_b.molecule.configuration.map(
				func(e: ElementNode): elements[e.grid_position].molecule = slot_a.molecule
		)
	
	elif slot_a.molecule:
		slot_a.molecule.configuration.append(element_b)
		slot_a.molecule.link_elements(element_a, element_b)
		slot_b.molecule = slot_a.molecule
	
	elif slot_b.molecule:
		slot_b.molecule.configuration.append(element_a)
		slot_b.molecule.link_elements(element_a, element_b)
		slot_a.molecule = slot_b.molecule
	
	else:
		var molecule := Molecule.new()
		molecule.configuration.append(element_a); molecule.configuration.append(element_b)
		molecule.link_elements(element_a, element_b)
		slot_a.molecule = molecule; slot_b.molecule = molecule


func unlink_element_direction(element: ElementNode, direction: Vector2i):
	element.links[direction].remove()
	
	_handle_molecule(element.links[direction].element_A)
	_handle_molecule(element.links[direction].element_B)


func unlink_elements(element_A: ElementNode, element_B: ElementNode):
	var has_link := false
	
	for link in element_A.links:
		var ligament_A = element_A.links[link]
		if not ligament_A: continue
		
		for _link in element_B.links:
			var ligament_B = element_B.links[_link]
			if not ligament_B: continue
			
			if ligament_A == ligament_B:
				ligament_A.remove()
				has_link = true
	
	if has_link:
		_handle_molecule(element_A)
		_handle_molecule(element_B)
	
	else:
		print("has not link")


func _handle_molecule(element: ElementNode):
	var molecule_config: Array[ElementNode]
	var molecula: Molecule
	
	if element.has_link:
		_procedural_search_link_nodes(element, molecule_config)
	
	if molecule_config.is_empty():
		elements[element.grid_position].molecule = null
	else:
		molecula = Molecule.new()
		molecula.configuration = molecule_config
		
		for e in molecule_config:
			elements[e.grid_position].molecule = molecula


func _procedural_search_link_nodes(element_parent: ElementNode, anchored_array: Array[ElementNode]):
	for l in element_parent.links:
		var link: Molecule.Ligament = element_parent.links[l]
		
		if not link: continue
		
		if link.element_A == element_parent:
			_procedural_search_test(link.element_B, anchored_array)
		
		elif link.element_B == element_parent:
			_procedural_search_test(link.element_A, anchored_array)


func _procedural_search_test(element: ElementNode, anchored_array: Array[ElementNode]):
	if anchored_array.find(element) == -1:
		return
	
	anchored_array.append(element)
	_procedural_search_link_nodes(element, anchored_array)


func element_use_effect(element: ElementNode):
	print(elements[element.grid_position])


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
		var result: GameJudge.Result = game_judge.combat_check_result(slot_attacker.element, slot_defender.element, skill)
		
		match result:
			GameJudge.Result.WINNER: 
				remove_element(defender)
			
			GameJudge.Result.COUNTERATTACK:
				remove_element(attacker)
			
			GameJudge.Result.DRAW:
				return


func slot_get_actions(slot: Slot):
	var actions: Array[ElementActions]
	
	if slot.element.has_link:
		if slot.element.number_electrons_in_valencia > 0:
			actions.append(ElementActions.LINK)
		
		actions.append(ElementActions.UNLINK)
		
	else:
		actions.append(ElementActions.LINK)
	
	if not slot.can_act: return actions
	actions.append(ElementActions.ATTACK)
	
	if not slot.skill_used: actions.append(ElementActions.EFFECT)
	
	return actions


func _can_drop_data(_p, data):
	return data is ElementNode


func _drop_data(_p, data):
	var final_position: Vector2i = Vector2i(get_global_mouse_position() - Vector2(GRID_OFFSET)) / SLOT_SIZE
	move_element((data as ElementNode).grid_position, final_position)


