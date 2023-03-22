class_name TurnMachine extends Timer

signal pre_init_turn(player: int)
signal init_turn(player: int)
signal main_turn(player: int)
signal end_turn(player: int)

const TURN_TIME = 30.0

enum State {PRE_INIT, INIT, MAIN, END}
enum Players {A, B}

var current_player: Players = randi() % Players.size() as Players
var current_stage: State

var _signals: Array[Signal] = [pre_init_turn, init_turn, main_turn, end_turn]


func next_phase():
	current_stage = current_stage + 1 % State.size() as State
	_signals[current_stage].emit(current_player)


func start_turn():
	current_player = current_player + 1 % Players.size() as Players
	current_stage = State.PRE_INIT
	pre_init_turn.emit(current_player)


func _timeout():
	end_turn.emit(current_player)


func _arena_end_game(winner):
	stop()
