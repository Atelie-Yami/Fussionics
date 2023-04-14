class_name EletronChangeLable extends Label


func _init(value: int):
	if value < 0:
		modulate = Color.INDIAN_RED
		text = str(value)
	
	else:
		modulate = Color.MEDIUM_SPRING_GREEN
		text = "+" + str(value)
	
	modulate.a = 0.0


func _ready():
	var tween := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "modulate:a", 1.0, 0.45)
	tween.tween_property(self, "modulate:a", 0.0, 0.45)
	
	var final_position = global_position + Vector2(0, -20)
	var tween2 := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween2.tween_property(self, "global_position", final_position, 0.9)
	
	tween2.finished.connect(queue_free)
