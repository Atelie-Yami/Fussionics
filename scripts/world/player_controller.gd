class_name PlayerController extends Control

enum Players {A, B}

@onready var current_players: Array[Player] = [
	$"../Player_A" as Player,
	$"../Player_B" as Player,
]
@onready var turn_machine: TurnMachine = %turn_machine


func _ready():
	turn_machine.pre_init_turn.connect(_pre_init_turn)
	turn_machine.main_turn.connect(_set_current_player_controller)
	turn_machine.end_turn.connect(_remove_players_control)
	
	await  get_tree().create_timer(0.1).timeout
	
	for c in get_children():
		await  get_tree().create_timer(0.03).timeout
		c.animation()


func _pre_init_turn(player: Players):
	pass


func _set_current_player_controller(player: Players):
	current_players[player].set_turn(true)
	current_players[player].energy_max = min(current_players[player].energy_max + 1, Player.ENERGY_MAX)
	current_players[player].energy = current_players[player].energy_max
	
	ElementEffectManager.call_passive_effects(player)
	
	if player == Players.B:
		current_players[player].play()


func _remove_players_control(player: Players):
	current_players[player].set_turn(false)
	
	ElementEffectManager.call_effects(player, ElementEffectManager.SkillType.END_PHASE)
	
	if player == Players.A:
		pass



