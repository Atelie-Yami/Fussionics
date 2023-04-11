class_name CameraArena extends Camera2D

const POSITION_CENTER := Vector2(960, 540)
const MIN_ZOOM := 0.8
const MAX_ZOOM := 1.6
const DISTANCE_FOCUS := 0.15

@export var turbulence_force := 1.0

@export_node_path("CanvasLayer") var background_path: NodePath
@onready var background: CanvasLayer = get_node(background_path)

@export var element_info_path: NodePath
@onready var element_info: PanelContainer = get_node(element_info_path)

var time := 0.0
var extra_zoom := 1.0
var turbulence: Vector2
var distance_fucus: float
var turbulence_target_0: Vector2
var turbulence_target_1: Vector2

enum CameraName{Camera_Arena,Camera_Table}
@export var NameCamera:CameraName=CameraName.Camera_Arena


func _physics_process(delta):
	if turbulence_force > 0.0:
		if time <= 0.0:
			time = randf_range(0.1, 0.9) * turbulence_force
			turbulence_target_0 = turbulence_target_0.lerp(Vector2(randf_range(-15, 15), randf_range(-15, 15)), 0.85)
		time -= delta
		
		turbulence_target_1 = turbulence_target_1.lerp(turbulence_target_0, 0.06)
		turbulence = turbulence.lerp(turbulence_target_1, 0.02)
	
	if Gameplay.selected_element and CameraName.Camera_Arena:
		if is_instance_valid(Gameplay.selected_element):
			distance_fucus = DISTANCE_FOCUS
			
			if element_info.visible:
				distance_fucus *= 3.0
			
			global_position = ((Gameplay.selected_element.position - POSITION_CENTER) * distance_fucus * extra_zoom) + POSITION_CENTER + turbulence
			
		zoom = lerp(zoom, Vector2(extra_zoom, extra_zoom) * Vector2(1.25, 1.25), 0.2)
		
	elif !Gameplay.selected_element and CameraName.Camera_Arena:
		global_position = POSITION_CENTER + turbulence
	else:
		zoom = lerp(zoom, Vector2(extra_zoom, extra_zoom), 0.1)
	
	background.position_offset = (global_position - POSITION_CENTER) / 4.0


func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		match event.button_index:
			MOUSE_BUTTON_WHEEL_UP:
				extra_zoom = min(extra_zoom + 0.04, MAX_ZOOM)
				
			MOUSE_BUTTON_WHEEL_DOWN:
				extra_zoom = max(extra_zoom - 0.04, MIN_ZOOM)
