@tool
extends GraphEdit

const GRAPH_RESOURCE =  preload("res://addons/cognite/cognite_source.gd")

enum PortTypes {
	VARIANT = 99, # 8835ff
	ANALISYS = 0, # d2fff0
	DECISION = 40,# ffe671
	ARRAY = 56,   # d95400
	INT = 87,     # ff3030
}
const GRAPH_NODES := [
	preload("res://addons/cognite/interface/decision.tscn"),
	preload("res://addons/cognite/interface/decompose.tscn"),
	preload("res://addons/cognite/interface/loop.tscn"),
	preload("res://addons/cognite/interface/condition.tscn"),
	preload("res://addons/cognite/interface/best_match.tscn"),
]

var nodes: Array[GraphNode]
var current_resource
var is_ready: bool

@onready var select_graphnode = $HBoxContainer/select_graphnode


func _ready():
	add_valid_connection_type(99, 40)
	add_valid_connection_type(99, 56)
	add_valid_connection_type(99, 87)
	add_valid_connection_type(0, 99)
	add_valid_connection_type(40, 99)
	add_valid_connection_type(56, 99)
	add_valid_connection_type(87, 99)
	
	if current_resource:
		apply_resource()
	
	else:
		current_resource = GRAPH_RESOURCE.new()
	
	is_ready = true


func load_resource(resource):
	if is_ready and current_resource and current_resource != resource:
		clear_connections()
		
		for node in nodes:
			if is_instance_valid(node):
				node.queue_free()
		nodes.clear()
	
	current_resource = resource
	
	if is_ready:
		apply_resource()


func apply_resource():
	var links: Array
	
	for node in current_resource.graph_nodes:
		var pack: Dictionary = current_resource.graph_nodes[node]
		
		var graph_node: GraphNode = create_graph(pack.type)
		graph_node.name = node
		print("graph_node.name ", graph_node.name)
		
		for prop in pack.properties:
			graph_node.set(prop, pack.properties[prop])
		
		links.append_array(pack.connections)
	
	for connections in links:
		connect_node(connections[0], connections[1], connections[2], connections[3])


func create_graph(type: int):
	var graph_node: GraphNode = GRAPH_NODES[type].instantiate()
	nodes.append(graph_node)
	add_child(graph_node)
	
	select_graphnode.selected = 0
	graph_node.position_offset = Vector2(500, 300)
	
	graph_node.graph_resource = current_resource
	print(graph_node.name)
	
	return graph_node


func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	current_resource.graph_nodes[from_node.replace("@", "_")].connections.append([from_node, from_port, to_node, to_port])
	connect_node(from_node, from_port, to_node, to_port)


func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	current_resource.graph_nodes[from_node.replace("@", "_")].connections.erase([from_node, from_port, to_node, to_port])
	disconnect_node(from_node, from_port, to_node, to_port)


func _on_select_graphnode_item_selected(index):
	var graph_node: GraphNode = create_graph(index - 1)
	var new_name = graph_node.name.replace("@", "_")
	current_resource.append_node(new_name, index - 1)
	print(new_name)


