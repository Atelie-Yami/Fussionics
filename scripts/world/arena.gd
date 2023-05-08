class_name Arena extends PlayerController

signal elements_update


const FORJE_SLOTS_OFFSET := [
	Vector2i(-360, 100), Vector2i(-180, 0), Vector2i(-270, 0),    # slots 10, 11, 12
	Vector2i(-270, 450), Vector2i(-90, 450), Vector2i(-180, 540), # slots 13, 14, 15
	Vector2i(810, 0), Vector2i(990, 0), Vector2i(900, 0),         # slots 16, 17, 18
	Vector2i(720, 450), Vector2i(900, 450), Vector2i(810, 540),   # slots 19, 20, 21
]

## os slots
# ------------------------- #
##   slot   |    x    |  y  |
##  fusao A | 12 e 14 |  0  |
##  fusao B |  9 e 11 |  0  |
## accelr A | 12 e 14 |  4  |
## accelr B |  9 e 11 |  4  |
# ------------------------- #

## {Vector2i position : ArenaSlot slot}
var action_in_process: bool
var reactor_canceled_by_effect: bool

@export var reactor_path: NodePath
@onready var reactors = get_node(reactor_path)


func _init():
	Gameplay.arena = self


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


func remove_element(slot_position: Vector2i, animated: bool):
	if not elements.has(slot_position):
		return
	
	var slot: ArenaSlot = elements[slot_position]
	
	if not GameJudge.can_remove_element(slot.element):
		return
	
	if slot.molecule:
		var neigbors: Array[Element]
		
		if slot.defend_mode:
			slot.molecule.defender = null
		
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
	
	await _remove_element(slot, slot_position, animated)
	elements_update.emit()
	
	if slot_position.x < 8:
		get_child(slot_position.x + (slot_position.y * 8)).visible = true


func _remove_element(slot: ArenaSlot, slot_position: Vector2i, animated: bool):
	if animated:
		await Gameplay.world.vfx.emit_end_vfx(slot.element)
	
	slot.element.queue_free()
	elements.erase(slot_position)


func create_element(atomic_number: int, player: Players, _position: Vector2i, focus: bool):
	if action_in_process or not _check_slot_empty(_position) or _check_slot_only_out(_position):
		return
	
	action_in_process = true
	
	var element: Element = ElementNodePlayer.new() if player == Players.A else ElementNodeRival.new()
	var slot = ArenaSlot.new(element, player)
	
	element.build(atomic_number)
	element.grid_position = _position
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
	
	var slot_a: ArenaSlot = elements[element_a.grid_position]
	var slot_b: ArenaSlot = elements[element_b.grid_position]
	
	if not element_a.can_link(element_b) or element_b.number_electrons_in_valencia == 0:
		return
	
	action_in_process = true
	
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


func unlink_elements(element_A: Element, element_B: Element):
	if _unlink_elements(element_A, element_B):
		_handle_molecule(element_A)
		_handle_molecule(element_B)
		
		var player = elements[element_A.grid_position].player
		
		await ElementEffectManager.call_effects(player, BaseEffect.SkillType.UNLINKED)
		current_players[player].spend_energy(1)


func attack_element(attacker: Vector2i, defender: Vector2i):
	if not elements[attacker].can_act or action_in_process or elements[attacker].has_attacked:
		return
	
	var slot_attacker: ArenaSlot = elements[attacker]
	var slot_defender: ArenaSlot = elements[defender]
	
	action_in_process = true
	
	await ElementEffectManager.call_effects(elements[attacker].player, BaseEffect.SkillType.PRE_ATTACK)
	await ElementEffectManager.call_effects(elements[defender].player, BaseEffect.SkillType.PRE_DEFEND)
	
	if slot_attacker.molecule:
		await slot_attacker.molecule.effects_cluster_assembly(slot_attacker, slot_defender, Molecule.Kit.ATTACK)
	else:
		await GameJudge.combat(slot_attacker, slot_defender)
	
	action_in_process = false


func defend_mode(element: Vector2i):
	if not elements[element].can_act or action_in_process:
		return
	
	var slot: ArenaSlot = elements[element]
	action_in_process = true
	
	if slot.molecule and not slot.eletrons_charged:
		GameJudge.charge_eletrons_power(slot.element, slot.molecule)
		slot.molecule.defender = slot.element
		slot.eletrons_charged = true
	
	slot.defend_mode = true
	GameJudge.disable_slot(slot)
	
	await ElementEffectManager.call_effects(slot.player, BaseEffect.SkillType.DEFEND_MODE)
	action_in_process = false


func direct_attack(attacker: Vector2i):
	if not elements[attacker].can_act or action_in_process or elements[attacker].has_attacked:
		return
	
	var slot_attacker: ArenaSlot = elements[attacker]
	action_in_process = true
	
	await ElementEffectManager.call_effects(elements[attacker].player, BaseEffect.SkillType.PRE_ATTACK)
	await Gameplay.world.vfx.handler_attack(
			slot_attacker.element, Vector2(109 if slot_attacker.player else 1811, 540)
	)
	if (
			slot_attacker.molecule and slot_attacker.element.effect and slot_attacker.element.effect is MoleculeEffect and
			slot_attacker.element.effect.molecule_effect_type == MoleculeEffect.MoleculeEffectType.TRIGGER
	):
		pass # tomar alguma providencia quando tiver efeito de molecula ao atacar o omega
	
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
		await remove_element(Vector2i(slot_id + 1, 0), true)
	
	var element_C = create_element(min(atn, 118), current_player, Vector2i(slot_id + 1, 0), false)
	if not element_C:
		return
		
	element_C.visible = false
	
	# animação
	await reactors.fusion_elements(elements[slot_fusion_A].element, elements[slot_fusion_B].element, element_C, current_player)
	
	remove_element(slot_fusion_A, false)
	remove_element(slot_fusion_B, false)
	
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
			await remove_element(Vector2i(slot_id +1, 5), true)
		
		var element_C = create_element(min(atn_result, 118), current_player, Vector2i(slot_id +1, 5), false)
		if not element_C:
			return
		
		element_C.visible = false
		
		# anim
		await reactors.accelr_elements(elements[slot_accelr_A].element, elements[slot_accelr_B].element, element_C, current_player)
		
		remove_element(slot_accelr_A, false)
		remove_element(slot_accelr_B, false)


func _drop_data(_p, data):
	var final_position: Vector2i = Vector2i(get_global_mouse_position() - Vector2(GRID_OFFSET)) / SLOT_SIZE
	if get_global_mouse_position().x - GRID_OFFSET.x < 0:
		final_position.x = 15 + final_position.x
	
	if data is Element:
		move_element(data.grid_position, final_position)
	
	elif data is DeckSlot:
		var element = create_element(data.element, Players.A, final_position, false)
		current_players[Players.A].spend_energy(data.element +1)



