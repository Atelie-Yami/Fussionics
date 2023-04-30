class_name ElementRender extends ElementBase

signal selected_changed(value: bool)

const ICON_PASSIVE := preload("res://assets/img/elements/buff_debuff.svg")
const FUTURE_SALLOW := preload("res://assets/fonts/Future Sallow.ttf")
const GIANT_ROBOT := preload("res://assets/fonts/GiantRobotArmy-Medium.ttf")
const SLOT := preload("res://assets/img/elements/Slot_0.png")

const GLOW := preload("res://scenes/elements/glow.tscn")
const LEGANCY := preload("res://scenes/elements/legancy.tscn")

const LIGAMENT_SPACCAMENT := 10.0
const LIGAMENT_SIDE_SPACCAMENT := LIGAMENT_SPACCAMENT / 2.0
const MAX_PASSIVE_ICON := 3
const FONT_SIZE := 48.0
const FONT_ATRIBUTES_SIZE := 13.0

var active: bool:
	set(value):
		active = value
		disabled = !active
		if not active:
			_set_current_node_state(NodeState.NORMAL)

var disabled: bool:
	set(value):
		disabled = value
		legancy.set_fade(float(!value))

var is_dead_flag: bool
var factor_dead := 1.0

var glow: Sprite2D = GLOW.instantiate()
var legancy: Panel = LEGANCY.instantiate()


func _init():
	custom_minimum_size = Vector2(80, 80)
	pivot_offset = Vector2(40, 40)
	focus_mode = Control.FOCUS_NONE
	add_child(legancy)
	add_child(glow)
	glow.position = Vector2(40, 40)
	legancy.modulate = GameBook.COLOR_SERIES[GameBook.ELEMENTS[atomic_number][GameBook.SERIE]]


func _process(delta):
	queue_redraw()
	# dar uma corzinha pra tudo
	modulate = (Color.WHITE * 0.7) +  (GameBook.COLOR_SERIES[GameBook.ELEMENTS[atomic_number][GameBook.SERIE]] * 0.3)
	modulate.a = 1.0
	glow.modulate = GameBook.COLOR_SERIES[GameBook.ELEMENTS[atomic_number][GameBook.SERIE]] if active else Color(0.1, 0.1, 0.1, 1.0)


func _draw_ligaments():
	for link in links:
		var ligament : Molecule.Ligament = links[link]
		if not ligament:
			continue
		
		for i in ligament.level:
			var p = (i * LIGAMENT_SPACCAMENT) - (ligament.level / 2.0 * LIGAMENT_SPACCAMENT) + LIGAMENT_SIDE_SPACCAMENT
			var base = Vector2(40, 40) - (Vector2(Vector2i.ONE - abs(link)) * p)
			
			draw_line(
					base + Vector2(-link) * (Vector2(30, 30)),
					base + Vector2(-link) * (Vector2(45, 45)),
					Color.WHITE, 5, true
			)


func _draw():
	# desenhar os ligamentos
	if has_link:
		_draw_ligaments()
	
	# desenhar o retangulo
	var alpha: float = 0.5
	if current_node_state == NodeState.HOVER or current_node_state == NodeState.SELECTED:
		alpha = 0.7
	
	alpha += 0.3 if active else 0.0
	
	draw_texture_rect(SLOT, Rect2(-8, -8, 96, 96), false, factor_dead if is_dead_flag else Color.WHITE * alpha)
	
	# obter a cor
	var symbol_color: Color = GameBook.COLOR_SERIES[GameBook.ELEMENTS[atomic_number][GameBook.SERIE]]
	if not active:
		var gray := (symbol_color.r + symbol_color.g + symbol_color.b) / 3.0
		symbol_color = Color(gray, gray, gray)
	
	# escrever simbolo centralizado
	var string_size = FUTURE_SALLOW.get_string_size(
			GameBook.ELEMENTS[atomic_number][GameBook.SYMBOL], HORIZONTAL_ALIGNMENT_CENTER, -1, FONT_SIZE
	) / 2
	draw_string(
			FUTURE_SALLOW, Vector2(41 - string_size.x, ((string_size.y + 7) / 2) + 40) + position_offset,
			GameBook.ELEMENTS[atomic_number][GameBook.SYMBOL], HORIZONTAL_ALIGNMENT_CENTER, -1, FONT_SIZE, symbol_color
	)
	# atomic number
	draw_string(
			GIANT_ROBOT, Vector2(11, 16), str(neutrons +1), HORIZONTAL_ALIGNMENT_RIGHT,
			-1, FONT_ATRIBUTES_SIZE, symbol_color
	)
	# eletrons
	var eletrons_string_size = GIANT_ROBOT.get_string_size(
			str(eletrons), HORIZONTAL_ALIGNMENT_LEFT, -1, FONT_ATRIBUTES_SIZE
	)
	draw_string(
			GIANT_ROBOT, Vector2(68 - eletrons_string_size.x, 16), str(eletrons),
			HORIZONTAL_ALIGNMENT_LEFT, 200, FONT_ATRIBUTES_SIZE, symbol_color
	)
	# icone de passivo
	if not debuffs.is_empty():
		for i in min(debuffs.size(), MAX_PASSIVE_ICON):
			draw_texture_rect_region(
					ICON_PASSIVE, Rect2(70, 69 - (i * 9), 14, 10), Rect2(17, 0, 15, 11)
			)
	
	if not buffs.is_empty():
		for i in min(buffs.size(), MAX_PASSIVE_ICON):
			draw_texture_rect_region(
					ICON_PASSIVE, Rect2(-5, 69 - (i * 9), 14, 10), Rect2(0, 0, 15, 11)
			)


func _set_current_node_state(state: NodeState):
	if current_node_state == state: return

	if current_node_state == NodeState.SELECTED:
		selected_changed.emit(false)

	current_node_state = state

	if current_node_state == NodeState.SELECTED:
		Gameplay.selected_element = self
		selected_changed.emit(true)
