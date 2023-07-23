@tool
extends CogniteGraphNode


var size_count_links: int:
	set(value):
		var diff = value - size_count_links
		
		if diff > 0:
			for i in diff:
				add_signal_receiver(size_count_links + i + 1)
		
		elif diff < 0:
			for i in abs(diff):
				remove_signal_receiver(size_count_links - i)
		
		size_count_links = value


@onready var size_node = $size


func construct():
	if graph_resource.graph_nodes[name].properties.has("size_count"):
		size_node.selected = graph_resource.graph_nodes[name].properties["size_count"]
		size_count_links = size_node.selected


func add_signal_receiver(port: int):
	var label = Label.new()
	add_child(label)
	label.text = "Signal"
	
	set("slot/"+ str(port) +"/left_enabled", true)
	set("slot/"+ str(port) +"/right_enabled", true)
	set("slot/"+ str(port) +"/left_type", 99)
	set("slot/"+ str(port) +"/right_type", 99)
	set("slot/"+ str(port) +"/left_color", Color("8835ff"))
	set("slot/"+ str(port) +"/right_color", Color("8835ff"))


func remove_signal_receiver(port: int):
	remove_child(get_child(-1))
	
	for connection in graph_edit.get_connection_list() as Array[Dictionary]:
		if (
				(connection.to == name and connection.to_port == port -1) or 
				(connection.from == name and connection.from_port == port)
		):
			graph_edit.disconnect_node(connection.from, connection.from_port, connection.to, connection.to_port)
	
	set("slot/"+ str(port) +"/left_enabled", false)
	set("slot/"+ str(port) +"/right_enabled", false)
	size = Vector2.ZERO


func _on_size_item_selected(index):
	graph_resource.graph_nodes[name].properties["size_count"] = index
	size_count_links = index
