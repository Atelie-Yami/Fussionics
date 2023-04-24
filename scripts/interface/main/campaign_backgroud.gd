extends TextureRect

const TRANSITION_TIME := 0.4

@onready var boss = $boss

var tween: Tween


func animation(_in: bool):
	if tween and tween.is_valid():
		tween.kill()
	
	var final_scale = 1.0 if _in else 1.2
	var initial_scale = 1.2 if _in else 1.0
	
	tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", Vector2(0 if _in else 1100, 0), TRANSITION_TIME)


func load_images(_texture: Texture, color: String):
	boss.texture = _texture
	(texture as GradientTexture2D).gradient.set_color(1, Color(color))
	animation(true)
	boss.animation(true)


func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel") and position.x < 1900:
		animation(false)
		boss.animation(false)

