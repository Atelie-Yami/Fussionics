extends Panel

var fade: float
var tween: Tween


func _process(delta):
	(material as ShaderMaterial).set_shader_parameter("fade", fade)


func set_fade(value: float):
	if tween and tween.is_valid():
		tween.kill()
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "fade", value, 0.3)

