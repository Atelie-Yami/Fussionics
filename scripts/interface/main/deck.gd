extends VBoxContainer

const TRANSITION_TIME := 0.3

var tween: Tween

@onready var deck = $deck


func _init():
	visible = false
	modulate.a = 0.0


func animation(_in: bool):
	if tween and tween.is_valid():
		tween.kill()
	
	var final_scale = 1.0 if _in else 1.2
	var initial_scale = 1.2 if _in else 1.0
	
	visible =  true
	
	tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale", Vector2(final_scale, final_scale), TRANSITION_TIME)
	tween.parallel().tween_property(self, "modulate:a", float(_in), TRANSITION_TIME)
	tween.finished.connect(animation_finished)


func animation_finished():
	if modulate.a < 0.5:
		visible = false


func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel") and modulate.a > 0.5:
		animation(false)
		deck.save()
