class_name ElementNode extends Element

enum State {
	NORMAL, BIND_LINK, REMOVE_LINK, ATTACKING, DEFENDING, MOTION, COOKING
}
enum NodeState {
	NORMAL, HOVER, SELECTED
}


var current_state: State
var current_node_state: NodeState



func _init():
	mouse_entered.connect(_mouse_entered)
	mouse_exited .connect(_mouse_exited)


func set_current_node_state(state: NodeState):
	if current_node_state == state: return
	
	current_node_state = state
	
	match current_node_state:
		NodeState.NORMAL: pass
		NodeState.HOVER: pass
		NodeState.SELECTED: pass


func _gui_input(event: InputEvent):
	if event.is_action("mouse_click") and current_node_state == NodeState.HOVER:
		set_current_node_state(NodeState.SELECTED)


func _mouse_entered():
	set_current_node_state(NodeState.HOVER)
	

func _mouse_exited():
	set_current_node_state(NodeState.NORMAL)
