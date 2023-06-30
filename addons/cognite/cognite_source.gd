@tool
class_name CogniteSource extends Resource

enum NodeTypes {NON, DECISION, DECOMPOSE, LOOP, CONDITION, BEST_MATCH, DIRECTIVE, MODUS = 70}



@export var hash := 100
@export var chipset_selection: int
@export var graph_nodes := {
	"modus": {"type": 70, "properties": {}, "connections": []},
}
@export var bake: bool:
	set(value):
		assemble()


func append_node(_name: String, type: int):
	var node := {"type": 0, "properties": {}, "connections": []}
	node.type = type
	graph_nodes[_name] = node


func update_node(_name: String, properties: Dictionary, connections: Array[Array]):
	graph_nodes[_name].properties  = properties
	graph_nodes[_name].connections = connections


func get_hash() -> int:
	hash += 1
	return hash


func is_cognite_resource():
	return true


func assemble():
	var build = CogniteAssemble.new()
	build.chipset_modus = CogniteAssemble.assemble_modus[chipset_selection -1]
	
	for connection in graph_nodes.modus.connections:
		var dcp: Dictionary = graph_nodes[connection[2]]
		build.modus_action[connection[1]]["decompose"] = {connection[2]: decompose.bind(dcp.properties.field)}
		
		# isso deveria ser recursivo, pq vai usar a porta do item anterior para conectar no callable
		# ja tem a porta de saida, entao da pra usar isso no callable do node receptor
		
		for link in dcp.connections as Array[Array]:
			var node: Dictionary = graph_nodes[link[2]]
			
			match node.type:
				NodeTypes.CONDITION:
					pass


func decompose(field: int, analysis: FieldAnalysis, bot: Bot):
	var report: FieldAnalysis.Report = analysis.my_field if field == 1 else analysis.rival_field
	return [
		report.elements,
		report.molecules,
		report.elements_in_reactor,
		bot.player.energy,
		report.powerful_element,
		report.weak_element,
		report.powerful_molecule,
		report.weak_molecule
	]


func condition(condition: int, args):
	pass
