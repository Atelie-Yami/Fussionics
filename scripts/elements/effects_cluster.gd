class_name EffectCluster extends RefCounted

## tokens são informações que um efeito pode passar para o outro
## assim efeitos podem serem manipulados durante a execução
enum Token {
	TURN, ## referente a tempo e turnos
}
enum BindToken {
	MORE,  ## bind que almentará o valor do token
	MINUS, ## bind que diminuará o valor do token
	SET,   ## bind que alterará o valor do token
}
enum Tag {
	RADIOATIVE, BURNING, IONIC, ANION, RADIOATIVE_SHIELD, ALPHA, BETA,
}
const _IS_ASSALT_TEST := [
	SkillEffect.MechanicMode.DESTROYER, SkillEffect.MechanicMode.WEAKENER, SkillEffect.MechanicMode.DECLINER,
	SkillEffect.MechanicMode.DEBUFFER, SkillEffect.MechanicMode.BUFFER, SkillEffect.MechanicMode.CONTROLLER,
	SkillEffect.MechanicMode.MANIPULATOR, SkillEffect.MechanicMode.SPECIAL
]
const _IS_DEFENDE_TEST := [
	SkillEffect.MechanicMode.DEFENDER, SkillEffect.MechanicMode.IMPROVER, SkillEffect.MechanicMode.DEBUFFER,
	SkillEffect.MechanicMode.BUFFER, SkillEffect.MechanicMode.CONTROLLER, SkillEffect.MechanicMode.MANIPULATOR,
	SkillEffect.MechanicMode.SPECIAL
]

var targets: Array[Element]

var cluster := {
	SkillEffect.MoleculeEffectType.MECHANICAL: [],
	SkillEffect.MoleculeEffectType.UPGRADE: [],
	SkillEffect.MoleculeEffectType.MULTI: [],
}
var molecule: Molecule


func _init(header: SkillEffect, pack: Array[SkillEffect], _molecule: Molecule):
	molecule = _molecule
	
	var _TEST: Array
	match header.mechanic_mode:
		SkillEffect.MechanicMode.DESTROYER, SkillEffect.MechanicMode.WEAKENER, SkillEffect.MechanicMode.DECLINER:
			_TEST = _IS_ASSALT_TEST
			
		SkillEffect.MechanicMode.DEFENDER, SkillEffect.MechanicMode.IMPROVER:
			_TEST = _IS_DEFENDE_TEST
		
		SkillEffect.MechanicMode.SPECIAL, SkillEffect.MechanicMode.MANIPULATOR:
			_TEST = SkillEffect.MechanicMode.keys()
	
	for e in pack:
		if (
				not e.molecule_effect_type == SkillEffect.MoleculeEffectType.TRIGGER and
				e.mechanic_mode in _TEST
		):
			cluster[e.molecule_effect_type].append(e)


## chama os outros efeitos da colecula para criar o efeito final
func construct(header: SkillEffect):
	for list in cluster:
		for effect in cluster[list]:
			bind_tokens(header, cluster[list][effect])
			cluster[list][effect].molecule_effect(self)


## compara os tokens
func bind_tokens(header: SkillEffect, tokens: Dictionary):
	for t in tokens:
		if not header.tokens.has(t):
			continue
		
		match tokens[t][0]:
			BindToken.SET: header.tokens[t][1] = tokens[t][1]
			BindToken.MORE: header.tokens[t][1] += tokens[t][1]
			BindToken.MINUS: header.tokens[t][1] -= tokens[t][1]
