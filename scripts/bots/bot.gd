class_name Bot extends Node
## classe que detem os links e referencias do jogo, classe generica

const MAX_SEARCH_TEST := 40

var breath_time := Timer.new()

var chip: BotChip
var deck := GameBook.DECK.duplicate(true)
@onready var player: Player = $".."


func _ready():
	add_child(breath_time)
	breath_time.one_shot = true
	
	chip = GameConfig.game_match.bot_chip.new()
	player.play.connect(_play)


func _play():
	var result = await chip.analysis(self)
	
	
	
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
