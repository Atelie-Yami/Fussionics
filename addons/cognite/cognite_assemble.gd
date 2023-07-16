@tool
class_name CogniteAssemble extends RefCounted

enum NodeTypes {
	NON, DECISION, DECOMPOSE, LOOP, CONDITION, BEST_MATCH, DIRECTIVE, MODUS = 70
}

class AssembleModuleDecompose:
	signal elements(item)
	signal molecules(item)
	signal elements_in_reactor(item)
	signal energy(item)
	signal powerful_element(item)
	signal weak_element(item)
	signal powerful_molecule(item)
	signal weak_molecule(item)
	
	var analysis: FieldAnalysis
	var bot: Bot
	var field: int
	
	func transmite():
		var report: FieldAnalysis.Report = analysis.my_field if field == 1 else analysis.rival_field
		elements.emit(report.elements)
		molecules.emit(report.molecules)
		elements_in_reactor.emit(report.elements_in_reactor)
		energy.emit(bot.player.energy)
		powerful_element.emit(report.powerful_element)
		weak_element.emit(report.weak_element)
		powerful_molecule.emit(report.powerful_molecule)
		weak_molecule.emit(report.weak_molecule)

class AssembleModuleDecision:
	signal decision(obj)
	
	var action: int
	var act_target: int
	var directive: Array
	var targets: Array
	var priority: int
	var decision_link: Decision
	
	func transmite():
		var d = Decision.new()
		d.action = action
		d.targets = targets
		d.priority = priority
		d.directive = directive
		d.action_target = act_target
		d.decision_link = decision_link
		decision.emit(d)

class AssembleModuleLoop:
	signal issuer(item)
	var callable: Callable = receptor
	func receptor(loops, list):
		if list:
			for i in list:
				if list is Array:      issuer.emit(i)
				if list is Dictionary: issuer.emit([i, list[i]])
				if list is int:        issuer.emit(i)
		else:
			for i in loops:
				issuer.emit(i)


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
	
	for node in graph_nodes.values():
		match node.type:
			NodeTypes.BEST_MATCH:
				AssembleModuleDecision
			NodeTypes.CONDITION:
				pass
			NodeTypes.DECISION:
				AssembleModuleDecision.new()
			NodeTypes.DIRECTIVE:
				pass
			NodeTypes.LOOP:
				pass
		
		
	
	
	for connection in graph_nodes.modus.connections:
		var node: Dictionary = graph_nodes[connection[2]]
		var decompose = AssembleModuleDecompose.new()
		decompose.callable.bind(node.properties.field)
		modus_action[connection[1]].append(decompose)
		
		var callables: Dictionary
		for link in node.connections as Array[Array]:
			var linked_node: Dictionary = graph_nodes[link[2]]
			
			var left_node = procedural_asseble(linked_node, graph_nodes)
			decompose.signals[link[1]].connect(left_node.callable)


func procedural_asseble(node: Dictionary, graph_nodes: Dictionary, right_node = null):
	var self_graph: Object
	var left_graph: Object
	
	var _name = graph_nodes.find_key(node)
	if _name == null:
		return
	
	graph_nodes.erase(_name)
	
	match node.type:
		NodeTypes.BEST_MATCH:
			pass
		NodeTypes.CONDITION:
			self_graph = AssembleModuleDecision.new()
			self_graph.callable.bind(node.properties.action, node.properties.action_target)
			
			
			
			for nodes in graph_nodes.values():
				for link in nodes.connections:
					if link[2] == _name:
						procedural_asseble(nodes, graph_nodes, _name)
			
			
		NodeTypes.DECISION:
			pass
		NodeTypes.DIRECTIVE:
			pass
		NodeTypes.LOOP:
			self_graph = AssembleModuleLoop.new()
			self_graph.callable.bind(node.properties.loop if node.properties.has("loop") else 0)
	
	for link in node.connections as Array[Array]:
		var linked_node: Dictionary = graph_nodes[link[2]]
		left_graph = procedural_asseble(linked_node, graph_nodes)
	
	match node.type:
		NodeTypes.LOOP:
			self_graph.issuer.connect(left_graph.callable)

	return self_graph


func reverse_procedural_asseble(node, graph_nodes, left_node_name):
	var self_graph: Object
	var left_graph: Object
	
	var _name = graph_nodes.find_key(node)
	if _name == null:
		return
	graph_nodes.erase(_name)
	
	match node.type:
		NodeTypes.BEST_MATCH:
			pass
		NodeTypes.CONDITION:
			pass
	
	for link in node.connections as Array[Array]:
		var linked_node: Dictionary = graph_nodes[link[2]]
		graph_nodes.find_key(node)
		
		if link[2] != left_node_name:
			left_graph = procedural_asseble(linked_node, graph_nodes)



