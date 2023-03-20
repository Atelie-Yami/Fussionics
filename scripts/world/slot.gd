class_name PanelSlot extends Panel





func animation():
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.5).from(Vector2(0.5, 0.5))
	visible = true
