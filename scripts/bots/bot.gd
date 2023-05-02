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
	
	# talvez tratar modus_operandi antes de atualizar
	modus_operandi = chip.get_modus(analysis)
	
	await chip.make_decision(self, analysis, modus_operandi)
	
	var modus_callable: Array[Callable] = [
			chip.aggressive, chip.defensive, chip.indecided, chip.tatical_aggressive, chip.tatical_defensive
	]
	await modus_callable[modus_operandi].call(self, analysis)
	
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
