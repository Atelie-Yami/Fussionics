extends Control
class_name GuiMenu

enum State {
	MAIN_MENU, CAMPAIGN, QUICK_GAME, CONFIG
}

@export var Settings:Control

@onready var buttons = $Buttons
@onready var links = $links
@onready var campaign = $campaign

var state: State:
	set(value):
		state = value
		_machine()


func _machine():
	campaign.animation(state == State.CAMPAIGN)
	buttons.animation(state == State.MAIN_MENU)
	links.animation(state == State.MAIN_MENU)


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
<<<<<<< HEAD
		state = State.MAIN_MENU
=======
		match state:
			State.CAMPAIGN:
				state == State.MAIN_MENU
				
				if buttons_tween and buttons_tween.is_valid():
					buttons_tween.kill()
				
				buttons_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
				buttons_tween.tween_property(campaign, "position", Vector2(-500, campaign.position.y), TRANSITION_TIME)
				buttons_tween.tween_property(buttons, "position", Vector2(48, buttons.position.y), TRANSITION_TIME)
				buttons_tween.parallel().tween_property(links, "position", Vector2(links.position.x, 950), TRANSITION_TIME)


func _partida_rapida_pressed():
	get_tree().change_scene_to_file("res://scenes/world/arena.tscn")


func _galeriafussion_pressed():
	get_tree().change_scene_to_file("res://scenes/interface/periodic_table/table.tscn")


func _configuraes_pressed():
	Settings.visible = true


func _sairdo_jogo_pressed():
	#Se quiser pode colocar algum save
	get_tree().quit()


func _itch_pressed():
	OS.shell_open("https://itch.io/profile/atelie-yami")


func _insta_pressed():
	OS.shell_open("https://www.instagram.com/atelie.yami/")
>>>>>>> 337611a7116401840a780db1fe02408b9734818c


