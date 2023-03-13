class_name TurnMachine extends Timer

signal pre_init_turn(player: int)
signal init_turn(player: int)
signal main_turn(player: int)
signal end_turn(player: int)

const TURN_TIME = 30.0

enum State {PRE_INIT, INIT, MAIN, END}
enum Players {PLAYER_A, PLAYER_B}

var current_player: Players = randi() % 2
var current_stage: State


func start_turn():
	current_player = current_player + 1 % 2
	pre_init_turn.emit(current_player)


func _timeout():
	end_turn.emit(current_player)


func _arena_end_game(winner):
	stop()
