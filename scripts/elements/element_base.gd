class_name ElementBase extends Control

signal selected_changed(value: bool)

## Tempos de ação dos efeitos, quando eles irão ser execultados.
enum ActionTime {
	PRE_INIT, INIT, INSTANTIATED, MOVED, LINKED, UNLINKED, BAKED, DIED, ATTACK, DEFEND, END_TURN
}

enum NodeState {
	NORMAL, HOVER, SELECTED
}

const LEGANCY := preload("res://scenes/elements/legancy.tscn")

var active: bool:
	set(value):
		active = value
		disabled = !active
		if not active:
			_set_current_node_state(NodeState.NORMAL)
var links = {
	Vector2i.UP: null, Vector2i.DOWN: null, Vector2i.LEFT: null, Vector2i.RIGHT: null
}
var disabled: bool:
	set(value):
		disabled = value
		legancy.set_fade(float(!value))
var has_link: bool:
	get:
		for link in links:
			if links[link]: return true
		return false

var player: PlayerController.Players
var grid_position: Vector2i
var legancy: Panel = LEGANCY.instantiate()
var current_node_state: NodeState
var position_offset: Vector2
var selected: bool

var debuffs: Dictionary
var buffs: Dictionary

var max_eletrons: int
## valor de ataque, é variável, ou seja, esse valor pode mudar de acordo com oque acontece durante o jogo.
var eletrons: int

var max_neutrons: int
## isotopo, geralmente o mesmo valor q o numero atomico, determina a vida.
var neutrons: int:
	set(value):
		neutrons = value
		if neutrons < 0:
			Gameplay.arena.call_deferred("remove_element", grid_position)

var max_valentia: int
## Indica quantos links esse elemento pode ter em simultâneo.
var valentia: int
@onready var number_electrons_in_valencia: int = valentia

## isso é basicamente oque define que tipo de elemento é, seu valor é o custo para instanciar.
@export var atomic_number: int


func _set_current_node_state(state: NodeState):
	if current_node_state == state: return

	if current_node_state == NodeState.SELECTED:
		selected_changed.emit(false)

	current_node_state = state

	if current_node_state == NodeState.SELECTED:
		Gameplay.selected_element = self
		selected_changed.emit(true)
