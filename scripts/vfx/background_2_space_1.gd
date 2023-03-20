extends CanvasLayer


const SCREEN_CENTER := Vector2(960, 540)

var position_offset: Vector2

@onready var layer_1: Sprite2D = $layer_1
@onready var layer_2: Sprite2D = $layer_2
@onready var particles = $particles


func _process(delta):
	var pos := (layer_1.get_global_mouse_position() - SCREEN_CENTER)
	
	layer_1.position = lerp(layer_1.position, (pos / 50) - position_offset, 0.03)
	layer_2.position = lerp(layer_2.position, (pos / 350) - position_offset, 0.05)
	particles.position = lerp(particles.position, SCREEN_CENTER + (pos / 200) - position_offset, 0.04)
