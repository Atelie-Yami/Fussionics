@tool
class_name CogniteSource extends Resource


@export var hash := 100
@export var graph_nodes := {
	"modus": {"type": 70, "properties": {"chipset": 0}, "connections": []},
	"decisions": {"type": 55, "properties": {"chipset": 0}, "connections": []},
}

func append_node(_name: String, type: int):
	var node := {"type": 0, "properties": {}, "connections": []}
	node.type = type
	graph_nodes[_name] = node


func update_node(_name: String, properties: Dictionary, connections: Array[Array]):
	graph_nodes[_name].properties  = properties
	graph_nodes[_name].connections = connections
	Resource


func get_hash() -> int:
	hash += 1
	return hash


func is_cognite_resource():
	return true


func condition(condition: int, args):
	pass
