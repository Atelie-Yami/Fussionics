class_name ElementNode extends Element

const FUTURE_SALLOW := preload("res://assets/fonts/Future Sallow.ttf")
var STYLEBOX := preload("res://resouces/stylebox/element.stylebox")

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


var time := 0.0
func _process(delta):
	time += delta * 2.0
	
	var m : int = 16 * abs(cos(time))
	
	if current_node_state == NodeState.HOVER:
		pass
	
	STYLEBOX.set_border_width(SIDE_BOTTOM, m)
	STYLEBOX.set_border_width(SIDE_LEFT, m)
	STYLEBOX.set_border_width(SIDE_RIGHT, m)
	STYLEBOX.set_border_width(SIDE_TOP, m)
	
	queue_redraw()


func _draw():
#	draw_rect(Rect2(0, 0, 80, 80), Color(1, 1, 1, 0.05))
	draw_style_box(STYLEBOX, Rect2(0, 0, 80, 80))
	
	var string_size = FUTURE_SALLOW.get_string_size(DATA[atomic_number][SIMBOL], HORIZONTAL_ALIGNMENT_CENTER, -1, 60) / 2
	draw_string(
		FUTURE_SALLOW, Vector2(41 - string_size.x, 59), DATA[atomic_number][SIMBOL], HORIZONTAL_ALIGNMENT_CENTER,
		-1, 60, COLOR_SERIES[DATA[atomic_number][SERIE]] * 2.0
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
