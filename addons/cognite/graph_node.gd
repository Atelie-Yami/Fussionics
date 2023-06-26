@tool
class_name CogniteGraphNode extends GraphNode


var graph_resource: Resource
var graph_edit: GraphEdit


func _init():
	show_close = true
	close_request.connect(_delete)
	dragged.connect(_dragged)
	
	await ready
	graph_edit = get_parent()


func _delete():
	for c in graph_edit.get_connection_list():
		if c["from"] == name:
			graph_edit.disconnect_node(c["from"], c["from_port"], c["to"], c["to_port"])
	queue_free()


func _dragged(from: Vector2, to: Vector2):
	graph_resource.graph_nodes[name.replace("@", "_")].properties["position_offset"] = to
