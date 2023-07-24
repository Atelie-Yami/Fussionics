@tool
class_name CogniteAssemble extends RefCounted

enum NodeTypes {
	NON, DECISION, DECOMPOSE, LOOP, CONDITION, BEST_MATCH, DIRECTIVE, MODUS = 70
}

class AssembleModuleModus:
	signal aggressive(analisys)
	signal defensive(analisys)
	signal undecided(analisys)
	signal tatical_agressive(analisys)
	signal tatical_defensive(analisys)
	
	var chipsets := [AmethistChipSet, SapphireChipSet]
	var signals := [aggressive, defensive, undecided, tatical_agressive, tatical_defensive]
	var chipset: int
	var bot: Bot
	
	func transmite():
		print(self)
		var analysis = FieldAnalysis.make(bot)
		var modus_operandi = chipsets[chipset].get_modus(analysis)
		signals[modus_operandi].emit(analysis)
		print(signals[modus_operandi])

class AssembleModuleExecute:
	var chipsets := [AmethistChipSet, SapphireChipSet]
	var decisions: Array[Decision]
	var chipset: int
	var bot: Bot
	
	func receiver_0(decision: Decision):
		decisions.append(decision)
	
	func transmite():
		await ChipSet.execute(decisions, bot)

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
	
	func receiver_0(analysis: FieldAnalysis):
		print(self)
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
	var directive: Dictionary
	var decision_link: Decision
	
	func receiver_0(array: Array):
		targets = array
	
	func receiver_1(list: Dictionary):
		directive = list
	
	func receiver_2(link: Decision):
		decision_link = link
	
	func receiver_3(args):
		transmite()
	
	func transmite():
		var d = Decision.new()
		d.action = properties.action -1
		d.targets = targets
#		d.priority = properties.priority
		d.directive = directive
		d.action_target = properties.action_target -1
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
	
	var args
	var condition_A
	var condition_B
	var properties: Dictionary
	
	var await_args: int = 0
	var awaiting_assignment: bool
	
	func receiver_0(_args):
		args = _args
		awaiting_assignment = false
		
		if await_args == 0:
			if properties.has("line_edit_A") and properties.has("line_edit_B"):
				transmite()
			
			else:
				awaiting_assignment = true
		
		else:
			if properties.has("line_edit_A") or properties.has("line_edit_B"):
				transmite()
			
			else:
				awaiting_assignment = true
	
	func receiver_1(item):
		condition_A = item
		
		await_args += 1
		if await_args > 1:
			transmite()
			
		elif awaiting_assignment:
			receiver_0(null)
		
		
	func receiver_2(item):
		condition_B = item
		
		await_args += 1
		if await_args > 1:
			transmite()
		
		elif awaiting_assignment:
			receiver_0(null)
		
	
	func transmite():
		print(self)
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

class AssembleModuleWaiter:
	signal statament
	
	var properties: Dictionary
	var waiter_count := 0
	var issuer_list: Dictionary
	
	func receiver(args, port):
		issuer_list[port] = args
		waiter_count += 1
		
		if waiter_count == properties.size_count:
			transmite()
	
	func receiver_0(args): receiver(args, 0)
	func receiver_1(args): receiver(args, 1)
	func receiver_2(args): receiver(args, 2)
	func receiver_3(args): receiver(args, 3)
	func receiver_4(args): receiver(args, 4)
	func receiver_5(args): receiver(args, 5)
	func receiver_6(args): receiver(args, 6)
	func receiver_7(args): receiver(args, 7)
	func receiver_8(args): receiver(args, 8)
	func receiver_9(args): receiver(args, 9)
	
	func construct():
		for i in properties.size_count:
			add_user_signal("issuer_" + str(i), [{ "name": "args", "type": TYPE_MAX}])
	
	func transmite():
		print(issuer_list) # teste
		return             # teste
		
		for port in issuer_list:
			if issuer_list[port]:
				emit_signal("issuer_" + str(port), issuer_list[port])
			else:
				emit_signal("issuer_" + str(port))

class AssembleModuleParallel:
	signal issuer
	
	var properties: Dictionary
	
	func transmite():
		issuer.emit()


var built_types := [
	AssembleModuleDecision, AssembleModuleDecompose, AssembleModuleLoop, AssembleModuleCondition,
	AssembleModuleBestmatch, AssembleModuleDirective, AssembleModuleWaiter, AssembleModuleParallel
]

var modus_action := {
	Bot.ModusOperandi.UNDECIDED: [],
	Bot.ModusOperandi.DEFENSIVE: [],
	Bot.ModusOperandi.AGGRESSIVE: [],
	Bot.ModusOperandi.STRATEGICAL_DEFENSIVE: [],
	Bot.ModusOperandi.STRATEGICAL_AGGRESSIVE: [],
}

var mounted_nodes: Dictionary
var parallel_nodes: Array[Array] = [[], [], [], [], []]


func run():
	for i in 5:
		for node in parallel_nodes[4 - i]:
			node.transmite()
	
	mounted_nodes.modus.transmite()
	await mounted_nodes.decisions.transmite()


func assemble(bot: Bot, graph_nodes: Dictionary):
	for node in graph_nodes:
		var _node
		match graph_nodes[node].type:
			70: _node = AssembleModuleModus.new()
			55: _node = AssembleModuleExecute.new()
			_: _node = built_types[graph_nodes[node].type].new()
		
		match graph_nodes[node].type:
			70, 55:
				_node.chipset = graph_nodes[node].properties.chipset
				mounted_nodes[node] = _node
				_node.bot = bot
			_:
				for prop_name in graph_nodes[node].properties:
					_node.properties[prop_name] = graph_nodes[node].properties[prop_name]
				mounted_nodes[node] = _node
		
		match graph_nodes[node].type:
			1: _node.properties["bot"] = bot
			6: _node.construct()
			7: parallel_nodes[_node.properties.priority].append(_node)
	
	for node in graph_nodes:
		var current_node: RefCounted = mounted_nodes[node]
		for link in graph_nodes[node].connections as Array[Array]:
			var port: Dictionary = current_node.get_signal_list()[link[1]]
			
			var callable = Callable(mounted_nodes[link[2]], "receiver_" + str(link[3]))
			current_node.connect(port.name, callable)


