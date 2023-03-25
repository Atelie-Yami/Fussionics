extends Timer

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

const TIME_CAST_EFFECT := 0.1
## Quando um efeito de turno for iniciado, ele vai se registrar aqui e esperar se chamado
const EFFECTS_POOL := {
	SkillType.PRE_INIT_PHASE: [], #
	SkillType.COOKED_FUSION: [], #
	SkillType.COOKED_ACCELR: [], #
	SkillType.INIT_PHASE: [], #
	SkillType.MAIN_PHASE: [], #
	SkillType.END_PHASE: [], #
	SkillType.LINKED: [], #
	SkillType.UNLINKED: [], #
	SkillType.PRE_ATTACK: [], #
	SkillType.POS_ATTACK: [], #
	SkillType.PRE_DEFEND: [], #
	SkillType.POS_DEFEND: [], #
	SkillType.POS_ACTION: [], #
	SkillType.PASSIVE: [],
}

var effects_pool_players := {
	PlayerController.Players.A: EFFECTS_POOL.duplicate(),
	PlayerController.Players.B: EFFECTS_POOL.duplicate(),
}

var is_processing_tasks := false


func _init():
	one_shot = true


func _reset_pool(player: PlayerController.Players):
	for type in effects_pool_players[player]:
		effects_pool_players[player][type] = []


func call_effects(player: PlayerController.Players, type: SkillType):
	is_processing_tasks = true
	for effect in effects_pool_players[player][type]:
		effect.execute()
		print("execultando ", effect)
		start(TIME_CAST_EFFECT)
		await timeout
	
	for _players in 2:
		for effect in effects_pool_players[_players][SkillType.POS_ACTION]:
			effect.execute()
			print("execultando ", effect)
			start(TIME_CAST_EFFECT)
			await timeout
	
	is_processing_tasks = false


