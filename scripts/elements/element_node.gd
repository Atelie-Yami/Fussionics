class_name ElementNode extends Element

signal selected_changed(value: bool)
const FUTURE_SALLOW := preload("res://assets/fonts/Future Sallow.ttf")
const GIANT_ROBOT := preload("res://assets/fonts/GiantRobotArmy-Medium.ttf")
const SLOT := preload("res://assets/img/elements/Slot_0.png")
const LEGANCY := preload("res://scenes/elements/legancy.tscn")
const GLOW := preload("res://scenes/elements/glow.tscn")

const FONT_SIZE := 48.0

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
var glow: Sprite2D = GLOW.instantiate()

var active: bool:
	set(value):
		active = value
		if not active: set_current_node_state(NodeState.NORMAL)
		legancy.set_fade(float(value))


func _init():
	mouse_entered.connect(_mouse_entered)
	mouse_exited .connect(_mouse_exited)
	custom_minimum_size = Vector2(80, 80)
	focus_mode = Control.FOCUS_NONE
	add_child(legancy)
	add_child(glow)
	glow.position = Vector2(40, 40)


func _ready():
	legancy.modulate = COLOR_SERIES[DATA[atomic_number][SERIE]]


func _process(delta):
	queue_redraw()


func _draw():
	# desenhar os ligamentos
	if has_link:
		_draw_ligaments()
	
	# desenhar o retangulo
	var alpha: float = 0.5
	if current_node_state == NodeState.HOVER or current_node_state == NodeState.SELECTED:
		alpha = 0.7
	
	alpha += 0.3 if active else 0.0
	
	draw_texture_rect(SLOT, Rect2(-8, -8, 96, 96), false, Color.WHITE * alpha)
	
	# obter a cor
	var symbol_color: Color = COLOR_SERIES[DATA[atomic_number][SERIE]]
	if not active:
		var gray := (symbol_color.r + symbol_color.g + symbol_color.b) / 3.0
		symbol_color = Color(gray, gray, gray)
	
	# escrever simbolo centralizado
	var string_size = FUTURE_SALLOW.get_string_size(DATA[atomic_number][SIMBOL], HORIZONTAL_ALIGNMENT_CENTER, -1, FONT_SIZE) / 2
	draw_string(
		FUTURE_SALLOW, Vector2(41 - string_size.x, ((string_size.y + 7) / 2) + 40) + position_offset, DATA[atomic_number][SIMBOL], HORIZONTAL_ALIGNMENT_CENTER,
		-1, FONT_SIZE, symbol_color
	)
	
	# atomic number
	draw_string(
		GIANT_ROBOT, Vector2(11, 16), str(atomic_number +1), HORIZONTAL_ALIGNMENT_RIGHT, -1, 12, symbol_color
	)
	
	# eletrons
	var eletrons_string_size = GIANT_ROBOT.get_string_size(str(eletrons +1), HORIZONTAL_ALIGNMENT_LEFT, -1, 12)
	draw_string(
		GIANT_ROBOT, Vector2(68 - eletrons_string_size.x, 16), str(eletrons +1), HORIZONTAL_ALIGNMENT_LEFT, 200, 12, symbol_color
	)
	
	# neutros
	var neutrons_string_size = GIANT_ROBOT.get_string_size(str(neutrons +1), HORIZONTAL_ALIGNMENT_LEFT, -1, 12)
	draw_string(
		GIANT_ROBOT, Vector2(68 - neutrons_string_size.x, 74), str(neutrons +1), HORIZONTAL_ALIGNMENT_LEFT, -1, 12, symbol_color,
		TextServer.JUSTIFICATION_TRIM_EDGE_SPACES, TextServer.DIRECTION_LTR
	)
	
	# dar uma corzinha pra tudo
	modulate = (Color.WHITE * 0.7) +  (COLOR_SERIES[DATA[atomic_number][SERIE]] * 0.3)
	modulate.a = 1.0
	glow.modulate = COLOR_SERIES[DATA[atomic_number][SERIE]] if active else Color(0.1, 0.1, 0.1, 1.0)


func _draw_ligaments():
	
	for link in links:
		var ligament : Molecule.Ligament = links[link]
		if not ligament:
			continue
		
		for i in ligament.level:
			var p = (i * 10.0) - (ligament.level / 2.0 * 10.0) + 5.0
			var base = Vector2(40, 40) - (Vector2(Vector2i.ONE - abs(link)) * p)
			
			draw_line(
					base + Vector2(-link) * (Vector2(30, 30)),
					base + Vector2(-link) * (Vector2(45, 45)),
					Color.WHITE, 5, true
			)


func set_current_node_state(state: NodeState):
	if current_node_state == state: return
	
	match current_node_state:
		NodeState.SELECTED:
			selected_changed.emit(false)
	
	current_node_state = state
	
	match current_node_state:
		NodeState.NORMAL: pass
		NodeState.HOVER: pass
		NodeState.SELECTED:
			Gameplay.selected_element = self
			selected_changed.emit(true)


func _gui_input(event: InputEvent):
	if event.is_action("mouse_click") and event.is_pressed():
		if active:
			match Gameplay.action_state:
				Gameplay.ActionState.NORMAL:
					set_current_node_state(NodeState.SELECTED)
				
				Gameplay.ActionState.LINK:
					if number_electrons_in_valencia > 0 and _is_neighbor_to_link():
						Gameplay.selected_element_target = self
					else:
						Gameplay.action_state = Gameplay.ActionState.NORMAL
						
				Gameplay.ActionState.UNLINK:
					if _is_neighbor_to_link():
						Gameplay.selected_element_target = self
					else:
						Gameplay.action_state = Gameplay.ActionState.NORMAL
					
				Gameplay.ActionState.ATTACK:
					Gameplay.action_state = Gameplay.ActionState.NORMAL
		
		if Gameplay.action_state == Gameplay.ActionState.ATTACK:
			Gameplay.selected_element_target = self


func _get_drag_data(_p):
	if not active or self.has_link: return null
	var e = get_preview_control()
	Gameplay.element_drag_preview.add_child(e)
	e.position = Vector2(-40, -40)
	return self


func get_preview_control()->Control:
	var preview: ElementNode = duplicate()
	preview.modulate.a = 0.66
	preview.scale *= 0.75
	return preview


func _mouse_entered():
	if active:
		set_current_node_state(NodeState.HOVER)
		
		if has_link:
			mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		
		else:
			mouse_default_cursor_shape = Control.CURSOR_MOVE
	
	else:
		if Gameplay.action_state == Gameplay.ActionState.ATTACK:
			mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		
		else:
			mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN


func _mouse_exited():
	if active:
		set_current_node_state(NodeState.NORMAL)


func _is_neighbor_to_link():
	var x:int = abs(Gameplay.selected_element.grid_position.x - grid_position.x)
	var y:int = abs(Gameplay.selected_element.grid_position.y - grid_position.y)
	return (x == 1 and y != 1) or (x != 1 and y == 1)


