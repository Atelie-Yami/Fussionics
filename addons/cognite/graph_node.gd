class_name CogniteGraphNode extends GraphNode


@onready var graph_edit: GraphEdit = get_parent()


func _init():
	show_close = true
	close_request.connect(_delete)


func _delete():
	for c in graph_edit.get_connection_list():
		if c["from"] == name:
			graph_edit.disconnect_node(c["from"], c["from_port"], c["to"], c["to_port"])
	queue_free()


