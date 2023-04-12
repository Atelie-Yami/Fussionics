extends TextureRect


@onready var life_value = $life_value
@onready var player: Player = get_parent()


var animated_life: int
var animation := true


func _ready():
	var tween := create_tween()
	tween.tween_property(self, "animated_life", 30, 2.0)
	tween.finished.connect(func(): animation = false)


func _process(delta):
	if animation:
		life_value.text = str(animated_life)
	
	else:
		life_value.text = str(player.life)

