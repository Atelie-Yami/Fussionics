@tool
class_name CogniteGraphNode extends GraphNode


var graph_resource: Resource
var graph_edit: GraphEdit
var is_ready: bool


func _init():
	show_close = true
	close_request.connect(_delete)
	dragged.connect(_dragged)


func _ready():
	if is_ready:
		return
	
	is_ready = true
	
	var parent = get_parent()
	if parent is GraphEdit:
		graph_edit = parent
	
	if not graph_resource:
		return
	
	size = Vector2.ONE


func construct():
	pass


func _delete():
	for c in graph_edit.get_connection_list():
		if c["from"] == name:
			graph_edit.disconnect_node(c["from"], c["from_port"], c["to"], c["to_port"])
	(graph_resource.graph_nodes as Dictionary).erase(name)
	graph_edit.remove_graph(self)


func _dragged(from: Vector2, to: Vector2):
	graph_resource.graph_nodes[name].properties["position_offset"] = to
	print("_dragged", name, " ", graph_resource.graph_nodes[name].properties["position_offset"])
