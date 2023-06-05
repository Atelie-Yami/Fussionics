class_name GameJudge extends RefCounted

enum Result {
	WINNER, # se venceu o combate
	COUNTERATTACK, # se perdeu e foi contra atacado
	DRAW, # sem resultado, ninguem perdeu
}
const REACTOR_POSITIONS := [
	Vector2i( 9, 0), Vector2i(11, 0), Vector2i( 9, 4), Vector2i(11, 4),
	Vector2i(12, 0), Vector2i(14, 0), Vector2i(12, 4), Vector2i(14, 4),
]
const REACTOR_OUT_POSITIONS := [
	Vector2i( 10, 0), Vector2i( 10, 4), Vector2i(13, 0), Vector2i(13, 4)
]

static func combat_check_result(element_attacker: Element, element_defender: Element, defended: bool) -> Result:
	if (
			(not defended and element_attacker.eletrons > element_defender.neutrons + 1) or 
			(defended and element_attacker.eletrons > element_defender.eletrons)
	):
		return Result.WINNER
	
	if (
		(not defended and element_attacker.eletrons < element_defender.neutrons + 1) or
		(defended and element_attacker.eletrons < element_defender.eletrons)
	):
		return Result.COUNTERATTACK
	
	return Result.DRAW


static func can_element_link(element: Element) -> bool:
	var has_ligament_empty: bool
	for link in element.links:
		if not element.links[link]:
			has_ligament_empty = true
			break
	return has_ligament_empty and element.number_electrons_in_valencia > 0


static func can_element_attack(element: Element) -> bool:
	if element.disabled:
		return false
	
	for debuff in element.debuffs:
		if debuff.type == PassiveEffect.Debuff.ATTACK_BLOQ:
			return false
	return true


static func can_element_defend(element: Element) -> bool:
	if element.disabled:
		return false
	
	for debuff in element.debuffs:
		if debuff.type == PassiveEffect.Debuff.DEFEND_BLOQ:
			return false
	return true


static func can_remove_element(element: Element) -> bool:
	for buff in element.buffs:
		if buff.type == PassiveEffect.Buff.IMORTAL:
			return false
	return true


static func combat(attacker: ArenaSlot, defender: ArenaSlot):
	if defender.molecule and defender.molecule.defender:
		defender = Arena.get_slot(defender.molecule.defender.grid_position)
	
	var result: Result = combat_check_result(attacker.element, defender.element, defender.defend_mode)
	disable_slot(attacker)
	
	var damage: int
	var can_take_damage: bool
	
	match result:
		Result.WINNER:
			await Gameplay.vfx.handler_attack(
					attacker.element, defender.element.global_position + Vector2(40, 40)
			)
			
			await BaseEffect.call_effects(attacker.player, BaseEffect.SkillType.POS_ATTACK)
			await BaseEffect.call_effects(defender.player, BaseEffect.SkillType.POS_DEFEND)
			
			damage = attacker.element.eletrons - defender.element.neutrons - 1
			can_take_damage = not defender.defend_mode
			
			await Gameplay.arena.remove_element(defender.element.grid_position, true)
			
			if can_take_damage:
				PlayerController.current_players[defender.player].take_damage(damage)
		
		Result.COUNTERATTACK:
			if defender.defend_mode:
				return
			
			if combat_check_result(defender.element, attacker.element, false) == Result.WINNER:
				await Gameplay.vfx.handler_attack(
						attacker.element, defender.element.global_position + Vector2(40, 40)
				)
				await Gameplay.vfx.emit_defended_vfx(
						defender.element.global_position + Vector2(40, 40)
				)
				await Gameplay.vfx.handler_attack(
						defender.element, attacker.element.global_position + Vector2(40, 40)
				)
				
				await BaseEffect.call_effects(attacker.player, BaseEffect.SkillType.POS_ATTACK)
				await BaseEffect.call_effects(defender.player, BaseEffect.SkillType.POS_DEFEND)
				
				damage = defender.element.eletrons - attacker.element.neutrons - 1
				
				await Gameplay.arena.remove_element(attacker.element.grid_position, true)
				PlayerController.current_players[attacker.player].take_damage(damage)
		
		Result.DRAW:
			await Gameplay.vfx.handler_attack(
					attacker.element, defender.element.global_position + Vector2(40, 40)
			)
			await Gameplay.vfx.emit_defended_vfx(
					defender.element.global_position + Vector2(40, 40)
			)
			await BaseEffect.call_effects(attacker.player, BaseEffect.SkillType.POS_ATTACK)
			await BaseEffect.call_effects(defender.player, BaseEffect.SkillType.POS_DEFEND)


static func disable_slot(slot):
	slot.element.disabled = true
	slot.can_act = false


static func disable_molecule(molecule: Molecule):
	for element in molecule.configuration:
		element.disabled = true


static func make_full_link_elements(element_A: Element, element_B: Element):
	for i in 3:
		await Gameplay.arena.link_elements(element_A, element_B)


static func get_powerful_element_in_molecule(molecule: Molecule) -> Element:
	var best_match: Element
	for element in molecule.configuration:
		if not best_match:
			best_match = element
			continue
		
		if element.eletrons > best_match.eletrons or element.neutrons > best_match.neutrons:
			best_match = element
	
	return best_match


static func get_weak_element_molecule(molecule: Molecule) -> Element:
	var best_match: Element
	for element in molecule.configuration:
		if not best_match:
			best_match = element
			continue
		
		if element.eletrons < best_match.eletrons or element.neutrons < best_match.neutrons:
			best_match = element
	
	return best_match


static func get_neighbor_enemies(position: Vector2i, enemies: Array[Element]):
	var player = Arena.get_slot(position).player
	
	for x in [-1, 0, 1]:
		for y in [-1, 0, 1]:
			var _pos = position + Vector2i(x, y)
			if Arena.elements.has(_pos) and Arena.elements[_pos].player != player:
				enemies.append(Arena.elements[_pos].element)


static func get_active_elements_in_molecule(molecule: Molecule):
	var list: Array
	for element in molecule.configuration:
		if can_element_attack(element):
			list.append(element)
	
	return list


static func calcule_max_molecule_eletrons_power(molecule: Molecule) -> int:
	var power := 0
	
	for element in molecule.configuration:
		power += element.eletrons
	
	return power


static func charge_eletrons_power(header: Element, molecule: Molecule):
	var power := 0
	var charged_elements: Array[Element]
	
	for link in header.links:
		if not header.links[link]:
			continue
		
		var level: int = header.links[link].level
		var element: Element
		
		if header.links[link].element_A == header:
			element = header.links[link].element_B
		else:
			element = header.links[link].element_A
		var lec: EletronChangeLable
		
		if element.eletrons >= level:
			lec = EletronChangeLable.new(-level)
			element.eletrons -= level
			power += level
		
		else:
			lec = EletronChangeLable.new(-element.eletrons)
			power += element.eletrons
			element.eletrons = 0
		
		lec.global_position = element.global_position + Vector2(53, -10)
		Gameplay.vfx.add_child(lec)
		
		charged_elements.append(element)
	
	for element in molecule.configuration:
		if element == header or charged_elements.has(element) or element.eletrons <= 0:
			continue
		
		element.eletrons -= 1
		power += 1
		
		var lec = EletronChangeLable.new(-1)
		lec.global_position = element.global_position + Vector2(53, -10)
		Gameplay.vfx.add_child(lec)
	
	header.eletrons += power
	
	var lec = EletronChangeLable.new(power)
	lec.global_position = header.global_position + Vector2(53, -10)
	Gameplay.vfx.add_child(lec)


static func is_neighbor_to_link(position: Vector2i):
	var x: int = abs(Gameplay.selected_element.grid_position.x - position.x)
	var y: int = abs(Gameplay.selected_element.grid_position.y - position.y)
	return (x == 1 and y != 1) or (x != 1 and y == 1)


static func is_positions_neighbor(position_A: Vector2i, position_B: Vector2i):
	for x in [-1, 0, 1]:
		for y in [-1, 0, 1]:
			if position_A == position_B + Vector2i(x, y):
				return true
	return false


static func is_element_in_reactor(position: Vector2i):
	return REACTOR_POSITIONS.has(position)


static func is_molecule_opened(molecule: Molecule):
	for elements in molecule.configuration:
		if elements.number_electrons_in_valencia <= 0:
			continue
		
		for link in elements.links:
			if elements.links[link]:
				return true
	return false


static func is_element_header_to_molecule(element: Element):
	return (
			element.effect and element.effect is MoleculeEffect and
			element.effect.molecule_effect_type != MoleculeEffect.MoleculeEffectType.TRIGGER
	)
