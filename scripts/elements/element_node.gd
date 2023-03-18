class_name ElementNode extends Element

const FUTURE_SALLOW := preload("res://assets/fonts/Future Sallow.ttf")
const MOLDURE_1 := preload("res://assets/img/elements/element_moldure.png")
const LEGANCY := preload("res://scenes/elements/legancy.tscn")

enum State {
	NORMAL, BIND_LINK, REMOVE_LINK, ATTACKING, DEFENDING, MOTION, COOKING
}
enum NodeState {
	NORMAL, HOVER, SELECTED
}

var current_state: State
var current_node_state: NodeState

var position_offset: Vector2
var selected: bool

var legancy: Panel = LEGANCY.instantiate()

var active: bool:
	set(value):
		active = value
		if not active: set_current_node_state(NodeState.NORMAL)
		legancy.set_fade(float(value))


func _init():
	mouse_entered.connect(_mouse_entered)
	mouse_exited .connect(_mouse_exited)
	custom_minimum_size = Vector2(80, 80)
	add_child(legancy)


func _process(delta):
	queue_redraw()


func _draw():
	# desenhar o retangulo
	var alpha: float = 0.2
	if current_node_state == NodeState.HOVER or selected: alpha = 0.6
	alpha += 0.2 if active else 0.0
	
	draw_texture_rect(MOLDURE_1, Rect2(position_offset.x, position_offset.y, 80, 80), false, Color.WHITE * alpha)
	
	# obter a cor
	var symbol_color: Color = COLOR_SERIES[DATA[atomic_number][SERIE]]
	if not active:
		var gray := (symbol_color.r + symbol_color.g + symbol_color.b) / 3.0
		symbol_color = Color(gray, gray, gray)
	
	# escrever simbolo centralizado
	var string_size = FUTURE_SALLOW.get_string_size(DATA[atomic_number][SIMBOL], HORIZONTAL_ALIGNMENT_CENTER, -1, 60) / 2
	draw_string(
		FUTURE_SALLOW, Vector2(41 - string_size.x, 59) + position_offset, DATA[atomic_number][SIMBOL], HORIZONTAL_ALIGNMENT_CENTER,
		-1, 60, symbol_color
	)
	
	# dar uma corzinha pra tudo
	modulate = (Color.WHITE * 0.6) +  (COLOR_SERIES[DATA[atomic_number][SERIE]] * 0.4)


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


func _get_drag_data(_p):
	if not active or self.has_link: return null
	
	set_drag_preview(_get_preview_control())
	return self


func _get_preview_control()->Control:
	var preview: ElementNode = duplicate()
	preview.scale *= 0.75
	preview.modulate.a = 0.66
	preview.position_offset = Vector2(-40, -60)
	return preview


func _mouse_entered():
	if active:
		set_current_node_state(NodeState.HOVER)
		
		if has_link:
			mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		
		else:
			mouse_default_cursor_shape = Control.CURSOR_MOVE
	
	else:
		mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN


func _mouse_exited():
	if active:
		set_current_node_state(NodeState.NORMAL)
