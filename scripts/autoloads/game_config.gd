extends Node

const LOAD_SCREEN := preload("res://scenes/load_screen.tscn")

class Match:
	var progress_mode: bool
	var bot_chip: GDScript
	var campaign: int
	var level: int
	
	func _init(c: int, l: int, p: bool, chip: String):
		campaign = c; level = l; progress_mode = p
		bot_chip = load(chip)


var save: Dictionary = SaveLoad.SAVE_MODEL.duplicate(true)
var game_match: Match


func _ready():
	save = SaveLoad.load_data()


func start_game(saga_id: int, level_id: int):
	var saga: Dictionary = GameBook.SAGAS[saga_id]
	var phase: GameBook.PhaseConfig = saga[GameBook.Campagn.PHASES_CONFIG][level_id]
	var progress_mode = (
			(saga_id == save.campaign_progress and level_id == save.saga_progress) or 
			(saga_id > save.campaign_progress and level_id == 0)
	)
	game_match = Match.new(saga_id, level_id, progress_mode, saga[GameBook.Campagn.BOTS][phase])
	restart_game()


func restart_game():
	get_tree().change_scene_to_packed(LOAD_SCREEN)
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://scenes/world/arena.tscn")


func advance_progress():
	if save.saga_progress + 1 == GameBook.SAGAS[game_match.campaign][GameBook.Campagn.PHASES_CONFIG].size():
		save.campaign_progress += 1
		save.saga_progress = 0
	else:
		save.saga_progress += 1
	
	print(save)
	SaveLoad.save_data(save)

