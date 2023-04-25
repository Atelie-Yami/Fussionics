extends VBoxContainer

const TRANSITION_TIME := 0.5

@onready var title = $title
@onready var rich_text_label = $RichTextLabel

@onready var next = $HBoxContainer/next
@onready var restart = $HBoxContainer/restart
@onready var widgets = $widgets


var tween: Tween


func _ready():
	var saga = GameBook.SAGAS[GameConfig.game_match.campaign]
	var phase: Dictionary = saga[GameBook.Campagn.PHASES_CONFIG][GameConfig.game_match.level]
	
	rich_text_label.text = tr("CHALLENGER") + tr(GameBook.PhaseConfig.keys()[phase[GameBook.Campagn.PHASES_CONFIG]])
	rich_text_label.text += "[p]" + tr("PHASE") + str(GameConfig.game_match.level + 1)
	
	if not (phase[GameBook.Campagn.DROPS] as Array).is_empty():
		rich_text_label.text += "\n\n\n" + tr("DROPS")
		
		for widget in phase[GameBook.Campagn.DROPS]:
			var widget_node := WidgetSlot.new()
			
			widget_node.custom_minimum_size = Vector2(55, 55)
			widget_node.mouse_filter = Control.MOUSE_FILTER_IGNORE
			widget_node.atomic_number = widget[0]
			widget_node.ranking = widget[1]
			widget_node.can_drop = true
			widgets.add_child(widget_node)


func animation(_in: bool):
	if tween and tween.is_valid():
		tween.kill()
	
	var final_scale = 1.0 if _in else 1.2
	var initial_scale = 1.2 if _in else 1.0
	
	scale = Vector2(initial_scale, initial_scale)
	modulate.a = float(not _in)
	visible =  true
	
	tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale", Vector2(final_scale, final_scale), TRANSITION_TIME)
	tween.parallel().tween_property(self, "modulate:a", float(_in), TRANSITION_TIME)


func end(win: bool):
	animation(true)
	visible = true
	
	title.text = tr("WIN" if win else "LOSE")
	restart.visible = not win
	widgets.visible = win
	next.visible = win


func _main_pressed():
	get_tree().change_scene_to_file("res://scenes/interface/main_menu/main.tscn")


func _next_pressed():
	GameConfig.start_game(GameConfig.save.campaign_progress, GameConfig.save.saga_progress)


func _restart_pressed():
	GameConfig.restart_game()
