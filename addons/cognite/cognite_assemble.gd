@tool
class_name CogniteAssemble extends RefCounted

enum NodeTypes {
	NON, DECISION, DECOMPOSE, LOOP, CONDITION, BEST_MATCH, DIRECTIVE, MODUS = 70
}

class AssembleModule:
	signal issuer_1
	
	var properties: Dictionary # {property_name: value}
	
	func _transmite(): # metodo para se caso esse modulo nao receba parametros
		pass
	
	func receiver_1(): # metodo referente a primeira porta e assim por diante
		pass

class AssembleModuleDecompose:
	signal elements(item)
	signal molecules(item)
	signal elements_in_reactor(item)
	signal energy(item)
	signal powerful_element(item)
	signal weak_element(item)
	signal powerful_molecule(item)
	signal weak_molecule(item)
	
	var properties: Dictionary
	
#	var bot: Bot
#	var field: int
	
	func receiver_0(analysis: FieldAnalysis):
		var report: FieldAnalysis.Report = analysis.my_field if properties.field == 1 else analysis.rival_field
		elements.emit(report.elements)
		molecules.emit(report.molecules)
		elements_in_reactor.emit(report.elements_in_reactor)
		energy.emit(properties.bot.player.energy)
		powerful_element.emit(report.powerful_element)
		weak_element.emit(report.weak_element)
		powerful_molecule.emit(report.powerful_molecule)
		weak_molecule.emit(report.weak_molecule)

class AssembleModuleDecision:
	signal decision(obj)
	
	var properties: Dictionary
	
	var targets: Array
	var directive: Array
	var decision_link: Decision
	
	func receiver_0(array: Array):
		targets = array
	
	func receiver_1(array: Array):
		directive = array
	
	func receiver_2(link: Decision):
		decision_link = link
	
	func receiver_3():
		pass
	
	func transmite():
		var d = Decision.new()
		d.action = properties.action
		d.targets = targets
		d.priority = properties.priority
		d.directive = directive
		d.action_target = properties.act_target
		d.decision_link = decision_link
		decision.emit(d)

class AssembleModuleLoop:
	signal issuer(item)
	
	var properties: Dictionary
	var list
	
	func receiver_0(_list):
		list = _list
	
	func transmite():
		if list:
			for i in list:
				if list is Array:      issuer.emit(i)
				if list is Dictionary: issuer.emit([i, list[i]])
				if list is int:        issuer.emit(i)
		else:
			for i in properties.loop:
				issuer.emit(i)

class AssembleModuleCondition:
	signal issuer
	
	var condition_A
	var condition_B
	var properties: Dictionary
	
	func receiver_0(item):
		condition_A = item
		
	func receiver_1(item):
		condition_B = item
	
	func transmite():
		if not condition_A:
			condition_A = properties.line_edit_A
		if not condition_B:
			condition_B = properties.line_edit_B
		
		if (
			(properties.condition == 1 and condition_A > condition_B) or
			(properties.condition == 2 and condition_A < condition_B) or 
			(properties.condition == 3 and condition_A == condition_B)
		):
			issuer.emit()

class AssembleModuleBestmatch:
	signal issuer(item)
	
	var properties: Dictionary
	var array
	
	func receiver_0(_array):
		array = _array
	
	func transmite():
		match properties.match:
			1:
				var opening_list: Array[Element]
				for e in array as Array[Element]:
					if e.number_electrons_in_valencia == 0:
						continue
					
					for link in e.links:
						if not e.links[link]:
							opening_list.append(e)
							break
				
				if not opening_list.is_empty():
					issuer.emit(opening_list)
			2:
				var best_match: Element
				for element in array as Array[Element]:
					if not best_match:
						best_match = element
						continue
					
					if element.eletrons > best_match.eletrons or element.neutrons > best_match.neutrons:
						best_match = element
				
				if best_match:
					issuer.emit(best_match)
			3:
				var active_list: Array[Element]
				for e in array as Array[Element]:
					if e.active:
						active_list.append(e)
				
				issuer.emit(active_list)
			4:
				var best_match: Molecule
				var best_result: int
				for molecule in array as Array[Molecule]:
					if not best_match or GameJudge.calcule_max_molecule_eletrons_power(molecule) > best_result:
						best_match = molecule
						best_result = GameJudge.calcule_max_molecule_eletrons_power(best_match)
				
				if best_match:
					issuer.emit(best_match)
			5:
				if not array.is_empty():
					issuer.emit(array[0])
			6:
				if not array.is_empty():
					issuer.emit(array[-1])

class AssembleModuleDirective:
	signal issuer(item)
	
	var properties: Dictionary
	
	func receiver_0(item):
		var list: Dictionary
		list[properties.directive] = item
		issuer.emit(list)


var built_types := [
	null, AssembleModuleDecision, AssembleModuleDecompose, AssembleModuleLoop, AssembleModuleCondition,
	AssembleModuleBestmatch, AssembleModuleDirective
]


var assemble_modus := [
	AmethistChipSet.get_modus,
	SapphireChipSet.get_modus,
]

var modus_action := {
	Bot.ModusOperandi.UNDECIDED: [],
	Bot.ModusOperandi.DEFENSIVE: [],
	Bot.ModusOperandi.AGGRESSIVE: [],
	Bot.ModusOperandi.STRATEGICAL_DEFENSIVE: [],
	Bot.ModusOperandi.STRATEGICAL_AGGRESSIVE: [],
}

var nodes: Array
var chipset_selection: int


func run(modus: Bot.ModusOperandi, bot: Bot, analysis: FieldAnalysis):
	for _decompose in modus_action[modus] as Array[Callable]:
		_decompose.call(bot, analysis)


func assemble(analysis: FieldAnalysis, bot: Bot, graph_nodes: Dictionary):
	BotChip.modus = assemble_modus[chipset_selection]
	
	var mounted_nodes: Dictionary
	
	for node in graph_nodes:
		if graph_nodes[node].type == 70:
			continue
		
		var _node = built_types[graph_nodes[node].type].new()
		for prop_name in node.properties:
			_node.properties[prop_name] = node.properties[prop_name]
		
		mounted_nodes[node] = _node
	
	for node in graph_nodes:
		if graph_nodes[node].type == 70:
			continue
		
		var current_node: RefCounted = mounted_nodes[node]
		for link in graph_nodes[node].connections as Array[Array]:
			var port: Dictionary = current_node.get_signal_list()[link[1]]
			var callable = Callable(mounted_nodes[link[2]], "receiver_" + str(link[3]))
			
			current_node.connect(port.name, callable)



