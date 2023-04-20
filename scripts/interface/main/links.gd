extends MarginContainer

const TRANSITION_TIME := 0.3
var tween: Tween


func animation(_in: bool):
	if tween and tween.is_valid():
		tween.kill()
	
	tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", Vector2(position.x, 950 if _in else 1200), TRANSITION_TIME)


func _itch_pressed():
	OS.shell_open("https://itch.io/profile/atelie-yami")


func _twiter_pressed():
	OS.shell_open("https://twitter.com/AtelieYami")


func _insta_pressed():
	OS.shell_open("https://www.instagram.com/atelie.yami/")
