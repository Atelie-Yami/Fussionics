class_name CameraArena extends "res://scripts/world/camera_base.gd"


const DISTANCE_FOCUS := 0.15

@export var turbulence_force := 1.0
@export var element_info_path: NodePath
@onready var element_info: PanelContainer = get_node(element_info_path)

var time := 0.0
var turbulence: Vector2
var distance_fucus: float
var turbulence_target_0: Vector2
var turbulence_target_1: Vector2

var tween_shake: Tween


func _physics_process(delta):
	if turbulence_force > 0.0:
		if time <= 0.0:
			time = randf_range(0.1, 0.9) * turbulence_force
			turbulence_target_0 = turbulence_target_0.lerp(Vector2(randf_range(-15, 15), randf_range(-15, 15)), 0.85)
		time -= delta
		
		turbulence_target_1 = turbulence_target_1.lerp(turbulence_target_0, 0.06)
		turbulence = turbulence.lerp(turbulence_target_1, 0.02)
	
	if Gameplay.selected_element:
		if is_instance_valid(Gameplay.selected_element):
			distance_fucus = DISTANCE_FOCUS
			
			if element_info.visible:
				distance_fucus *= 3.0
			
			global_position = ((Gameplay.selected_element.global_position - POSITION_CENTER) * distance_fucus * extra_zoom) + POSITION_CENTER + turbulence
			
		zoom = lerp(zoom, Vector2(extra_zoom, extra_zoom) * Vector2(1.25, 1.25), 0.2)
		
	else:
		global_position = POSITION_CENTER + turbulence
		zoom = lerp(zoom, Vector2(extra_zoom, extra_zoom), 0.1)
	
	background.position_offset = (global_position - POSITION_CENTER) / 4.0


func shake(power: float):
	if tween_shake and tween_shake.is_valid():
		tween_shake.kill()
	
	var shake_direction := Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * power * 10.0
	offset = shake_direction
	
	tween_shake = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween_shake.tween_property(self, "offset", Vector2.ZERO, power * 0.25)


