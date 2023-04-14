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
	BaseEffect.MechanicMode.DESTROYER, BaseEffect.MechanicMode.WEAKENER, BaseEffect.MechanicMode.DECLINER,
	BaseEffect.MechanicMode.DEBUFFER, BaseEffect.MechanicMode.BUFFER, BaseEffect.MechanicMode.CONTROLLER,
	BaseEffect.MechanicMode.MANIPULATOR, BaseEffect.MechanicMode.SPECIAL
]
const _IS_DEFENDE_TEST := [
	BaseEffect.MechanicMode.DEFENDER, BaseEffect.MechanicMode.IMPROVER, BaseEffect.MechanicMode.DEBUFFER,
	BaseEffect.MechanicMode.BUFFER, BaseEffect.MechanicMode.CONTROLLER, BaseEffect.MechanicMode.MANIPULATOR,
	BaseEffect.MechanicMode.SPECIAL
]

var targets: Array[Element]

var cluster := {
	MoleculeEffect.MoleculeEffectType.MECHANICAL: [],
	MoleculeEffect.MoleculeEffectType.UPGRADE: [],
	MoleculeEffect.MoleculeEffectType.MULTI: [],
}
var molecule: Molecule


func _init(header: MoleculeEffect, pack: Array[MoleculeEffect], _molecule: Molecule):
	molecule = _molecule
	
	var _TEST: Array
	match header.mechanic_mode:
		BaseEffect.MechanicMode.DESTROYER, BaseEffect.MechanicMode.WEAKENER, BaseEffect.MechanicMode.DECLINER:
			_TEST = _IS_ASSALT_TEST
			
		BaseEffect.MechanicMode.DEFENDER, BaseEffect.MechanicMode.IMPROVER:
			_TEST = _IS_DEFENDE_TEST
		
		BaseEffect.MechanicMode.SPECIAL, BaseEffect.MechanicMode.MANIPULATOR:
			_TEST = BaseEffect.MechanicMode.keys()
	
	for e in pack:
		if (
				not e.molecule_effect_type == MoleculeEffect.MoleculeEffectType.TRIGGER and
				e.mechanic_mode in _TEST
		):
			cluster[e.molecule_effect_type].append(e)


## chama os outros efeitos da colecula para criar o efeito final
func construct(header: MoleculeEffect):
	for list in cluster:
		for effect in cluster[list]:
			bind_tokens(header, effect.tokens)
			effect.execute()


## compara os tokens
func bind_tokens(header: MoleculeEffect, tokens: Dictionary):
	for t in tokens:
		if not header.tokens.has(t):
			continue
		
		match tokens[t][0]:
			BindToken.SET: header.tokens[t][1] = tokens[t][1]
			BindToken.MORE: header.tokens[t][1] += tokens[t][1]
			BindToken.MINUS: header.tokens[t][1] -= tokens[t][1]
