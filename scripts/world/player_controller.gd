class_name PlayerController extends Node

enum Players {A, B}


@export var player_A: NodePath
@export var player_B: NodePath

@onready var turn_machine: TurnMachine = %turn_machine

static var current_players: Array[Player]


func _ready():
	current_players.append(get_node(player_A))
	current_players.append(get_node(player_B))
	
	turn_machine.pre_init_turn.connect(_pre_init_turn)
	turn_machine.main_turn.connect(_set_current_player_controller)
	turn_machine.end_turn.connect(_remove_players_control)
	
	await  get_tree().create_timer(0.1).timeout


func _gui_input(event):
	if event.is_action_pressed("mouse_click"):
		Gameplay.action_state = Gameplay.ActionState.NORMAL
		Gameplay.passive_status.set_element(null)


func _pre_init_turn(player: Players):
	pass


func _set_current_player_controller(player: Players):
	current_players[player].set_turn(true)
	
	if turn_machine.turn_count == 0 and player == Players.A:
		pass
	
	else:
		current_players[player].energy_max += 1
	
	current_players[player].energy = current_players[player].energy_max
	current_players[player].play.emit()


func _remove_players_control(player: Players):
	current_players[player].set_turn(false)
	
	await ElementEffectManager.call_effects(player, BaseEffect.SkillType.END_PHASE)
	
	if player == Players.A:
		pass






