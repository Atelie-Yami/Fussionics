class_name AlertZone extends ColorRect


const COLORS := [Color("00f7de7b"), Color("ec4da17b")]

@export var side: TurnMachine.Players
@onready var turn_machine: TurnMachine = %turn_machine

var tween: Tween
var fade: float


func _ready():
	turn_machine.main_turn.connect(_main_turn)
	turn_machine.end_turn.connect(_end_turn)
	
	(material as ShaderMaterial).set_shader_parameter("motion_side", -1 if side else 1)
	(material as ShaderMaterial).set_shader_parameter("base_color", COLORS[side])


func _process(delta):
	(material as ShaderMaterial).set_shader_parameter("fade", fade)


func _main_turn(player):
	if abs(side) == player:
		if tween and tween.is_valid():
			tween.kill()
		
		tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "fade", 1.0, 0.5)
	

func _end_turn(player):
	if abs(side) == player:
		if tween and tween.is_valid():
			tween.kill()
		
		tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "fade", 0.0, 0.2)
