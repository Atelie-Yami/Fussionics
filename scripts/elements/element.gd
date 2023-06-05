## Classe que define os elementos.
class_name Element extends Control

signal selected_changed(value: bool)

enum NodeState {
	NORMAL, HOVER, SELECTED
}
const ICON_PASSIVE := preload("res://assets/img/elements/buff_debuff.svg")
const FUTURE_SALLOW := preload("res://assets/fonts/Future Sallow.ttf")
const GIANT_ROBOT := preload("res://assets/fonts/GiantRobotArmy-Medium.ttf")
const SLOT := preload("res://assets/img/elements/Slot_0.png")
const SLOT_WHITE := preload("res://assets/img/elements/element_frame_white.png")

const GLOW := preload("res://scenes/elements/glow.tscn")
const LEGANCY := preload("res://scenes/elements/legancy.tscn")
const NUMBER_RENDER := preload("res://scripts/sundry/element_number_render.gd")

const LIGAMENT_SPACCAMENT := 10.0
const LIGAMENT_SIDE_SPACCAMENT := LIGAMENT_SPACCAMENT / 2.0
const MAX_PASSIVE_ICON := 3
const FONT_SIZE := 48.0
const FONT_ATRIBUTES_SIZE := 13.0

var valentia: int ## Indica quantos links esse elemento pode ter em simultâneo.
@onready var number_electrons_in_valencia: int = valentia

@export var atomic_number: int ## isso é basicamente oque define que tipo de elemento é, seu valor é o custo para instanciar.

var neutrons: int: ## isotopo, geralmente o mesmo valor q o numero atomico, determina a vida.
	set(value):
		neutrons = value
		if neutrons < 0:
			Gameplay.arena.call_deferred("remove_element", grid_position)

var active: bool:
	set(value):
		active = value
		disabled = !active
		if not active:
			_set_current_node_state(NodeState.NORMAL)

var in_reactor: bool
var disabled: bool:
	set(value):
		disabled = value
		legancy.set_fade(float(!value))

var links = {
	Vector2i.UP: null, Vector2i.DOWN: null, Vector2i.LEFT: null, Vector2i.RIGHT: null
}
var has_link: bool:
	get:
		for link in links:
			if links[link]:
				return true
		return false

var player: PlayerController.Players
var grid_position: Vector2i

var current_node_state: NodeState
var position_offset: Vector2
var selected: bool

var debuffs: Dictionary
var buffs: Dictionary

var max_eletrons: int
var eletrons: int ## valor de ataque, é variável, ou seja, esse valor pode mudar de acordo com oque acontece durante o jogo.
var max_neutrons: int

var is_dead_flag: bool
var factor_dead: float

var sob: Control = NUMBER_RENDER.new()
var glow: Sprite2D = GLOW.instantiate()
var legancy: Panel = LEGANCY.instantiate()
var effect #: BaseEffect


func _init():
	custom_minimum_size = Vector2(80, 80)
	pivot_offset = Vector2(40, 40)
	focus_mode = Control.FOCUS_NONE
	add_child(legancy)
	add_child(glow)
	add_child(sob)
	glow.position = Vector2(40, 40)


func _ready():
	legancy.modulate = GameBook.COLOR_SERIES[GameBook.ELEMENTS[atomic_number][GameBook.SERIE]]
	mouse_entered.connect(_mouse_entered)
	mouse_exited .connect(_mouse_exited )


func _process(delta):
	sob.atomic_number = atomic_number
	sob.eletrons = eletrons
	sob.neutrons = neutrons
	sob.queue_redraw()
	queue_redraw()
	# dar uma corzinha pra tudo
	self_modulate = (Color.WHITE * 0.7) +  (GameBook.COLOR_SERIES[GameBook.ELEMENTS[atomic_number][GameBook.SERIE]] * 0.3)
	self_modulate.a = 1.0
	glow.modulate = GameBook.COLOR_SERIES[GameBook.ELEMENTS[atomic_number][GameBook.SERIE]] if active else Color(0.1, 0.1, 0.1, 1.0)
	
	if is_dead_flag:
		position.x += cos(factor_dead * 14.0) * 2.0
		position.y += cos(factor_dead * 17.0)
		legancy.visible = false


func _input(event: InputEvent):
	if event.is_action_pressed("test"):
		var arr: Array[Element] = [self]
		await Gameplay.vfx.handler(arr, [Vector2.ZERO] as Array[Vector2], 0, 0)


func _exit_tree():
	if Gameplay.selected_element == self:
		Gameplay.selected_element = null
	
	if effect:
		effect.unregister()


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
	
	draw_texture_rect(SLOT, Rect2(-8, -8, 96, 96), false, Color.WHITE * alpha)
	
	if is_dead_flag:
		draw_texture_rect(SLOT_WHITE, Rect2(-8, -8, 96, 96), false, Color.WHITE * factor_dead)
		return
	
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


func can_link(ref: Element):
	if number_electrons_in_valencia == 0:
		return false
	
	if not has_link:
		return true
	
	for link in links:
		if links[link] and links[link].level < 3 and (links[link].element_A == ref or links[link].element_B == ref):
			return true
	
	for link in links:
		if not links[link]:
			return true
	
	return false


func build(_atomic_number: int):
	atomic_number = min(_atomic_number, GameBook.ELEMENTS.size())
	eletrons = atomic_number + 1
	neutrons = atomic_number
	valentia = GameBook.ELEMENTS[atomic_number][GameBook.VALENCY]
	tooltip_text = GameBook.ELEMENTS[atomic_number][GameBook.NAME]


func reset():
	disabled = false
	if debuffs.is_empty() and neutrons > 0:
		neutrons = atomic_number
		
	eletrons = atomic_number +1


func _set_current_node_state(state: NodeState):
	if current_node_state == state: return

	if current_node_state == NodeState.SELECTED:
		selected_changed.emit(false)

	current_node_state = state

	if current_node_state == NodeState.SELECTED:
		Gameplay.selected_element = self
		selected_changed.emit(true)


func _mouse_entered():
	if active:
		_set_current_node_state(NodeState.HOVER)
	
	mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN


func _mouse_exited():
	if active:
		_set_current_node_state(NodeState.NORMAL)


func _is_neighbor_to_link():
	var x: int = abs(Gameplay.selected_element.grid_position.x - grid_position.x)
	var y: int = abs(Gameplay.selected_element.grid_position.y - grid_position.y)
	return (x == 1 and y != 1) or (x != 1 and y == 1)
