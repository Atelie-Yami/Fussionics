class_name Arena extends PlayerController



const GRID_OFFSET := Vector2i(605, 320)
const SLOT_SIZE := Vector2i(90, 90)
const FORJE_SLOTS_OFFSET := [
	Vector2i(-360, 100), Vector2i(-180, 0), Vector2i(-270, 0),    # slots 10, 11, 12
	Vector2i(-270, 450), Vector2i(-90, 450), Vector2i(-180, 540), # slots 13, 14, 15
	Vector2i(810, 0), Vector2i(990, 0), Vector2i(900, 0),         # slots 16, 17, 18
	Vector2i(720, 450), Vector2i(900, 450), Vector2i(810, 540),   # slots 19, 20, 21
]

class Slot:
	var player: Players
	var element: Element
	var molecule: Molecule
	
	var skill_used: bool = false
	
	var can_act: bool = true:
		set(value):
			can_act = value
			
			if not can_act and not molecule:
				element.disabled = true
	
	func _init(_e: Element, _p: Players):
		element = _e; player = _p
		element.mouse_entered.connect(_mouse_hover.bind(true))
		element.mouse_exited.connect(_mouse_hover.bind(false))
	
	func _mouse_hover(entered: bool):
		if molecule and is_instance_valid(molecule.border_line):
			molecule.border_line.visible = entered


## {Vector2i position : Slot slot}
var elements: Dictionary
var combat_in_process: bool


func _init():
	Gameplay.arena = self


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
	if not elements.has(slot_position):
		return
	
	var slot: Slot = elements[slot_position]
	
	if not GameJudge.can_remove_element(slot.element):
		return
	
	if slot.molecule:
		var neigbors: Array[Element]
		
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
	slot.element.queue_free()
	elements.erase(slot_position)


func create_element(atomic_number: int, player: Players, _position: Vector2i, focus: bool):
	if not _check_slot_empty(_position) or _check_slot_only_out(_position):
		return
	
	var element: Element
	
	if player == Players.A:
		element = ElementNodePlayer.new()
	else:
		element = ElementNodeRival.new()
	
	var slot = Slot.new(element, player)
	
	element.grid_position = _position
	element.atomic_number = atomic_number
	elements[_position] = slot
	
	if focus:
		Gameplay.selected_element = element
	
	current_players[player].add_child(element)
	
	element.active = _position.y < 9
	element.global_position = _get_snapped_slot_position(_position)


func link_elements(element_a: Element, element_b: Element):
	var slot_a: Slot = elements[element_a.grid_position]
	var slot_b: Slot = elements[element_b.grid_position]
	
	if not element_a.can_link(element_b) or element_b.number_electrons_in_valencia == 0:
		print("ata")
		return
	
	if slot_a.molecule and slot_b.molecule:
		if slot_a.molecule == slot_b.molecule:
			_link_elements(element_a, element_b)
			
		else:
			for e in slot_b.molecule.configuration:
				slot_a.molecule.add_element(e)
				
			slot_a.molecule.link_elements(element_a, element_b)
			slot_a.molecule.gain_ref()
	
	elif slot_a.molecule:
		slot_a.molecule.add_element(element_b)
		slot_a.molecule.link_elements(element_a, element_b)
		slot_a.molecule.gain_ref()
	
	elif slot_b.molecule:
		slot_b.molecule.add_element(element_a)
		slot_b.molecule.link_elements(element_a, element_b)
		slot_b.molecule.gain_ref()
	
	else:
		var molecule := Molecule.new()
		molecule.add_element(element_a)
		molecule.add_element(element_b)
		molecule.link_elements(element_a, element_b)
		molecule.update_border()
	
	ElementEffectManager.call_effects(slot_a.player, ElementEffectManager.SkillType.LINKED)


func _link_elements(element_a: Element, element_b: Element):
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


func unlink_elements(element_A: Element, element_B: Element):
	if _unlink_elements(element_A, element_B):
		_handle_molecule(element_A)
		_handle_molecule(element_B)
		
		var player = elements[element_A.grid_position].player
		
		ElementEffectManager.call_effects(
				player, ElementEffectManager.SkillType.UNLINKED
		)
		current_players[player].spend_energy(1)
	else:
		print("has not link")


func _unlink_elements(element_A: Element, element_B: Element):
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


func _handle_molecule(element: Element):
	var molecule_config: Array[Element]
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


func _procedural_search_link_nodes(element_parent: Element, anchored_array: Array[Element]):
	for l in element_parent.links:
		var link: Molecule.Ligament = element_parent.links[l]
		if not link: continue
		
		if link.element_A == element_parent:
			_procedural_search_test(link.element_B, anchored_array)
		
		elif link.element_B == element_parent:
			_procedural_search_test(link.element_A, anchored_array)


func _procedural_search_test(element: Element, anchored_array: Array[Element]):
	if anchored_array.find(element) != -1:
		return
	
	anchored_array.append(element)
	_procedural_search_link_nodes(element, anchored_array)


func element_use_effect(element: Element):
	if element.effect:
		element.effect.execute()


func attack_element(attacker: Vector2i, defender: Vector2i, skill: int):
	if not elements[attacker].can_act or combat_in_process: return
	
	var slot_attacker: Slot = elements[attacker]
	var slot_defender: Slot = elements[defender]
	
	combat_in_process = true
	
	await ElementEffectManager.call_effects(elements[attacker].player, ElementEffectManager.SkillType.PRE_ATTACK)
	await ElementEffectManager.call_effects(elements[defender].player, ElementEffectManager.SkillType.PRE_DEFEND)
	
	if slot_attacker.molecule:
		slot_attacker.molecule.effects_cluster_assembly(slot_attacker.element, slot_defender.element, Molecule.Kit.ATTACK)
	else:
		GameJudge.combat(slot_attacker.element, slot_defender.element)
	combat_in_process = false


func _can_drop_data(_p, data):
	return (
			turn_machine.current_stage == TurnMachine.State.MAIN
			and turn_machine.current_player == TurnMachine.Players.A
	)


func _drop_data(_p, data):
	var final_position: Vector2i = Vector2i(get_global_mouse_position() - Vector2(GRID_OFFSET)) / SLOT_SIZE
	if get_global_mouse_position().x - GRID_OFFSET.x < 0:
		final_position.x = 15 + final_position.x
	
	if data is Element:
		move_element(data.grid_position, final_position)
	
	elif data is DeckSlot:
		create_element(data.element, Players.A, final_position, false)
		current_players[Players.A].spend_energy(data.element +1)


