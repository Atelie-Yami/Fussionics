class_name PlayerController extends Node

enum Players {A, B}

const PLAYERS_MAX_LIFE := 30
const ENERGY_MAX := 16

#------------------------------------------------------------------------------#
## Classe que detem as propriedades dos jogadores
class Player:
	var energy_max := 1
	var energy := 1
	
	var player: Players
	var end_game: Signal
	var elements: Array[ElementNode]
	
	var life: int = PLAYERS_MAX_LIFE:
		set(value):
			life = max(value, 0)
			if life == 0:
				end_game.emit(player)
	
	func _init(_player: Players, _end_game: Signal):
		player = _player; end_game = _end_game
	
	func set_my_turn(active: bool):
		elements.map(func(e): e.active = active)
	
#------------------------------------------------------------------------------#

var current_players: Array[Player]

@onready var arena = $"../arena"
@onready var turn_machine: TurnMachine = %turn_machine


func _init():
	Gameplay.player_controller = self


func _ready():
	for p in Players.size():
		current_players.append(Player.new(p, turn_machine.end_game))
	
	turn_machine.pre_init_turn.connect(_pre_init_turn)
	turn_machine.main_turn.connect(_set_current_player_controller)
	turn_machine.end_turn.connect(_remove_players_control)


func take_damage(player: Players, danage: int):
	current_players[player].life -= danage


func spend_energy(player: Players, energy: int):
	current_players[player].energy -= energy


func _pre_init_turn(player: Players):
	pass


func _set_current_player_controller(player: Players):
	current_players[player].set_my_turn(true)
	current_players[player].energy_max = min(current_players[player].energy_max + 1, ENERGY_MAX)
	current_players[player].energy = current_players[player].energy_max
	
	if player == Players.A:
		pass


func _remove_players_control(player: Players):
	current_players[player].set_my_turn(false)
	
	ElementEffectManager.call_effects(player, ElementEffectManager.SkillType.END_PHASE)
	
	if player == Players.A:
		pass



