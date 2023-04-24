extends Node2D


@export var camera_path: NodePath
@onready var camera: CameraArena = get_node(camera_path)

@onready var particles = $particles
@onready var center = $center
@onready var halo: Node2D = $halos/halo
@onready var halos = $halos

@onready var omega = $"../omega"


var timer := 0.0


func _ready():
	set_process(false)


func play():
	set_process(true)


func _process(delta):
	timer += delta
	
	if int(timer * 10.0) % 2 == 0:
		camera.shake(2.0)
	
	if int(timer * 10.0) % 4 == 0:
		var halo2: Node2D = halo.duplicate()
		halos.add_child(halo2)
		halo2.rotation = randf_range(-180, 180)
		halo2.scale.x = randf_range(0.1, 2)
		halo2.modulate.a = randf_range(0.2, 1)
		halo2.modulate.r = randf_range(0.7, 1)
		halo2.modulate.g = randf_range(0.8, 1)
		halo2.modulate.b = randf_range(0.9, 1.1)
	
	if timer > 2.3:
		particles.emitting = true
		center.modulate.a = 1.0 - clamp((timer - 2.3) * 5.0, 0.0, 1.0)
		halos.modulate.a = 1.0 - clamp((timer - 2.3) * 5.0, 0.0, 1.0)
		
	else:
		center.modulate.a = clamp(timer / 2.0, 0.0, 1.0)
	
	if timer > 2.5:
		center.visible = false
		omega.visible = false
		set_process(false)
		camera.shake(5.0)
	
	center.scale = Vector2(0.35 + timer, 0.35 + timer)
