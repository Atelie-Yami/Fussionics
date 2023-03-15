class_name PlayerController extends Node

enum Players {A, B}

const PLAYERS_MAX_LIFE := 30

#------------------------------------------------------------------------------#
## Classe que detem as propriedades dos jogadores
class Player:
	var player: Players
	var end_game: Signal
	var inputs: PlayerInputs
	
	var life: int = PLAYERS_MAX_LIFE:
		set(value):
			life = max(value, 0)
			if life == 0: end_game.emit(player)
	
	var energy: int
	
	func _init(_player: Players, _end_game: Signal, _inputs: PlayerInputs):
		player = _player; end_game = _end_game; inputs = _inputs
	
	## função pra permitir e negar ações (tanto bot quanto player local)
	
#------------------------------------------------------------------------------#

@onready var arena: Arena = $".."
@onready var turn_machine: TurnMachine = %turn_machine
@onready var player_a_inputs = $player_A_controller
@onready var player_b_inputs = $player_B_controller

var current_players: Array[Player]


func _ready():
	current_players.append(Player.new(Players.A, arena.end_game, player_a_inputs))
	current_players.append(Player.new(Players.B, arena.end_game, player_b_inputs))
	
	turn_machine.main_turn.connect(set_current_player_controller)
	turn_machine.end_turn.connect(remove_players_control)


func set_current_player_controller(player: Players):
	current_players[player].inputs.set_my_turn(true)
	
	if player == Players.A:
		pass


func remove_players_control(player: Players):
	current_players[player].inputs.set_my_turn(false)
	
	if player == Players.A:
		pass


