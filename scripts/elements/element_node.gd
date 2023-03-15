class_name ElementNode extends Element

const FUTURE_SALLOW := preload("res://assets/fonts/Future Sallow.ttf")
const MOLDURE_1 := preload("res://assets/img/elements/element_moldure.png")

enum State {
	NORMAL, BIND_LINK, REMOVE_LINK, ATTACKING, DEFENDING, MOTION, COOKING
}
enum NodeState {
	NORMAL, HOVER, SELECTED
}

var current_state: State
var current_node_state: NodeState
var active: bool:
	set(value):
		active = value
		if not active: set_current_node_state(NodeState.NORMAL)


func _init():
	mouse_entered.connect(_mouse_entered)
	mouse_exited .connect(_mouse_exited)


func _process(delta):
	queue_redraw()


func _draw():
	draw_texture_rect(MOLDURE_1, Rect2(0, 0, 80, 80), false, Color.WHITE * 0.5)
	
	var string_size = FUTURE_SALLOW.get_string_size(DATA[atomic_number][SIMBOL], HORIZONTAL_ALIGNMENT_CENTER, -1, 60) / 2
	draw_string(
		FUTURE_SALLOW, Vector2(41 - string_size.x, 59), DATA[atomic_number][SIMBOL], HORIZONTAL_ALIGNMENT_CENTER,
		-1, 60, COLOR_SERIES[DATA[atomic_number][SERIE]]
	)
	
	modulate = (Color.WHITE * 0.5) +  (COLOR_SERIES[DATA[atomic_number][SERIE]] * 0.5)
	material.set_shader_parameter("color", COLOR_SERIES[DATA[atomic_number][SERIE]])


func set_current_node_state(state: NodeState):
	if current_node_state == state: return
	current_node_state = state
	
	match current_node_state:
		NodeState.NORMAL: pass
		NodeState.HOVER: pass
		NodeState.SELECTED: pass


func _gui_input(event: InputEvent):
	if event.is_action("mouse_click") and event.is_pressed():
		if active:
			set_current_node_state(NodeState.SELECTED)


func _mouse_entered():
	if active:
		set_current_node_state(NodeState.HOVER)
	

func _mouse_exited():
	if active:
		set_current_node_state(NodeState.NORMAL)
