class_name TurnMachine extends Timer

signal end_game(win)
signal pre_init_turn(player: int)
signal init_turn(player: int)
signal main_turn(player: int)
signal end_turn(player: int)

const TURN_TIME = 30.9
const PHASE_IDLE_TIME := 0.2
const COOK_FUSION_TIME = 0.15
const COOK_ACCELR_TIME = 0.15

enum State {PRE_INIT, INIT, MAIN, END}
enum Players {A, B}

var turn_count: int = 0
var current_player: Players = randi() % Players.size() as Players
var current_stage: State:
	set(value):
		current_stage = value
		_machine()


@onready var arena: Arena = $"../arena"


func start_turn():
	self.current_stage = State.PRE_INIT


func next_phase():
	if not is_stopped():
		if timeout.is_connected(_main_phase_timeout):
			timeout.disconnect(_main_phase_timeout)
		stop()
	if current_stage == State.END:
		current_player = (current_player + 1) % Players.size() as Players
	
	if current_stage == State.END:
		turn_count += 1
	
	self.current_stage = (current_stage + 1) % State.size() as State


func _main_phase_timeout():
	next_phase()


func _machine():
	match current_stage:
		State.PRE_INIT:
			await BaseEffect.call_effects(
					current_player as PlayerController.Players,
					BaseEffect.SkillType.PRE_INIT_PHASE
			)
			start(PHASE_IDLE_TIME)
			await timeout
			pre_init_turn.emit(current_player)
			next_phase()
		
		State.INIT:
			await BaseEffect.call_effects(
					current_player as PlayerController.Players,
					BaseEffect.SkillType.INIT_PHASE
			)
			await _cook()
			start(PHASE_IDLE_TIME)
			await timeout
			init_turn.emit(current_player)
			next_phase()
		
		State.MAIN:
			await BaseEffect.call_effects(
					current_player as PlayerController.Players,
					BaseEffect.SkillType.MAIN_PHASE
			)
			await PassiveEffect.call_passive_effects(current_player as PlayerController.Players)
			
			start(TURN_TIME)
			if not timeout.is_connected(_main_phase_timeout):
				timeout.connect(_main_phase_timeout, CONNECT_ONE_SHOT)
			
			main_turn.emit(current_player)
		
		State.END:
			await BaseEffect.call_effects(
					current_player as PlayerController.Players,
					BaseEffect.SkillType.END_PHASE
			)
			start(PHASE_IDLE_TIME)
			await timeout
			end_turn.emit(current_player)
			next_phase()


func _cook():
	## os slots
	# ------------------------- #
	##   slot   |    x    |  y  |
	##  fusao A | 12 e 14 |  0  |
	##  fusao B |  9 e 11 |  0  |
	## accelr A | 12 e 14 |  4  |
	## accelr B |  9 e 11 |  4  |
	# ------------------------- #
	var slot: int = 12 if current_player == Players.A else 9
	
	var slot_fusion_A = Vector2i(slot, 0)
	var slot_fusion_B = Vector2i(slot + 2, 0)
	
	var slot_accelr_A = Vector2i(slot, 4)
	var slot_accelr_B = Vector2i(slot + 2, 4)
	
	if Arena.elements.has(slot_fusion_A) and Arena.elements.has(slot_fusion_B):
		await arena.fusion_elements(slot_fusion_A, slot_fusion_B, slot, current_player as PlayerController.Players)
	
	if Arena.elements.has(slot_accelr_A) and Arena.elements.has(slot_accelr_B):
		await arena.accelr_elements(slot_accelr_A, slot_accelr_B, slot, current_player as PlayerController.Players)


func _arena_end_game(winner):
	stop()


func game_end(win: bool):
	end_game.emit(win)
	stop()
