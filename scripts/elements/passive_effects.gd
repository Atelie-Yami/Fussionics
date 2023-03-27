class_name PassiveEffect extends RefCounted

enum PassiveEffectLifetimeType {
	TEMPORAL, # gasto a cada MAIN_FASE
	EFEMERAL, # gasto por cada vez ativado
	ETERNAL, # sem gasto definido 
}
enum Debuff {
	ATTACK_BLOQ, # impede de atacar
	LINK_BLOQ, # impede de linkar
	UNLINK_BLOQ, # impede de deslinkar
}
enum Buff {
	DOUBLE_ATTACK, # permite atacar mais uma vez
	IMORTAL, # não pode ser destruido
}

class DebuffEffect extends PassiveEffect:
	var type: Debuff

class BuffEffect extends PassiveEffect:
	var type: Buff

var origim: SkillEffect
var cust_type: PassiveEffectLifetimeType
var life_time: int
