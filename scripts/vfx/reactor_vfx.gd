class_name ReactorVFX extends TextureRect


@onready var timer: Timer = $Timer
@onready var light = $light
@onready var particles = $particles

@export var actived: bool
var powered_shader_value := 0.0
var _powered_shader_value := 0.0


func _process(delta):
	powered_shader_value = float(actived)
	_powered_shader_value = lerp(_powered_shader_value, powered_shader_value, 0.13)
	(material as ShaderMaterial).set_shader_parameter("powered", _powered_shader_value)


func start(color: Color):
	light.modulate = color; light.modulate.a = 0.0
	particles.modulate = color
	_start()


func _start():
	pass


func halos():
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(light, "modulate:a", 1.0, 0.3)
	tween.tween_property(light, "modulate:a", 0.0, 0.3)
