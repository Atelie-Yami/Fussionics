extends PanelContainer

const TRANSITION_TIME := 0.3
var tween: Tween


func animation(_in: bool):
	if tween and tween.is_valid():
		tween.kill()
	
	tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", Vector2(30 if _in else -500, position.y), TRANSITION_TIME)
