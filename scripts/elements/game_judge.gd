class_name GameJudge extends RefCounted

enum Result {
	WINNER, # se venceu o combate
	COUNTERATTACK, # se perdeu e foi contra atacado
	DRAW, # sem resultado, ninguem perdeu
}

static func combat_check_result(element_attacker: ElementNode, element_defender: ElementNode, skill: int) -> Result:
	# avaliar os efeitos pra saber se tem codições nesse caso atual
	
	if element_attacker.eletrons > element_defender.neutrons:
		return Result.WINNER
	
	elif element_attacker.eletrons == element_defender.neutrons:
		return Result.DRAW
	
	else:
		return Result.COUNTERATTACK


static func can_element_attack(element: ElementNode) -> bool:
	for debuff in element.debuffs:
		if debuff.type == PassiveEffect.Debuff.ATTACK_BLOQ:
			return false
	return true


static func can_remove_element(element: ElementNode) -> bool:
	for debuff in element.debuffs:
		if debuff.type == PassiveEffect.Buff.IMORTAL:
			return false
	return true

