class_name PassiveEffect extends RefCounted

enum PassiveEffectLifetimeType {
	TEMPORAL, # gasto a cada MAIN_FASE
	EFEMERAL, # gasto por cada vez ativado
	ETERNAL, # sem gasto definido 
}
enum Debuff {
	ATTACK_BLOQ, # impede de atacar
	DEFEND_BLOQ, # impede de defender
	LINK_BLOQ, # impede de linkar
	UNLINK_BLOQ, # impede de deslinkar
	BURNING, # reduz até 8 netrons por turno, maximo 8 stacks
}
enum Buff {
	DOUBLE_ATTACK, # permite atacar mais uma vez
	IMORTAL, # não pode ser destruido
}
const DEBUFF_BOOK := {
	Debuff.BURNING: preload("res://scripts/elements/debuffs/burning.gd")
}

class DebuffEffect extends PassiveEffect:
	var type: Debuff

class BuffEffect extends PassiveEffect:
	var type: Buff

var origin: BaseEffect

## forma q esse efeito desgasta com o tempo
var cust_type: PassiveEffectLifetimeType

var max_life_time: int
## quantas vezes ainda falta para acabar esse efeito
var life_time: int:
	set(value):
		life_time = min(value, max_life_time)

var max_stacks: int
## se estacar, vai ser marcado aqui
var stack: int:
	set(value):
		stack = min(value, max_stacks)

var max_level: int
## se possuir niveis, vai ser marcado aqui
var level: int:
	set(value):
		level = min(value, max_level)

var _registred: bool


func effect():
	pass


func remove():
	pass


## registra esse efeito de acordo com o tempo de ação
func register(player: PlayerController.Players):
	ElementEffectManager.passive_pool_effects[player].append(self)
	_registred = true


## remove o registro
func unregister(player: PlayerController.Players):
	if _registred:
		ElementEffectManager.passive_pool_effects[player].erase(self)
