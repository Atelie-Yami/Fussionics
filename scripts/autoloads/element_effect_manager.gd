extends Timer


const TIME_CAST_EFFECT := 0.2

## Quando um efeito de turno for iniciado, ele vai se registrar aqui e esperar se chamado
var EFFECTS_POOL := {
	BaseEffect.SkillType.PRE_INIT_PHASE: [], #
	BaseEffect.SkillType.COOKED_FUSION: [], #
	BaseEffect.SkillType.COOKED_ACCELR: [], #
	BaseEffect.SkillType.INIT_PHASE: [], #
	BaseEffect.SkillType.MAIN_PHASE: [], #
	BaseEffect.SkillType.END_PHASE: [], #
	BaseEffect.SkillType.LINKED: [], #
	BaseEffect.SkillType.UNLINKED: [], #
	BaseEffect.SkillType.PRE_ATTACK: [], #
	BaseEffect.SkillType.POS_ATTACK: [], #
	BaseEffect.SkillType.PRE_DEFEND: [], #
	BaseEffect.SkillType.POS_DEFEND: [], #
	BaseEffect.SkillType.POS_ACTION: [], #
	BaseEffect.SkillType.PASSIVE: [], #
}
var effects_pool_players := {
	PlayerController.Players.A: EFFECTS_POOL.duplicate(),
	PlayerController.Players.B: EFFECTS_POOL.duplicate(),
}
var passive_pool_effects := {
	PlayerController.Players.A: [],
	PlayerController.Players.B: [],
}

var is_processing_tasks := false


func _init():
	one_shot = true


func _reset_pool(player: PlayerController.Players):
	for type in effects_pool_players[player]:
		effects_pool_players[player][type] = []


func _process(delta):
	for _players in 2:
		for effect in effects_pool_players[_players][BaseEffect.SkillType.PASSIVE]:
			effect.execute()


func call_passive_effects(player: PlayerController.Players):
	passive_pool_effects[player].map(func(e): e.effect())


func call_effects(player: PlayerController.Players, type: BaseEffect.SkillType):
	is_processing_tasks = true
	for effect in effects_pool_players[player][type]:
		effect.execute()
		start(TIME_CAST_EFFECT)
		await timeout
		
		for _players in 2:
			for _effect in effects_pool_players[_players][BaseEffect.SkillType.POS_ACTION]:
				_effect.execute()
				start(TIME_CAST_EFFECT)
				await timeout
	
	is_processing_tasks = false


