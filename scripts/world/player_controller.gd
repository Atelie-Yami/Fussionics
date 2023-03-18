class_name PlayerController extends Node

enum Players {A, B}

const PLAYERS_MAX_LIFE := 30


#------------------------------------------------------------------------------#
## Classe que detem as propriedades dos jogadores
class Player:
	var energy: int
	
	var player: Players
	var end_game: Signal
	var elements: Array[ElementNode]
	
	var life: int = PLAYERS_MAX_LIFE:
		set(value):
			life = max(value, 0)
			if life == 0: end_game.emit(player)
	
	func _init(_player: Players, _end_game: Signal):
		player = _player; end_game = _end_game
	
	func set_my_turn(active: bool):
		elements.map(func(e): e.active = active)
	
#------------------------------------------------------------------------------#

var current_players: Array[Player]

@onready var arena = $"../arena"
@onready var turn_machine: TurnMachine = %turn_machine


func _ready():
	current_players.append(Player.new(Players.A, arena.end_game))
	current_players.append(Player.new(Players.B, arena.end_game))
	
	turn_machine.main_turn.connect(set_current_player_controller)
	turn_machine.end_turn.connect(remove_players_control)


func set_current_player_controller(player: Players):
	current_players[player].set_my_turn(true)
	
	if player == Players.A:
		pass


func remove_players_control(player: Players):
	current_players[player].set_my_turn(false)
	
	if player == Players.A:
		pass


func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		current_players[0].set_my_turn(true)
		
		arena.create_element(randi_range(0, 118), 0, Vector2i(randi_range(0, 7), randi_range(0, 4)))
		arena.create_element(randi_range(0, 118), 1, Vector2i(randi_range(0, 7), randi_range(0, 4)))
	
	if Input.is_action_just_pressed("ui_cancel"):
		current_players[0].set_my_turn(false)
		Gameplay.selected_element = null
