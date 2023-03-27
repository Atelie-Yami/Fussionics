class_name SkillEffect extends RefCounted

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

var skill_type: SkillType

func register(player: PlayerController.Players):
	ElementEffectManager.effects_pool_players[player][skill_type] = self

func unregister(player: PlayerController.Players):
	ElementEffectManager.effects_pool_players[player][skill_type].erase(self)

func execute():
	Gameplay.arena
