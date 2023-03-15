class_name PlayerController extends Node

enum Players {A, B}

const PLAYERS_MAX_LIFE := 30

#------------------------------------------------------------------------------#
## Classe que detem as propriedades dos jogadores
class Player:
	var player: Players
	var end_game: Signal
	
	var life: int = PLAYERS_MAX_LIFE:
		set(value):
			life = max(value, 0)
			if life == 0: end_game.emit(player)
	
	func _init(_player: Players, _end_game: Signal):
		player = _player; end_game = _end_game
	
	## função pra permitir e negar ações (tanto bot quanto player local)
	
#------------------------------------------------------------------------------#

@onready var arena: Arena = $".."
@onready var turn_machine: TurnMachine = %turn_machine

var current_players: Dictionary


func _ready():
	current_players = {
		Players.A: Player.new(Players.A, arena.end_game),
		Players.B: Player.new(Players.B, arena.end_game),
	}
	
	turn_machine.main_turn.connect(set_current_player_controller)
	turn_machine.end_turn.connect(remove_players_control)


func set_current_player_controller(player: Players):
	match player:
		Players.A: pass
		Players.B: pass


func remove_players_control(player: Players):
	pass



