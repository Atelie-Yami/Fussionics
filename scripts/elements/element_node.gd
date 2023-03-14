class_name ElementNode extends Element

const FUTURE_SALLOW := preload("res://assets/fonts/Future Sallow.ttf")

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


func _draw():
	draw_rect(Rect2(0, 0, 80, 80), Color(1, 1, 1, 0.1))
	var size = FUTURE_SALLOW.get_string_size(DATA[atomic_number][SIMBOL], HORIZONTAL_ALIGNMENT_CENTER, -1, 60) / 2
	draw_string(
		FUTURE_SALLOW, Vector2(41 - size.x, 59), DATA[atomic_number][SIMBOL], HORIZONTAL_ALIGNMENT_CENTER,
		-1, 60, COLOR_SERIES[DATA[atomic_number][SERIE]]
	)


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
