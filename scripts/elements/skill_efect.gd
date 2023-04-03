## classe que detem todos os efeitos dos elementos
class_name SkillEffect extends RefCounted

const BOOK := {
	0: preload("res://scripts/elements/effects/hidrogen.gd"),
	2: preload("res://scripts/elements/effects/lithium.gd"),
}

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
## Tipo de efeito que o elemento altera na molecula
enum MoleculeEffectType {
	TRIGGER,    ## cria e controla o uso de efeito da molecula
	MECHANICAL, ## muda alguma mecanica ou forma q algo funciona
	UPGRADE,    ## altera as propriedades já existentes na molecula
	MULTI,      ## possui alguma combinação dos tipos anteriores
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
	WEAKENER,  ## enfraquece o inimigo para tormar mais facil de derrotar
	DECLINER,  ## focado em reduzir o ataque do inimigo
	# DEFENDER
	DEFENDER, ## possui mecanicas de proteção da molecula
	IMPROVER, ## melhora as formas de defesa
	# SUPORT
	DEBUFFER, ## aplica efeitos maleficos nos inimigos
	BUFFER,   ## aplica efeitos beneficos na molecula
	# CONTROLLERS
	CONTROLLER,  ## controla o funcionamento de algo na molecula
	MANIPULATOR, ## controla o funcionamento de algo dos inimigos
	# OTHERS
	SPECIAL, ## possiu um efeito que altera algo no jogo de forma unica.
}
enum BindToken {
	MORE, MINUS, SET
}
enum Token {
	TIME_TURN_AMOUNT, ## referente a tempo e turnos 
}
enum Tag {
	RADIOATIVE, BURNING, IONIC, ANION, RADIOATIVE_SHIELD, ALPHA, BETA,
}
const _IS_ASSALT_TEST := [
	MechanicMode.DESTROYER, MechanicMode.WEAKENER, MechanicMode.DECLINER,
	MechanicMode.DEBUFFER, MechanicMode.BUFFER, MechanicMode.CONTROLLER,
	MechanicMode.MANIPULATOR, MechanicMode.SPECIAL
]
const _IS_DEFENDE_TEST := [
	MechanicMode.DEFENDER, MechanicMode.IMPROVER, MechanicMode.DEBUFFER,
	MechanicMode.BUFFER, MechanicMode.CONTROLLER, MechanicMode.MANIPULATOR,
	MechanicMode.SPECIAL
]

class EffectCluster:
	var header: SkillEffect
	var cluster := {
		MoleculeEffectType.MECHANICAL: [],
		MoleculeEffectType.UPGRADE: [],
		MoleculeEffectType.MULTI: [],
	}
	var mechanicals: Array[SkillEffect]
	var upgrades: Array[SkillEffect]
	var multi: Array[SkillEffect]
	
	func construct(_header: SkillEffect, pack: Array[SkillEffect]):
		header = _header
		var _TEST: Array
		
		match header.mechanic_mode:
			MechanicMode.DESTROYER, MechanicMode.WEAKENER, MechanicMode.DECLINER:
				_TEST = _IS_ASSALT_TEST
				
			MechanicMode.DEFENDER, MechanicMode.IMPROVER:
				_TEST = _IS_DEFENDE_TEST
			
			MechanicMode.SPECIAL, MechanicMode.MANIPULATOR:
				_TEST = MechanicMode.keys()
		
		for e in pack:
			if (
					not e.molecule_effect_type == MoleculeEffectType.TRIGGER and
					e.mechanic_mode in _TEST
			):
				cluster[e.molecule_effect_type].append(e)
	
	func active(molecule: Molecule):
		for list in cluster:
			for effect in cluster[list]:
				bind_tokens(cluster[list][effect])
				cluster[list][effect].molecule_effect(molecule)
	
	func bind_tokens(tokens: Dictionary):
		for t in tokens:
			if not header.tokens.has(t):
				continue
			
			match tokens[t][0]:
				BindToken.SET: header.tokens[t][1] = tokens[t][1]
				BindToken.MORE: header.tokens[t][1] += tokens[t][1]
				BindToken.MINUS: header.tokens[t][1] -= tokens[t][1]


## aqui se define onde essa skill vai ser chamada.
var skill_type: SkillType
var molecule_effect_type: MoleculeEffectType
var mechanic_mode: MechanicMode
var target_mode: TargetMode
var active := true

var element: Element
var _registred: bool

# {token : [ BindToken, valor ]}
var tokens: Dictionary


## registra esse efeito de acordo com o tempo de ação
func register(player: PlayerController.Players):
	ElementEffectManager.effects_pool_players[player][skill_type].append(self)
	_registred = true


## remove o registro
func unregister(player: PlayerController.Players):
	if _registred:
		ElementEffectManager.effects_pool_players[player][skill_type].erase(self)


## aqui acontece o efeito, acessando a ARENA, na qual pode interagir todos elementos
## e com o estado dos jogadores.
func execute():
	print(Gameplay.arena)


func molecule_effect(molecule: Molecule):
	molecule.prepare_element_for_attack(element)



