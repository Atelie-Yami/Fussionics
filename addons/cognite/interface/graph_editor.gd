extends GraphEdit

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


@onready var select_graphnode = $HBoxContainer/select_graphnode


func _ready():
	add_valid_connection_type(99, 40)
	add_valid_connection_type(99, 56)
	add_valid_connection_type(99, 87)
	add_valid_connection_type(0, 99)
	add_valid_connection_type(40, 99)
	add_valid_connection_type(56, 99)
	add_valid_connection_type(87, 99)


func _on_connection_request(from_node, from_port, to_node, to_port):
	print(from_node)
	connect_node(from_node, from_port, to_node, to_port)


func _on_disconnection_request(from_node, from_port, to_node, to_port):
	disconnect_node(from_node, from_port, to_node, to_port)


func _on_select_graphnode_item_selected(index):
	var m: GraphNode = GRAPH_NODES[index - 1].instantiate()
	add_child(m)
	m.position_offset = Vector2(500, 300)
	select_graphnode.selected = 0
