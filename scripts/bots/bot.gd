class_name Bot extends Timer
## classe que detem os links e referencias do jogo, classe generica

enum ModusOperandi {
	AGGRESSIVE, DEFENSIVE, UNDECIDED, STRATEGICAL_AGGRESSIVE, STRATEGICAL_DEFENSIVE,
}
const MAX_SEARCH_TEST := 40
const NON_PLAYER := -1 # sem player definido
const NEIGHBOR_SLOTS := [Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, -1), Vector2i(0, 1)]

var chip: BotChip
var deck := GameBook.DECK.duplicate(true)
var modus_operandi: ModusOperandi = ModusOperandi.UNDECIDED

var analysis: FieldAnalysis
var desicions: Array[Decision]

@onready var player: Player = $".."


func _ready():
	chip = GameConfig.game_match.bot_chip.new()
	deck = GameConfig.game_match.bot_deck
	player.play.connect(_play)


func _play():
	start(0.5)
	await timeout
	
	analysis = FieldAnalysis.make(self)
	modus_operandi = chip.get_modus(analysis)
	desicions = chip.call_modus_action(modus_operandi, self, analysis)
	await chip.execute(desicions, self)
	
	var pos_analysis := FieldAnalysis.make(self)
	desicions = chip.call_modus_action(ModusOperandi.UNDECIDED, self, pos_analysis)
	await chip.execute(desicions, self)
	
	await chip.lockdown(self, pos_analysis, modus_operandi)
	end_turn()


func end_turn():
	player.arena.turn_machine.next_phase()


func get_empty_slot():
	var _flat_test := 0
	while _flat_test < MAX_SEARCH_TEST:
		_flat_test += 1
		
		var position_test := Vector2i(randi_range(0, 7), randi_range(0, 4))
		if not Arena.elements.has(position_test):
			return position_test


func get_reactor_empty() -> int:
	if (
			Gameplay.arena._check_slot_empty(GameJudge.REACTOR_POSITIONS[0]) and
			Gameplay.arena._check_slot_empty(GameJudge.REACTOR_POSITIONS[1])
	):
		return 0 # fusão
	elif (
			Gameplay.arena._check_slot_empty(GameJudge.REACTOR_POSITIONS[2]) and
			Gameplay.arena._check_slot_empty(GameJudge.REACTOR_POSITIONS[3])
	): 
		return 1 # aceleração
	return -1 # nenhum


func get_slots_nearly(slots_count: int) -> Array:
	var positions: Array
	var count := Bot.MAX_SEARCH_TEST
	while count > 0:
		count -= 1
	
		var position1 = get_empty_slot()
		if position1 == null:
			continue
		
		positions = get_neighbor_empty_slot(position1)
		if positions.size() > (slots_count - 2):
			positions.push_front(position1)
			break
	
	return positions


func get_neighbor_empty_slot(pos: Vector2i):
	var targets := []
	for _offset in NEIGHBOR_SLOTS:
		var target: Vector2i = pos + _offset
		
		if (
				not Arena.elements.has(target) and
				target.x >= 0 and target.x < 8 and target.y >= 0 and target.y < 5
		):
			targets.append(target)
	
	return targets


func get_neighbor_allied_elements(pos: Vector2i):
	return get_neighbor_elements(pos, 1)


func get_neighbor_rival_elements(pos: Vector2i):
	return get_neighbor_elements(pos, 0)


func get_neighbor_elements(pos: Vector2i, player: int):
	var targets := []
	for _offset in NEIGHBOR_SLOTS:
		var target: Vector2i = pos + _offset
		
		if Arena.elements.has(target):
			if player == NON_PLAYER or Arena.elements[target].player == player:
				targets.append(target)
	
	return targets


func create_element(atomic_number: int, position: Vector2i):
	var element = Gameplay.arena.create_element(atomic_number, PlayerController.Players.B, position, false)
	PlayerController.current_players[PlayerController.Players.B].spend_energy(atomic_number + 1)
	Gameplay.vfx.emit_element_instanciated(
			element.global_position + Vector2(40, 40), element.legancy.modulate
	)
	
	start(0.2)
	await timeout
	return element


func move_element_to_slot(element: Element, slot_position: Vector2i):
	var final_position: Vector2 = Gameplay.arena._get_snapped_slot_position(slot_position)
	
	if not GameJudge.can_element_move(element.grid_position, final_position):
		return
	
	var tween := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(element, "global_position", final_position, 0.4)
	await tween.finished
	
	await Gameplay.arena.move_element(element.grid_position, slot_position)


func move_element_to_ramdom_slot(element: Element):
	var pos = get_empty_slot()
	if pos == null:
		pos = get_empty_slot()
		if pos == null:
			return
	
	await move_element_to_slot(element, pos)


func attack(element_atk: Element, element_def: Element, defend_mode: bool) -> bool:
	if GameJudge.combat_check_result(element_atk, element_def, defend_mode) == GameJudge.Result.WINNER:
		await Gameplay.arena.attack_element(element_atk.grid_position, element_def.grid_position)
		return true
	return false


func set_defende_mode(element: Element):
	if not Arena.elements[element.grid_position].eletrons_charged:
		await Gameplay.arena.defend_mode(element.grid_position)
