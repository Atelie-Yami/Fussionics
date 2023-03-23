class_name GameJudge extends RefCounted

enum Result {
	WINNER, # se venceu o combate
	COUNTERATTACK, # se perdeu e foi contra atacado
	DRAW, # sem resultado, ninguem perdeu
}
enum SkillType {
	PRE_INIT_PHASE, # na fase de PRE_INI_PHASE
	COOKED_FUSION, # quando estiver no forno de fusão
	COOKED_ACCELR, # quando estiver no forno de aceleração
	INIT_PHASE,  # na fase de INI_PHASE, fase dos fornos
	MAIN_PHASE,  # na fase de MAIN_PHASE
	END_PHASE, # na fase de END_PHASE
	ACTION, # pode ser ativado pelo usuario durante a MAIN PHASE
	LINKED, # quando for linkado
	UNLINKED, # quando for deslinkado
	PRE_ATTACK, # ativado antes de atacar
	POS_ATTACK, # ativado após atacar
	PRE_DEFEND, # antes de sofrer ataque
	POS_DEFEND, # depois de sofrer ataque
	POS_ACTION, # após um efeito for ativado
	PASSIVE, # efeito sempre ativo, assim q é instanciado e até o elemento ser removido 
}
enum PassiveEffectLifetimeType {
	TEMPORAL, # gasto a cada MAIN_FASE
	EFEMERAL, # gasto por cada vez ativado
	ETERNAL, # sem gasto definido 
}

# ------------------------------------------------------------------------------------------------ #
enum Debuff {
	ATTACK_BLOQ, # impede de atacar
	LINK_BLOQ, # impede de linkar
	UNLINK_BLOQ, # impede de deslinkar
}

enum Buff {
	DOUBLE_ATTACK, # permite atacar mais uma vez
}
# ------------------------------------------------------------------------------------------------ #

const SKILL_DATA := {}

class SkillEffect:
	var skill_type: SkillType


class PassiveEffect:
	var origim: SkillEffect
	var cust_type: PassiveEffectLifetimeType
	var life_time: int


class DebuffEffect extends PassiveEffect:
	var type: Debuff


class BuffEffect extends PassiveEffect:
	var type: Buff


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
		if debuff.type == Debuff.ATTACK_BLOQ:
			return false
	
	return true
