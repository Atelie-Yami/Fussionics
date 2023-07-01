@tool
class_name CogniteAssemble extends RefCounted

enum NodeTypes {
	NON, DECISION, DECOMPOSE, LOOP, CONDITION, BEST_MATCH, DIRECTIVE, MODUS = 70
}

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

var chipset_selection: int


func run(modus: Bot.ModusOperandi, bot: Bot, analysis: FieldAnalysis):
	for _decompose in modus_action[modus] as Array[Callable]:
		_decompose.call(bot, analysis)


func assemble(graph_nodes: Dictionary):
	BotChip.modus = assemble_modus[chipset_selection]
	
	# a contrução final vai ser um ecadeamento de Callables com os nodes conectados num grafo
	
	# Callable(
		# Callable(
			# Callable(
				# Callable(args), binds
			# ), binds
		#), binds)
	
	# todos os Callables devem receber "analysis: FieldAnalysis, bot: Bot" como argumento final
	
	for connection in graph_nodes.modus.connections:
		var node: Dictionary = graph_nodes[connection[2]]
		var _decompose: Callable = decompose.bind(node.properties.field)
		modus_action[connection[1]].append(_decompose)
		
		# isso deveria ser recursivo, pq vai usar a porta do item anterior para conectar no callable
		# ja tem a porta de saida, entao da pra usar isso no callable do node receptor
		
		var callables: Dictionary
		for link in node.connections as Array[Array]:
			var linked_node: Dictionary = graph_nodes[link[2]]
			var callable: Callable = procedural_asseble(linked_node, graph_nodes)
			
			callables[callable] = link[1]
		_decompose.bind(callables)
	
	# o Callable final precisa returnar no Array[Decision]


func procedural_asseble(node: Dictionary, graph_nodes: Dictionary):
	var callable: Callable
	
	match node.type:
		NodeTypes.BEST_MATCH:
			pass
		NodeTypes.CONDITION:
			pass
		NodeTypes.DECISION:
			pass
		NodeTypes.DIRECTIVE:
			pass
		NodeTypes.LOOP:
			if node.connections.size() == 1:
				var linked_node: Dictionary = graph_nodes[node.connections[0][2]]
				var left_graph: Callable = procedural_asseble(linked_node, graph_nodes)
				
				callable = loop.bind(node, left_graph)
			
			elif node.connections.size() > 1:
				var call_list: Array[Callable]
				
				for link in node.connections as Array[Array]:
					var linked_node: Dictionary = graph_nodes[link[2]]
					var left_graph: Callable = procedural_asseble(linked_node, graph_nodes)
					var _loop = loop.bind(node, left_graph)
					
					call_list.append(_loop)
				
				callable = Callable(
					func(args = null):
						for c in call_list:
							c.call(args) if args else c.call()
				)
	
	return callable


func decompose(field: int, callables: Dictionary, analysis: FieldAnalysis, bot: Bot):
	var report: FieldAnalysis.Report = analysis.my_field if field == 1 else analysis.rival_field
	for c in callables:
		c.call([
		report.elements,
		report.molecules,
		report.elements_in_reactor,
		bot.player.energy,
		report.powerful_element,
		report.weak_element,
		report.powerful_molecule,
		report.weak_molecule
	][callables[c]])


func decision():
	pass


func loop(node: Dictionary, callable: Callable, list):
	if list != null:
		if list is Array:
			return _loop1.bind(list.duplicate(true), callable)
		
		if list is Dictionary:
			return _loop2.bind(list.duplicate(true), callable)
		
		if list is int:
			return _loop0.bind(list, callable)
	
	else:
		return _loop0.bind(node.properties.loop, callable)

func _loop0(count: int, callable: Callable):
	for i in count:
		callable.call()

func _loop1(array: Array, callable: Callable):
	for i in array:
		callable.call(i)

func _loop2(dic: Dictionary, callable: Callable):
	for n in dic:
		callable.call([n, dic[n]])


func condition():
	pass


func best_match():
	pass


func directive():
	pass





