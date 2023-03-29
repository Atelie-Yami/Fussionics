class_name Arena extends Control


enum ElementActions {ATTACK, LINK, UNLINK, EFFECT}

const GRID_OFFSET := Vector2i(605, 320)
const SLOT_SIZE := Vector2i(90, 90)
const FORJE_SLOTS_OFFSET := [
	Vector2i(-360, 100), Vector2i(-180, 0), Vector2i(-270, 0),    # slots 10, 11, 12
	Vector2i(-270, 450), Vector2i(-90, 450), Vector2i(-180, 540), # slots 13, 14, 15
	Vector2i(810, 0), Vector2i(990, 0), Vector2i(900, 0),         # slots 16, 17, 18
	Vector2i(720, 450), Vector2i(900, 450), Vector2i(810, 540),   # slots 19, 20, 21
]

class Slot:
	var player: PlayerController.Players
	var element: Element
	var molecule: Molecule
	
	var skill_used: bool = false
	
	var can_act: bool = true:
		set(value):
			can_act = value
			
			if not can_act and molecule:
				molecule.configuration.map(func(e): e.active = false)
	
	func _init(_e: Element, _p: PlayerController.Players):
		element = _e; player = _p
		element.mouse_entered.connect(_mouse_hover.bind(true))
		element.mouse_exited.connect(_mouse_hover.bind(false))
	
	func _mouse_hover(entered: bool):
		if molecule:
			molecule.border_line.visible = entered


## {Vector2i position : Slot slot}
var elements: Dictionary
var combat_in_process: bool


@onready var player_controller: PlayerController = $"../PlayerController"
@onready var turn_machine: TurnMachine = %turn_machine


func _init():
	Gameplay.arena = self


func _ready():
	await  get_tree().create_timer(0.1).timeout
	
	for c in get_children():
		await  get_tree().create_timer(0.03).timeout
		c.animation()


func _check_slot_empty(slot: Vector2i):
	return not elements.has(slot)


func _check_slot_only_out(slot: Vector2i):
	return slot.y == 12 or slot.y == 15 or slot.y == 18 or slot.y == 21


func _get_snapped_slot_position(slot: Vector2i):
	var _slot = (slot - Vector2i(16, 0)) if slot.x > 11 else slot
	return (SLOT_SIZE * _slot) + GRID_OFFSET


func move_element(pre_slot: Vector2i, final_slot: Vector2i):
	if (
			not _check_slot_empty(final_slot)
			or _check_slot_only_out(final_slot)
			or elements[pre_slot].element.has_link
	): return
	
	var slot = elements[pre_slot]
	elements.erase(pre_slot)
	elements[final_slot] = slot
	
	slot.element.grid_position = final_slot
	slot.element.global_position = _get_snapped_slot_position(final_slot)


func remove_element(slot_position: Vector2i):
	var slot: Slot = elements[slot_position]
	
	if not GameJudge.can_remove_element(slot.element):
		return
	
	if slot.molecule:
		var neigbors: Array[ElementNode]
		
		for link in slot.element.links:
			if not slot.element.links[link]:
				continue
			
			if slot.element.links[link].element_A == slot.element:
				neigbors.append(slot.element.links[link].element_B)
				
			elif slot.element.links[link].element_B == slot.element:
				neigbors.append(slot.element.links[link].element_A)
			
			slot.element.links[link].remove()
		
		for element in neigbors:
			_handle_molecule(element)
	
	_remove_element(slot, slot_position)


func _remove_element(slot: Slot, slot_position: Vector2i):
	player_controller.current_players[slot.player].elements.erase(slot.element)
	slot.element.queue_free()
	elements.erase(slot_position)


func create_element(atomic_number: int, player: PlayerController.Players, _position: Vector2i):
	if not _check_slot_empty(_position) or _check_slot_only_out(_position):
		return
	
	var element = ElementNode.new()
	var slot = Slot.new(element, player)
	
	element.grid_position = _position
	element.atomic_number = atomic_number
	elements[_position] = slot
	
	Gameplay.selected_element = element
	player_controller.add_child(element)
	player_controller.current_players[player].elements.append(element)
	
	element.active = _position.y < 9
	element.global_position = _get_snapped_slot_position(_position)


func link_elements(element_a: ElementNode, element_b: ElementNode):
	var slot_a: Slot = elements[element_a.grid_position]
	var slot_b: Slot = elements[element_b.grid_position]
	
	if slot_a.molecule and slot_b.molecule:
		if slot_a.molecule == slot_b.molecule:
			_link_elements(element_a, element_b)
			
		else:
			slot_a.molecule.configuration.append_array(slot_b.molecule.configuration)
			slot_a.molecule.link_elements(element_a, element_b)
			
			slot_b.molecule.configuration.map(
					func(e: ElementNode): elements[e.grid_position].molecule = slot_a.molecule
			)
			slot_a.molecule.gain_ref()
	
	elif slot_a.molecule:
		slot_a.molecule.configuration.append(element_b)
		slot_a.molecule.link_elements(element_a, element_b)
		slot_b.molecule = slot_a.molecule
		slot_a.molecule.gain_ref()
	
	elif slot_b.molecule:
		slot_b.molecule.configuration.append(element_a)
		slot_b.molecule.link_elements(element_a, element_b)
		slot_a.molecule = slot_b.molecule
		slot_b.molecule.gain_ref()
	
	else:
		var molecule := Molecule.new()
		molecule.configuration.append(element_a); molecule.configuration.append(element_b)
		molecule.link_elements(element_a, element_b)
		slot_a.molecule = molecule; slot_b.molecule = molecule
		molecule.update_border()
	
	ElementEffectManager.call_effects(slot_a.player, ElementEffectManager.SkillType.LINKED)


func _link_elements(element_a: ElementNode, element_b: ElementNode):
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


func unlink_elements(element_A: ElementNode, element_B: ElementNode):
	if _unlink_elements(element_A, element_B):
		_handle_molecule(element_A)
		_handle_molecule(element_B)
		
		var player = elements[element_A.grid_position].player
		
		ElementEffectManager.call_effects(
				player, ElementEffectManager.SkillType.UNLINKED
		)
		player_controller.spend_energy(player, 1)
	else:
		print("has not link")


func _unlink_elements(element_A: ElementNode, element_B: ElementNode):
	for link in element_A.links:
		var ligament_A: Molecule.Ligament = element_A.links[link]
		if not ligament_A:
			continue
		
		for _link in element_B.links:
			var ligament_B: Molecule.Ligament = element_B.links[_link]
			if not ligament_B:
				continue
			
			if ligament_A == ligament_B:
				if ligament_A.level > 1:
					ligament_A.demote_ligament()
				
				else:
					ligament_A.remove()
				
				return true
	return false


func _handle_molecule(element: ElementNode):
	var molecule_config: Array[ElementNode]
	var molecula: Molecule
	
	if element.has_link:
		_procedural_search_link_nodes(element, molecule_config)
	
	if molecule_config.is_empty():
		if elements[element.grid_position].molecule:
			elements[element.grid_position].molecule.redux_ref()
		elements[element.grid_position].molecule = null
		
	else:
		molecula = Molecule.new()
		molecula.configuration = molecule_config
		elements[element.grid_position].molecule.border_line.queue_free()
		
		for e in molecule_config:
			elements[e.grid_position].molecule = molecula
			molecula.gain_ref()


func _procedural_search_link_nodes(element_parent: ElementNode, anchored_array: Array[ElementNode]):
	for l in element_parent.links:
		var link: Molecule.Ligament = element_parent.links[l]
		if not link: continue
		
		if link.element_A == element_parent:
			_procedural_search_test(link.element_B, anchored_array)
		
		elif link.element_B == element_parent:
			_procedural_search_test(link.element_A, anchored_array)


func _procedural_search_test(element: ElementNode, anchored_array: Array[ElementNode]):
	if anchored_array.find(element) != -1:
		return
	
	anchored_array.append(element)
	_procedural_search_link_nodes(element, anchored_array)


func element_use_effect(element: ElementNode):
	print(elements[element.grid_position])


## Skill depende da molecula, há moleculas q terão, para isso esse valor vai ser esperado
func attack_element(attacker: Vector2i, defender: Vector2i, skill: int):
	if not elements[attacker].can_act or combat_in_process: return
	
	var slot_attacker: Slot = elements[attacker]
	var slot_defender: Slot = elements[defender]
	
	slot_attacker.can_act = false
	combat_in_process = true
	
	await ElementEffectManager.call_effects(elements[attacker].player, ElementEffectManager.SkillType.PRE_ATTACK)
	await ElementEffectManager.call_effects(elements[defender].player, ElementEffectManager.SkillType.PRE_DEFEND)
	
	if slot_attacker.molecule:
		pass
	
	else:
		var result: GameJudge.Result = GameJudge.combat_check_result(
				slot_attacker.element, slot_defender.element, skill
		)
		match result:
			GameJudge.Result.WINNER:
				await ElementEffectManager.call_effects(elements[attacker].player, ElementEffectManager.SkillType.POS_ATTACK)
				await ElementEffectManager.call_effects(elements[defender].player, ElementEffectManager.SkillType.POS_DEFEND)
				player_controller.take_damage(slot_defender.player, slot_attacker.element.eletrons - slot_defender.element.neutrons)
				remove_element(defender)
			
			GameJudge.Result.COUNTERATTACK:
				if (
						GameJudge.combat_check_result(
								slot_defender.element, slot_attacker.element, skill
						) == GameJudge.Result.WINNER
				):
					await ElementEffectManager.call_effects(elements[attacker].player, ElementEffectManager.SkillType.POS_ATTACK)
					await ElementEffectManager.call_effects(elements[defender].player, ElementEffectManager.SkillType.POS_DEFEND)
					player_controller.take_damage(slot_attacker.player, slot_defender.element.neutrons - slot_attacker.element.eletrons)
					remove_element(attacker)
	combat_in_process = false


func slot_get_actions(slot: Slot):
	var actions: Array[ElementActions]
	
	if slot.element.has_link:
		if slot.element.number_electrons_in_valencia > 0:
			actions.append(ElementActions.LINK)
		
		if player_controller.current_players[slot.player].energy > 0:
			actions.append(ElementActions.UNLINK)
		
	else:
		actions.append(ElementActions.LINK)
	
	if not slot.can_act: return actions
	actions.append(ElementActions.ATTACK)
	
	if not slot.skill_used: actions.append(ElementActions.EFFECT)
	
	return actions


func _can_drop_data(_p, data):
	return (
			turn_machine.current_stage == TurnMachine.State.MAIN
			and turn_machine.current_player == TurnMachine.Players.A
	)


func _drop_data(_p, data):
	var final_position: Vector2i = Vector2i(get_global_mouse_position() - Vector2(GRID_OFFSET)) / SLOT_SIZE
	if get_global_mouse_position().x - GRID_OFFSET.x < 0:
		final_position.x = 15 + final_position.x
	
	if data is ElementNode:
		move_element(data.grid_position, final_position)
	
	elif data is DeckSlot:
		create_element(data.element, PlayerController.Players.A, final_position)
		player_controller.spend_energy(PlayerController.Players.A, data.element +1)


