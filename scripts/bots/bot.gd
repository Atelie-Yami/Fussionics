class_name Bot extends Timer
## classe que detem os links e referencias do jogo, classe generica

enum ModusOperandi {
	AGGRESSIVE, DEFENSIVE, UNDECIDED,
	STRATEGICAL_AGGRESSIVE, STRATEGICAL_DEFENSIVE,
}
const MAX_SEARCH_TEST := 40

var chip: BotChip
var deck := GameBook.DECK.duplicate(true)
var modus_operandi: ModusOperandi = ModusOperandi.UNDECIDED

@onready var player: Player = $".."


func _ready():
	chip = GameConfig.game_match.bot_chip.new()
	deck = GameConfig.game_match.bot_deck
	player.play.connect(_play)


func _play():
	var analysis: BotChip.FieldAnalysis = await chip.analysis(self)
	modus_operandi = chip.get_modus(analysis) ## da pra analizar o modus_operandi antes de atualizar
	
	var desicions: Array[BotChip.Decision] = chip.call_modus_action(modus_operandi, self, analysis)
	await chip.execute(self, desicions)
	
	var pos_analysis: BotChip.FieldAnalysis = await chip.analysis(self)
	await chip.lockdown(self, pos_analysis, modus_operandi)
	end_turn()


func end_turn():
	player.arena.turn_machine.next_phase()


func get_empty_slot():
	var _flat_test := 0
	while _flat_test < MAX_SEARCH_TEST:
		_flat_test += 1
		
		var position_test := Vector2i(randi_range(0, 7), randi_range(0, 4))
		if not Gameplay.arena.elements.has(position_test):
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


func get_neighbor_empty_slot(pos: Vector2i):
	var targets := []
	for _offset in [Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, -1), Vector2i(0, 1)]:
		var target: Vector2i = pos + _offset
		
		if (
				not Gameplay.arena.elements.has(target) and
				target.x >= 0 and target.x < 8 and target.y >= 0 and target.y < 5
		):
			targets.append(target)
	
	return targets


func get_neighbor_allied_elements(pos: Vector2i):
	var targets := []
	for _offset in [Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, -1), Vector2i(0, 1)]:
		var target: Vector2i = pos + _offset
		
		if Gameplay.arena.elements.has(target) and Gameplay.arena.elements[target].player == 1:
			targets.append(target)
	
	return targets


func create_element(atomic_number: int, position: Vector2i):
	var element = Gameplay.arena.create_element(atomic_number, PlayerController.Players.B, position, false)
	Gameplay.arena.current_players[PlayerController.Players.B].spend_energy(atomic_number + 1)
	
	start(0.2)
	await timeout
	return element


func move_element_to_slot(element: Element, slot_position: Vector2i):
	var final_position: Vector2 = Gameplay.arena._get_snapped_slot_position(slot_position)
	
	var tween := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(element, "global_position", final_position, 0.4)
	await tween.finished
	
	await Gameplay.arena.move_element(element.grid_position, slot_position)


func element_attack(element_atk: Element, element_def: Element):
	pass
