class_name Arena extends PlayerController

signal elements_update

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
	var eletrons_charged: bool
	var can_act: bool = true
	
	func _init(_e: Element, _p: Players):
		element = _e; player = _p
		element.mouse_entered.connect(_mouse_hover.bind(true))
		element.mouse_exited.connect(_mouse_hover.bind(false))
	
	func _mouse_hover(entered: bool):
		if molecule and is_instance_valid(molecule.border_line):
			molecule.border_line.visible = entered

## os slots
# ------------------------- #
##   slot   |    x    |  y  |
##  fusao A | 12 e 14 |  0  |
##  fusao B |  9 e 11 |  0  |
## accelr A | 12 e 14 |  4  |
## accelr B |  9 e 11 |  4  |
# ------------------------- #

## {Vector2i position : Slot slot}
var elements: Dictionary
var action_in_process: bool
var reactor_canceled_by_effect: bool

@export var reactor_path: NodePath
@onready var reactors = get_node(reactor_path)


func _init():
	Gameplay.arena = self


func _gui_input(event):
	if event.is_action_pressed("mouse_click"):
		Gameplay.action_state = Gameplay.ActionState.NORMAL
		Gameplay.passive_status.set_element(null)


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
	
	if final_slot.x < 8:
		get_child(final_slot.x + (final_slot.y * 8)).visible = false
	
	if slot.element.grid_position.x < 8:
		get_child(slot.element.grid_position.x + (slot.element.grid_position.y * 8)).visible = true
	
	slot.element.grid_position = final_slot
	slot.element.global_position = _get_snapped_slot_position(final_slot)
	elements_update.emit()


func remove_element(slot_position: Vector2i):
	if action_in_process or not elements.has(slot_position):
		return
	
	var slot: Slot = elements[slot_position]
	
	if not GameJudge.can_remove_element(slot.element):
		return
	
	action_in_process = true
	
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
	elements_update.emit()
	
	if slot_position.x < 8:
		get_child(slot_position.x + (slot_position.y * 8)).visible = true
	
	action_in_process = false


func _remove_element(slot: Slot, slot_position: Vector2i):
	slot.element.queue_free()
	elements.erase(slot_position)


func create_element(atomic_number: int, player: Players, _position: Vector2i, focus: bool):
	if action_in_process or not _check_slot_empty(_position) or _check_slot_only_out(_position):
		return
	
	action_in_process = true
	
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
	
	element.active = _position.y < 8
	element.global_position = _get_snapped_slot_position(_position)
	elements_update.emit()
	
	if _position.x < 8:
		get_child(_position.x + (_position.y * 8)).visible = false
	
	action_in_process = false
	return element


func link_elements(element_a: Element, element_b: Element):
	if action_in_process:
		return
	
	action_in_process = true
	
	var slot_a: Slot = elements[element_a.grid_position]
	var slot_b: Slot = elements[element_b.grid_position]
	
	if not element_a.can_link(element_b) or element_b.number_electrons_in_valencia == 0:
		print("ata")
		return
	
	if slot_a.molecule and slot_b.molecule:
		if slot_a.molecule == slot_b.molecule:
			_link_elements(element_a, element_b)
			
		else:
			slot_b.molecule.border_line.queue_free()
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
	
	await ElementEffectManager.call_effects(slot_a.player, BaseEffect.SkillType.LINKED)
	action_in_process = false


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
	if action_in_process:
		return
	
	action_in_process = true
	
	if _unlink_elements(element_A, element_B):
		_handle_molecule(element_A)
		_handle_molecule(element_B)
		
		var player = elements[element_A.grid_position].player
		
		await ElementEffectManager.call_effects(player, BaseEffect.SkillType.UNLINKED)
		current_players[player].spend_energy(1)
	else:
		print("has not link")
	
	action_in_process = false


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
		
		if is_instance_valid(elements[element.grid_position].molecule.border_line):
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


func attack_element(attacker: Vector2i, defender: Vector2i):
	if not elements[attacker].can_act or action_in_process: return
	
	var slot_attacker: Slot = elements[attacker]
	var slot_defender: Slot = elements[defender]
	
	action_in_process = true
	
	await ElementEffectManager.call_effects(elements[attacker].player, BaseEffect.SkillType.PRE_ATTACK)
	await ElementEffectManager.call_effects(elements[defender].player, BaseEffect.SkillType.PRE_DEFEND)
	
	if slot_attacker.molecule:
		await slot_attacker.molecule.effects_cluster_assembly(slot_attacker, slot_defender, Molecule.Kit.ATTACK)
	else:
		await GameJudge.combat(slot_attacker, slot_defender)
	action_in_process = false


func direct_attack(attacker: Vector2i):
	if not elements[attacker].can_act or action_in_process: return
	
	var slot_attacker: Slot = elements[attacker]
	action_in_process = true
	
	await ElementEffectManager.call_effects(elements[attacker].player, BaseEffect.SkillType.PRE_ATTACK)
	
	if slot_attacker.molecule:
		pass
	else:
		current_players[0 if slot_attacker.player else 1].take_damage(slot_attacker.element.eletrons)
		slot_attacker.element.disabled = true
		slot_attacker.can_act = false
	
	action_in_process = false


func fusion_elements(slot_fusion_A: Vector2i, slot_fusion_B: Vector2i, slot_id: int, current_player: PlayerController.Players):
	var atn: int = (
			elements[slot_fusion_A].element.atomic_number +
			elements[slot_fusion_B].element.atomic_number + 1
	)
	
	reactor_canceled_by_effect = false
	await ElementEffectManager.call_effects(current_player, BaseEffect.SkillType.COOKED_FUSION)
	if reactor_canceled_by_effect:
		return
	
	if elements.has(Vector2i(slot_id + 1, 0)):
		remove_element(Vector2i(slot_id + 1, 0))
	
	var element_C = create_element(min(atn, 118), current_player, Vector2i(slot_id + 1, 0), false)
	if not element_C:
		return
		
	element_C.visible = false
	
	# animação
	await reactors.fusion_elements(elements[slot_fusion_A].element, elements[slot_fusion_B].element, element_C, current_player)
	
	remove_element(slot_fusion_A)
	remove_element(slot_fusion_B)
	
	if atn > 24:
			Gameplay.arena.current_players[current_player].take_damage(atn - 24)


func accelr_elements(slot_accelr_A: Vector2i, slot_accelr_B: Vector2i, slot_id: int, current_player: PlayerController.Players):
		var atn1: int = elements[slot_accelr_A].element.atomic_number
		var atn2: int = elements[slot_accelr_B].element.atomic_number
		var atn_result: int
		
		if not atn1 and not atn2:
			atn1 = 1
		
		if atn1 == atn2: # Há mais changes de ter um bom resultado se for 2 elementos iguais
			atn_result = max(
					randi_range(atn1, atn1 + atn2),
					randi_range(atn1, atn1 + atn2),
					randi_range(atn1, atn1 + atn2)
			)
		else:
			atn_result = max(
					randi_range(atn1, atn1 + atn2),
					randi_range(atn1, atn1 + atn2)
			)
		
		reactor_canceled_by_effect = false
		await ElementEffectManager.call_effects(current_player, BaseEffect.SkillType.COOKED_ACCELR)
		if reactor_canceled_by_effect:
			return
		
		if elements.has(Vector2i(slot_id +1, 5)):
			remove_element(Vector2i(slot_id +1, 5))
		
		var element_C = create_element(min(atn_result, 118), current_player, Vector2i(slot_id +1, 5), false)
		if not element_C:
			return
		
		element_C.visible = false
		
		# anim
		await reactors.accelr_elements(elements[slot_accelr_A].element, elements[slot_accelr_B].element, element_C, current_player)
		
		remove_element(slot_accelr_A)
		remove_element(slot_accelr_B)


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


