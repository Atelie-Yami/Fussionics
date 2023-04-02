class_name GameJudge extends RefCounted

enum Result {
	WINNER, # se venceu o combate
	COUNTERATTACK, # se perdeu e foi contra atacado
	DRAW, # sem resultado, ninguem perdeu
}

static func combat_check_result(element_attacker: Element, element_defender: Element, skill: int) -> Result:
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
	for debuff in element.debuffs:
		if debuff.type == PassiveEffect.Buff.IMORTAL:
			return false
	return true


static func combat(attaker: Element, defender: Element):
	var result: Result = combat_check_result(
			attaker, defender, 0
	)
	var atk_player = Gameplay.arena.elements[attaker.grid_position].player
	var dfd_player = Gameplay.arena.elements[defender.grid_position].player
	
	match result:
		Result.WINNER:
			await ElementEffectManager.call_effects(atk_player, ElementEffectManager.SkillType.POS_ATTACK)
			await ElementEffectManager.call_effects(dfd_player, ElementEffectManager.SkillType.POS_DEFEND)
			Gameplay.arena.current_players[dfd_player].take_damage(attaker.eletrons - defender.neutrons)
			Gameplay.arena.remove_element(defender.grid_position)
		
		Result.COUNTERATTACK:
			if combat_check_result(attaker, defender, 0) == Result.WINNER:
				await ElementEffectManager.call_effects(atk_player, ElementEffectManager.SkillType.POS_ATTACK)
				await ElementEffectManager.call_effects(dfd_player, ElementEffectManager.SkillType.POS_DEFEND)
				Gameplay.arena.current_players[atk_player].take_damage(defender.neutrons - attaker.eletrons)
				Gameplay.arena.remove_element(attaker.grid_position)
		
		Result.DRAW:
			await ElementEffectManager.call_effects(atk_player, ElementEffectManager.SkillType.POS_ATTACK)
			await ElementEffectManager.call_effects(dfd_player, ElementEffectManager.SkillType.POS_DEFEND)
