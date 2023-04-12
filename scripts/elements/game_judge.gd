class_name GameJudge extends RefCounted

enum Result {
	WINNER, # se venceu o combate
	COUNTERATTACK, # se perdeu e foi contra atacado
	DRAW, # sem resultado, ninguem perdeu
}

static func combat_check_result(element_attacker: Element, element_defender: Element) -> Result:
	# avaliar os efeitos pra saber se tem codições nesse caso atual
	
	if element_attacker.eletrons > element_defender.neutrons:
		return Result.WINNER
	
	elif element_attacker.eletrons == element_defender.neutrons:
		return Result.DRAW
	
	else:
		return Result.COUNTERATTACK


static func can_element_attack(element: Element) -> bool:
	for debuff in element.debuffs:
		if debuff.type == PassiveEffect.Debuff.ATTACK_BLOQ:
			return false
	return true


static func can_remove_element(element: Element) -> bool:
	for buff in element.buffs:
		if buff.type == PassiveEffect.Buff.IMORTAL:
			return false
	return true


static func combat(attaker: Arena.Slot, defender: Arena.Slot):
	var result: Result = combat_check_result(attaker.element, defender.element)
	match result:
		Result.WINNER:
			await ElementEffectManager.call_effects(attaker.player, ElementEffectManager.SkillType.POS_ATTACK)
			await ElementEffectManager.call_effects(defender.player, ElementEffectManager.SkillType.POS_DEFEND)
			Gameplay.arena.current_players[defender.player].take_damage(attaker.element.eletrons - defender.element.neutrons)
			Gameplay.arena.remove_element(defender.element.grid_position)
			attaker.can_act = false
			attaker.element.disabled = true
		
		Result.COUNTERATTACK:
			if combat_check_result(defender.element, attaker.element) == Result.WINNER:
				await ElementEffectManager.call_effects(attaker.player, ElementEffectManager.SkillType.POS_ATTACK)
				await ElementEffectManager.call_effects(defender.player, ElementEffectManager.SkillType.POS_DEFEND)
				Gameplay.arena.current_players[attaker.player].take_damage(defender.element.neutrons - attaker.element.eletrons)
				Gameplay.arena.remove_element(attaker.element.grid_position)
		
		Result.DRAW:
			await ElementEffectManager.call_effects(attaker.player, ElementEffectManager.SkillType.POS_ATTACK)
			await ElementEffectManager.call_effects(defender.player, ElementEffectManager.SkillType.POS_DEFEND)
			attaker.can_act = false
			attaker.element.disabled = true


static func get_neighbor_enemies(position: Vector2i, enemies: Array[Element]):
	var player = Gameplay.arena.elements[position].player
	
	for x in [-1, 0, 1]:
		for y in [-1, 0, 1]:
			var _pos = position + Vector2i(x, y)
			if Gameplay.arena.elements.has(_pos) and Gameplay.arena.elements[_pos].player != player:
				enemies.append(Gameplay.arena.elements[_pos].element)


static func charge_eletrons_to_attack(header: Element, molecule: Molecule):
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
		
		if element.eletrons >= level:
			element.eletrons -= level
			power += level
		
		else:
			power += element.eletrons
			element.eletrons = 0
		
		var lec = EletronChangeLable.new(-1)
		lec.global_position = element.global_position + Vector2(53, -10)
		Gameplay.add_child(lec)
		
		charged_elements.append(element)
	
	for element in molecule.configuration:
		if element == header or charged_elements.has(element) or element.eletrons <= 0:
			continue
		
		element.eletrons -= 1
		power += 1
		
		var lec = EletronChangeLable.new(-1)
		lec.global_position = element.global_position + Vector2(53, -10)
		Gameplay.add_child(lec)
	
	header.eletrons += power
	
	var lec = EletronChangeLable.new(power)
	lec.global_position = header.global_position + Vector2(53, -10)
	Gameplay.add_child(lec)


static func is_neighbor_to_link(position: Vector2i):
	var x: int = abs(Gameplay.selected_element.grid_position.x - position.x)
	var y: int = abs(Gameplay.selected_element.grid_position.y - position.y)
	return (x == 1 and y != 1) or (x != 1 and y == 1)
