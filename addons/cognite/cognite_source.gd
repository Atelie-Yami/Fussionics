@tool
extends Resource

const GRAPH_RESOURCE = {"type": 0, "properties": {}, "connections": []}

@export var chipset_modus: Bot.ModusOperandi
@export var graph_nodes: Dictionary
# {name: {"type": int, "properties": Dictionary, "connections": Array[Array]}}


func append_node(_name: String, type: int):
	var node := GRAPH_RESOURCE.duplicate(true)
	node.type = type
	graph_nodes[_name] = node


func update_node(_name: String, properties: Dictionary, connections: Array[Array]):
	graph_nodes[_name].properties  = properties
	graph_nodes[_name].connections = connections


func is_cognite_resource():
	return true
