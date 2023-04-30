class_name ElementBase extends Control

## respostas ao mouse
enum NodeState {
	NORMAL, HOVER, SELECTED
}

var links = {
	Vector2i.UP: null, Vector2i.DOWN: null, Vector2i.LEFT: null, Vector2i.RIGHT: null
}

var has_link: bool:
	get:
		for link in links:
			if links[link]: return true
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


var neutrons: int: ## isotopo, geralmente o mesmo valor q o numero atomico, determina a vida.
	set(value):
		neutrons = value
		if neutrons < 0:
			Gameplay.arena.call_deferred("remove_element", grid_position)

var max_valentia: int
var valentia: int ## Indica quantos links esse elemento pode ter em simultâneo.
@onready var number_electrons_in_valencia: int = valentia

@export var atomic_number: int ## isso é basicamente oque define que tipo de elemento é, seu valor é o custo para instanciar.



