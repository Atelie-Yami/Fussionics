class_name BaseEffect extends RefCounted

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
	DEFEND_MODE, ## quando o elemento entrar em modo de defesa
	PASSIVE, ## efeito sempre ativo, assim q é instanciado e até o elemento ser removido 
}
enum TargetMode {
	NO_TARGET,    ## default, elemento sem mecanica de foco
	SINGLE,       ## foca em um unico alvo
	MULTI_SINGLE, ## foca em varios alvos diferentes 
	AREA,         ## foca em uma area determinada
	ZONE,         ## afeta grande parte da arena ou partes espeficicas
}
enum MechanicMode {
	# ASSALT
	DESTROYER, ## mira em inimigos para destruilos
	WEAKENER,  ## enfraquece o inimigo para tormar mais facil de derrotar e/ou melhora o ataque aliado
	# DEFENDER
	DEFENDER, ## possui mecanicas de proteção da molecula
	IMPROVER, ## melhora as formas de defesa
	# SUPORT
	DECLINER, ## focado em reduzir o ataque e/ou defesa do inimigo
	DEBUFFER, ## aplica efeitos maleficos nos inimigos
	BUFFER,   ## aplica efeitos beneficos na molecula
	# CONTROLLERS
	CONTROLLER,  ## controla o funcionamento de algo na molecula
	MANIPULATOR, ## controla o funcionamento de algo dos inimigos
	# OTHERS
	SPECIAL, ## possiu um efeito que altera algo no jogo de forma unica.
}
enum Ranking {
	NORMAL,   ## sem efeito
	IMPROVED, ## tem um efeito simples
	ENHANCED, ## tem um efeito significativo
	ELITE,    ## tem um efeito poderoso
}

## aqui se define onde essa skill vai ser chamada.
var mechanic_mode: MechanicMode
var target_mode: TargetMode
var ranking: Ranking

var skill_type: SkillType:
	set(value):
		skill_type = value
		
		if skill_type != SkillType.ACTION:
			register()

var element: Element
var player: PlayerController.Players
var _registred: bool
var active := true


## registra esse efeito de acordo com o tempo de ação
func register():
	ElementEffectManager.effects_pool_players[player][skill_type].append(self)
	_registred = true


## remove o registro
func unregister():
	if _registred:
		ElementEffectManager.effects_pool_players[player][skill_type].erase(self)


## aqui acontece o efeito
func execute():
	pass
