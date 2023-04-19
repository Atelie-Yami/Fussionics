extends CanvasLayer


const SCREEN_CENTER := Vector2(960, 540)

var position_offset: Vector2

@onready var layer_1: TextureRect = $A/layer_1
@onready var layer_2: TextureRect = $A/layer_2


func _process(delta):
	var pos := (layer_1.get_global_mouse_position() - SCREEN_CENTER)
	
	layer_1.position = lerp(layer_1.position, (pos / 50) - position_offset, 0.03)
	layer_2.position = lerp(layer_2.position, (pos / 350) - position_offset, 0.05)
