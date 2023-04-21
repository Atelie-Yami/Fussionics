class_name Bot extends Node
## classe que detem os links e referencias do jogo, classe generica


var chip: BotChip
var deck := GameBook.DECK.duplicate(true)
var player: Player


func start_game(_chip: BotChip):
	chip = _chip
	player = Gameplay.arena.current_players[1]


func play():
	var result = await chip.analysis(self)
