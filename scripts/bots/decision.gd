class_name Decision extends RefCounted

enum Action {
	DESTROY, DEFEND, POTENTIALIZE, MITIGATE, MERGE, COOK, CREATE, TRANSLATE
}
enum ActionTarget {
	MY_ELEMENT, MY_MOLECULE, RIVAL_ELEMENT, RIVAL_MOLECULE,
}
enum Directive {
	FORCED,     # força a execução a garantir sucesso
	RELINK,     # remova os links e os ligue novamente
	CLEAR_SLOT, # remova o elemento do slot caso haja algo
	MAX_ENERGY, # define o maximo de energia a ser gasto
}
enum Tags {
	FUSION, ACCELR, 
}

var is_completed: bool
var is_decision_linked: bool

var action_target: ActionTarget
var action: Action
var targets: Array
var decision_link: Decision # outra tarefa que precisa ser completada antes
var directive: Dictionary

# mais coisas que possam ser uteis para a execução, ex: posição, molecula, quantidade de links...
var extra_args: Array 


static func create_molecule() -> Decision:
	var decision := Decision.new()
	decision.action_target = ActionTarget.MY_MOLECULE
	decision.action = Action.CREATE
	return decision


static func create_element() -> Decision:
	var decision := Decision.new()
	decision.action_target = ActionTarget.MY_ELEMENT
	decision.action = Action.CREATE
	return decision


static func potentialize_element(element_pivot: Element) -> Decision:
	var decision := Decision.new()
	decision.action_target = ActionTarget.MY_ELEMENT
	decision.action = Action.POTENTIALIZE
	decision.targets = [element_pivot]
	return decision


static func create_element_merge_molecule(molecule: Molecule) -> Array:
	var decision_link := create_element()
	decision_link.is_decision_linked = true
	
	var decision := Decision.new()
	decision.decision_link = decision_link
	decision.action_target = ActionTarget.MY_ELEMENT
	decision.action = Action.MERGE
	decision.targets = [molecule]
	
	return [decision_link, decision]
