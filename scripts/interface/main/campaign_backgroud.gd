extends TextureRect


@onready var boss = $boss


func load_images(_texture: Texture, color: String):
	boss.texture = _texture
	(texture as GradientTexture2D).gradient.set_color(1, Color(color))
	visible = true


func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		visible = false
