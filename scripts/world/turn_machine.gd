class_name TurnMachine extends Timer

signal start_game
signal end_game(player)
signal pre_init_turn(player: int)
signal init_turn(player: int)
signal main_turn(player: int)
signal end_turn(player: int)

const TURN_TIME = 5.0
const COOK_FUSION_TIME = 0.15
const COOK_ACCELR_TIME = 0.15

enum State {PRE_INIT, INIT, MAIN, END}
enum Players {A, B}

var current_player: Players = randi() % Players.size() as Players

var current_stage: State:
	set(value):
		current_stage = value
		
		match current_stage:
			State.PRE_INIT:
				await ElementEffectManager.call_effects(
						current_player as PlayerController.Players,
						ElementEffectManager.SkillType.PRE_INIT_PHASE
				)
				await get_tree().create_timer(0.2).timeout # teste
				pre_init_turn.emit(current_player)
				next_phase()
			
			State.INIT:
				await ElementEffectManager.call_effects(
						current_player as PlayerController.Players,
						ElementEffectManager.SkillType.INIT_PHASE
				)
				await cook()
				await get_tree().create_timer(0.2).timeout # teste
				init_turn.emit(current_player)
				next_phase()
			
			State.MAIN:
				await ElementEffectManager.call_effects(
						current_player as PlayerController.Players,
						ElementEffectManager.SkillType.MAIN_PHASE
				)
				start(1 if current_player == 1 else 20)
				if not timeout.is_connected(_main_phase_timeout):
					timeout.connect(_main_phase_timeout, CONNECT_ONE_SHOT)
				main_turn.emit(current_player)
			
			State.END:
				await ElementEffectManager.call_effects(
						current_player as PlayerController.Players,
						ElementEffectManager.SkillType.END_PHASE
				)
				await get_tree().create_timer(0.2).timeout # teste
				end_turn.emit(current_player)
				next_phase()


@onready var arena: Arena = $"../arena"


func _ready():
	await get_tree().create_timer(1).timeout
	start_turn()


func start_turn():
	start_game.emit()
	self.current_stage = State.PRE_INIT


func next_phase():
	if not is_stopped():
		if timeout.is_connected(_main_phase_timeout):
			timeout.disconnect(_main_phase_timeout)
		stop()
	
	if current_stage == State.END:
		current_player = (current_player + 1) % Players.size() as Players
	
	self.current_stage = (current_stage + 1) % State.size() as State


## os slots
## 8 e 10:  acler B
## 9 e 11:  fusao B
## 12 e 14: fusao A
## 13 e 15: acler A

func cook():
	var slot: int = 12 if current_player == Players.A else 9
	
	var slot_fusion_A = Vector2i(slot, 0)
	var slot_fusion_B = Vector2i(slot + 2, 0)
	
	var slot_accelr_A = Vector2i(slot, 4)
	var slot_accelr_B = Vector2i(slot + 2, 4)
	
	if arena.elements.has(slot_fusion_A) and arena.elements.has(slot_fusion_B):
		var atn: int = (
				arena.elements[slot_fusion_A].element.atomic_number +
				arena.elements[slot_fusion_B].element.atomic_number + 1
		)
		if arena.elements.has(Vector2i(slot + 1, 0)):
			arena.remove_element(Vector2i(slot + 1, 0))
		
		await ElementEffectManager.call_effects(current_player as PlayerController.Players, ElementEffectManager.SkillType.COOKED_FUSION)
		
		arena.create_element(min(atn, 118), current_player as PlayerController.Players, Vector2i(slot + 1, 0), false)
		arena.remove_element(slot_fusion_A)
		arena.remove_element(slot_fusion_B)
		
		start(COOK_FUSION_TIME)
		# animação de fundir aqui
		await timeout
		
		if atn > 25:
			Gameplay.player_controller.take_damage(current_player as PlayerController.Players, atn - 25)
		
	
	if arena.elements.has(slot_accelr_A) and arena.elements.has(slot_accelr_B):
		var atn1: int = arena.elements[slot_accelr_A].element.atomic_number
		var atn2: int = arena.elements[slot_accelr_B].element.atomic_number
		var atn_result: int
		
		if not atn1 and not atn2:
			atn1 = 1
		
		if atn1 == atn2: # Há mais changes de ter um bom resultado se for 2 elementos iguais
			atn_result = max(
					randi_range(atn1, atn1 + atn2),
					randi_range(atn1, atn1 + atn2),
					randi_range(atn1, atn1 + atn2)
			)
		else:
			atn_result = max(
					randi_range(atn1, atn1 + atn2),
					randi_range(atn1, atn1 + atn2)
			)
		
		if arena.elements.has(Vector2i(slot +1, 5)):
			arena.remove_element(Vector2i(slot +1, 5))
		
		await ElementEffectManager.call_effects(current_player as PlayerController.Players, ElementEffectManager.SkillType.COOKED_ACCELR)
		
		arena.create_element(min(atn_result, 118), current_player as PlayerController.Players, Vector2i(slot +1, 5), false)
		arena.remove_element(slot_accelr_A)
		arena.remove_element(slot_accelr_B)
		
		start(COOK_FUSION_TIME)
		# animação de fundir aqui
		await timeout


func _main_phase_timeout():
	next_phase()


func _arena_end_game(winner):
	stop()


func _end_game(player):
	stop()
	get_tree().quit()
