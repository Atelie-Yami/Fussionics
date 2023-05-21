extends VBoxContainer

const TRANSITION_TIME := 0.3

@onready var title = $title
@onready var rich_text_label = $RichTextLabel
@onready var widgets = $widgets


var tween: Tween


func _ready():
	var saga = GameBook.SAGAS[GameConfig.game_match.campaign]
	var phase: Dictionary = GameBook.LEVEL_CONFIG[GameConfig.game_match.campaign][GameConfig.game_match.level]
	
	title.text = saga[GameBook.Campagn.NAME]
	rich_text_label.text = tr("CHALLENGER") + tr(GameBook.PhaseConfig.keys()[GameConfig.game_match.level])
	
	if GameConfig.game_match.phase != GameConfig.NON_PHASE_SELECTED:
		rich_text_label.text += "[p]" + tr("PHASE") + str(GameConfig.game_match.phase + 1)
	
	if not (phase[GameBook.Campagn.WIDGETS] as Array).is_empty():
		rich_text_label.text += "\n\n\n" + tr("WIDGETS")
		
		for widget in phase[GameBook.Campagn.WIDGETS]:
			var widget_node := WidgetSlot.new()
			
			widget_node.custom_minimum_size = Vector2(55, 55)
			widget_node.mouse_filter = Control.MOUSE_FILTER_IGNORE
			widget_node.atomic_number = widget[0]
			widget_node.ranking = widget[1]
			widget_node.can_drop = true
			
			widgets.add_child(widget_node)
	animation(true)


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
	tween.finished.connect(animation_finished)


func animation_finished():
	if modulate.a < 0.5:
		visible = false


func _start_pressed():
	animation(false)
	$"../blur".lod = 0.0
	%turn_machine.start_turn()
	$"../pause_meun".visible = true
	$"../deck".visible = true
	$"../signboard".visible = true
	$"../widgets".visible = $"../widgets".has_widget
