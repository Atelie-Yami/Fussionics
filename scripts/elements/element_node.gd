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

var selected: bool
var active: bool = true:
	set(value):
		active = value
		if not active: set_current_node_state(NodeState.NORMAL)


func _init():
	mouse_entered.connect(_mouse_entered)
	mouse_exited .connect(_mouse_exited)


func _process(delta):
	queue_redraw()


func _draw():
	var alpha: float = 0.2
	if current_node_state == NodeState.HOVER or current_node_state == NodeState.SELECTED: alpha = 0.6
	alpha += 0.2 if active else 0.0
	
	draw_texture_rect(MOLDURE_1, Rect2(0, 0, 80, 80), false, Color.WHITE * alpha)
	
	var symbol_color: Color = COLOR_SERIES[DATA[atomic_number][SERIE]]
	if not active:
		var gray := (symbol_color.r + symbol_color.g + symbol_color.b) / 3.0
		symbol_color = Color(gray, gray, gray)
	
	var string_size = FUTURE_SALLOW.get_string_size(DATA[atomic_number][SIMBOL], HORIZONTAL_ALIGNMENT_CENTER, -1, 60) / 2
	draw_string(
		FUTURE_SALLOW, Vector2(41 - string_size.x, 59), DATA[atomic_number][SIMBOL], HORIZONTAL_ALIGNMENT_CENTER,
		-1, 60, symbol_color
	)
	
	modulate = (Color.WHITE * 0.6) +  (COLOR_SERIES[DATA[atomic_number][SERIE]] * 0.4)
#	material.set_shader_parameter("color", COLOR_SERIES[DATA[atomic_number][SERIE]])


func set_current_node_state(state: NodeState):
	if current_node_state == state: return
	current_node_state = state
	
	match current_node_state:
		NodeState.NORMAL: pass
		NodeState.HOVER: pass
		NodeState.SELECTED:
			Gameplay.selected_element = self


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
