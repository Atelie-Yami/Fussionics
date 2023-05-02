extends Node

const LOAD_SCREEN := preload("res://scenes/load_screen.tscn")
const MOUSE_IMAGE := {
	DEFAULT = preload("res://assets/img/mouse/default.png"),
	ATACK = preload("res://assets/img/mouse/atack.png"),
	ACTION = preload("res://assets/img/mouse/action.png"),
	BLOQ = preload("res://assets/img/mouse/bloq.png"),
	LINK = preload("res://assets/img/mouse/link.png"),
	DESLINK = preload("res://assets/img/mouse/deslink.png"),
	MOVE = preload("res://assets/img/mouse/move.png"),
	MOVE_ACTION = preload("res://assets/img/mouse/move_action.png"),
}

class Match:
	var progress_mode: bool
	var bot_chip: GDScript
	var campaign: int
	var level: int
	
	func _init(c: int, l: int, p: bool, chip: String):
		campaign = c; level = l; progress_mode = p
		bot_chip = load(chip)

class Widget:
	var atomic_number: int
	var ranking: int
	
	func _init(a, r):
		atomic_number = a; ranking = r

var save: Dictionary = SaveLoad.SAVE_MODEL.duplicate(true)
var game_match: Match

var widgets: Array[Widget]
var last_widget_progress: int = 0


func _ready():
	mouse_image()
	
	save = SaveLoad.load_data()
	
	for saga in save.campaign_progress:
		for w in GameBook.WIDGET_DROPS[saga]:
			widgets.append(Widget.new(GameBook.WIDGET_DROPS[saga][w][0], GameBook.WIDGET_DROPS[saga][w][1]))
	
	for w in GameBook.WIDGET_DROPS[save.campaign_progress]:
		if w < save.saga_progress:
			widgets.append(Widget.new(
					GameBook.WIDGET_DROPS[save.campaign_progress][w][0],
					GameBook.WIDGET_DROPS[save.campaign_progress][w][1])
			)


func mouse_image():
	Input.set_custom_mouse_cursor(MOUSE_IMAGE.DEFAULT,     Input.CURSOR_ARROW,         Vector2( 0,  0))
	Input.set_custom_mouse_cursor(MOUSE_IMAGE.ACTION,      Input.CURSOR_POINTING_HAND, Vector2( 0,  0))
	Input.set_custom_mouse_cursor(MOUSE_IMAGE.MOVE,        Input.CURSOR_DRAG,          Vector2(16, 16))
	Input.set_custom_mouse_cursor(MOUSE_IMAGE.MOVE,        Input.CURSOR_MOVE,          Vector2(16, 16))
	Input.set_custom_mouse_cursor(MOUSE_IMAGE.ATACK,       Input.CURSOR_WAIT,          Vector2( 0,  0))
	Input.set_custom_mouse_cursor(MOUSE_IMAGE.BLOQ,        Input.CURSOR_FORBIDDEN,     Vector2(16, 17))
	Input.set_custom_mouse_cursor(MOUSE_IMAGE.MOVE_ACTION, Input.CURSOR_CAN_DROP,      Vector2(16, 16))
	Input.set_custom_mouse_cursor(MOUSE_IMAGE.LINK,        Input.CURSOR_HSIZE,         Vector2(16, 16))
	Input.set_custom_mouse_cursor(MOUSE_IMAGE.DESLINK,     Input.CURSOR_HSPLIT,        Vector2(16, 16))


func start_game(saga_id: int, level_id: int):
	var saga: Dictionary = GameBook.SAGAS[saga_id]
	var phase: Dictionary = saga[GameBook.Campagn.PHASES_CONFIG][level_id]
	var progress_mode = (
			(saga_id == save.campaign_progress and level_id == save.saga_progress) or 
			(saga_id > save.campaign_progress and level_id == 0)
	)
	game_match = Match.new(saga_id, level_id, progress_mode, saga[GameBook.Campagn.BOTS][phase[GameBook.Campagn.PHASES_CONFIG]])
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
	
	if (GameBook.WIDGET_DROPS[save.campaign_progress] as Dictionary).has(save.saga_progress):
		widgets.append(Widget.new(
				GameBook.WIDGET_DROPS[save.campaign_progress][save.saga_progress][0],
				GameBook.WIDGET_DROPS[save.campaign_progress][save.saga_progress][1])
		)
	
	SaveLoad.save_data(save)

