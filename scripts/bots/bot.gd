class_name Bot extends Node
## classe que detem os links e referencias do jogo, classe generica


var chip: BotChip
var deck := GameBook.DECK.duplicate(true)
@onready var player: Player = $".."


func _ready():
	chip = GameConfig.game_match.bot_chip.new()
	player.play.connect(_play)


func _play():
	var result = await chip.analysis(self)
	
	player.arena.create_element(
			randi_range(0, 10), PlayerController.Players.B, 
			Vector2i(randi_range(0, 7), randi_range(0, 4)), false
	)
	
	end_turn()


func end_turn():
	player.arena.turn_machine.next_phase()
