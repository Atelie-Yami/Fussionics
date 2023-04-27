extends Node2D

const TEXTURE_PARTICLES_2 := preload("res://resouces/textures/skill_start_particles.tres")
const MATEREIAL_PARTICLES_2 := preload("res://resouces/material/particles/skill_start_particles.tres")

var particles_2_RID: RID
var canvas_item_particles_2_RID: RID

@onready var skill_start_1: GPUParticles2D = $skill_start_1

func _ready():
	particles_2_RID = RenderingServer.particles_create()
	canvas_item_particles_2_RID = RenderingServer.canvas_item_create()
	
	RenderingServer.canvas_item_set_parent(canvas_item_particles_2_RID, get_canvas_item())
#	RenderingServer.canvas_item_set_transform(canvas_item_particles_2_RID, Transform2D(0.0, Vector2(960, 540)))
#	RenderingServer.canvas_item_set_custom_rect(canvas_item_particles_2_RID, true, Rect2(-960, -540, 1920, 1080))
	
	RenderingServer.particles_set_mode(particles_2_RID, RenderingServer.PARTICLES_MODE_2D)
	RenderingServer.particles_set_process_material(particles_2_RID, MATEREIAL_PARTICLES_2.get_rid())
	RenderingServer.canvas_item_add_particles(canvas_item_particles_2_RID, particles_2_RID, TEXTURE_PARTICLES_2.get_rid())
	
#	RenderingServer.particles_set_speed_scale(particles_2_RID, 2.0)
	RenderingServer.particles_set_amount(particles_2_RID, 16)
	RenderingServer.particles_set_emitting(particles_2_RID, true)


func _input(event: InputEvent):
	if event.is_action_pressed("test"):
		_emit_start_vfx(get_viewport().get_mouse_position())


func _emit_start_vfx(_position: Vector2):
	skill_start_1.emit_particle(Transform2D(0.0, _position), Vector2.ONE, Color.WHITE, Color.WHITE, GPUParticles2D.EMIT_FLAG_POSITION)
	
	
