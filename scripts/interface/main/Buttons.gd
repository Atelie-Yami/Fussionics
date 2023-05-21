extends VBoxContainer

const TRANSITION_TIME := 0.3

@onready var main_menu = $".."

var tween: Tween


func animation(_in: bool):
	if tween and tween.is_valid():
		tween.kill()
	
	tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", Vector2(48 if _in else -500, position.y), TRANSITION_TIME)


func _campaign_pressed():
	main_menu.state = main_menu.State.CAMPAIGN


func _quick_game_pressed():
	main_menu.state = main_menu.State.QUICK_GAME


func _deck_pressed():
	main_menu.state = main_menu.State.DECK


func _fussion_galery_pressed():
	pass # Replace with function body.


func _config_pressed():
	pass # Replace with function body.


func _quit_pressed():
	get_tree().quit()
