class_name AttackBaseEFX extends Sprite2D


const ATTACK_BASE_TEXTURE := preload("res://resouces/textures/attack_base.tres")
const SPEED := 22.0

var direction: Vector2
var target: Vector2

var time: float = 0.0
var life_time: float


func _init():
	texture = ATTACK_BASE_TEXTURE


func _ready():
	direction = (target - position).normalized()
	rotation = direction.angle()
	life_time = position.distance_to(target) / (60.0 * SPEED)


func _physics_process(delta: float):
	position += direction * SPEED
	
	time += delta
	
	if time >= life_time:
		queue_free()

