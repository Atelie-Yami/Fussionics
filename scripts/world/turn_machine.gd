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
				start(TURN_TIME)
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
	var slot_fusion: int = 12 if current_player == Players.A else 9
	var slot_accelr: int = 13 if current_player == Players.A else 8
	
	var slot_fusion_2 = slot_fusion + 2
	var slot_accelr_2 = slot_accelr + 2
	
	if arena.elements.has(Vector2i(slot_fusion, 0)) and arena.elements.has(Vector2i(slot_fusion_2, 0)):
		var atn: int = arena.elements[Vector2i(slot_fusion, 0)].element.atomic_number
		atn += arena.elements[Vector2i(slot_fusion_2, 0)].element.atomic_number
		
		if arena.elements.has(Vector2i(slot_fusion + 1, 0)):
			arena.remove_element(Vector2i(slot_fusion + 1, 0))
		
		arena.create_element(atn, current_player as PlayerController.Players, Vector2i(slot_fusion + 1, 0))
		arena.remove_element(Vector2i(slot_fusion  , 0))
		arena.remove_element(Vector2i(slot_fusion_2, 0))
		
		start(COOK_FUSION_TIME)
		# animação de fundir aqui
		await timeout
		
		if atn > 25:
			Gameplay.player_controller.take_damage(current_player as PlayerController.Players, atn - 25)
		
		await ElementEffectManager.call_effects(current_player as PlayerController.Players, ElementEffectManager.SkillType.COOKED_FUSION)
	
	if arena.elements.has(Vector2i(slot_accelr, 5)) and arena.elements.has(Vector2i(slot_accelr_2, 5)):
		var atn1: int = arena.elements[Vector2i(slot_accelr   , 5)].element.atomic_number
		var atn2: int = arena.elements[Vector2i(slot_accelr_2, 5)].element.atomic_number
		var atn_result: int
		
		if atn1 == atn2: # se for 2 elementos iguais, a change de dar um resultado melhor é maior
			var atn_result1 = randi_range(atn1, atn1 + atn2)
			var atn_result2 = randi_range(atn1, atn1 + atn2)
			atn_result = max(atn_result1, atn_result2)
			
		else: 
			atn_result = randi_range(atn1, atn1 + atn2)
		
		atn_result = min(atn_result, 118)
		
		if arena.elements.has(Vector2i(slot_accelr +1, 5)):
			arena.remove_element(Vector2i(slot_accelr +1, 5))
		
		arena.create_element(atn_result, current_player as PlayerController.Players, Vector2i(slot_accelr +1, 5))
		arena.remove_element(Vector2i(slot_accelr, 5))
		arena.remove_element(Vector2i(slot_accelr_2, 5))
		
		start(COOK_FUSION_TIME)
		# animação de fundir aqui
		await timeout
		await ElementEffectManager.call_effects(current_player as PlayerController.Players, ElementEffectManager.SkillType.COOKED_ACCELR)


func _main_phase_timeout():
	next_phase()


func _arena_end_game(winner):
	stop()


func _end_game(player):
	stop()
	get_tree().quit()
