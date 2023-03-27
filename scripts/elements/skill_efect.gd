## classe que detem todos os efeitos dos elementos
class_name SkillEffect extends RefCounted

## Tempos onde um efeito possa ser chamado ou atuado.
enum SkillType {
	PRE_INIT_PHASE, ## na fase de PRE_INI_PHASE
	COOKED_FUSION, ## quando estiver no forno de fusão
	COOKED_ACCELR, ## quando estiver no forno de aceleração
	INIT_PHASE,  ## na fase de INI_PHASE, fase dos fornos
	MAIN_PHASE,  ## na fase de MAIN_PHASE
	END_PHASE, ## na fase de END_PHASE
	ACTION, ## pode ser ativado pelo usuario durante a MAIN PHASE
	LINKED, ## quando for linkado
	UNLINKED, ## quando for deslinkado
	PRE_ATTACK, ## ativado antes de atacar
	POS_ATTACK, ## ativado após atacar
	PRE_DEFEND, ## antes de sofrer ataque
	POS_DEFEND, ## depois de sofrer ataque
	POS_ACTION, ## após um efeito for ativado
	PASSIVE, ## efeito sempre ativo, assim q é instanciado e até o elemento ser removido 
}

## aqui se define onde essa skill vai ser chamada.
var skill_type: SkillType

## registra esse efeito de acordo com o tempo de ação
func register(player: PlayerController.Players):
	ElementEffectManager.effects_pool_players[player][skill_type] = self

## remove o registro
func unregister(player: PlayerController.Players):
	ElementEffectManager.effects_pool_players[player][skill_type].erase(self)

## aqui acontece o efeito, acessando a ARENA, na qual pode interagir todos elementos
## e com o estado dos jogadores.
func execute():
	Gameplay.arena
