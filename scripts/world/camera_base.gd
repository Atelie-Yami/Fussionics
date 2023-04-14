extends Camera2D

const POSITION_CENTER := Vector2(960, 540)
const MIN_ZOOM := 0.8
const MAX_ZOOM := 1.6

@export_node_path("CanvasLayer") var background_path: NodePath
@onready var background: CanvasLayer = get_node(background_path)

var extra_zoom := 1.0

func _physics_process(delta):
	zoom = lerp(zoom, Vector2(extra_zoom, extra_zoom), 0.1)
	
	background.position_offset = (global_position - POSITION_CENTER) / 4.0


func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		match event.button_index:
			MOUSE_BUTTON_WHEEL_UP:
				extra_zoom = min(extra_zoom + 0.04, MAX_ZOOM)
				
			MOUSE_BUTTON_WHEEL_DOWN:
				extra_zoom = max(extra_zoom - 0.04, MIN_ZOOM)
