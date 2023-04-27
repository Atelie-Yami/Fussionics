extends HBoxContainer

const TRANSITION_TIME := 0.3

var saga_id: int
var tween: Tween


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


func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel") and modulate.a > 0.5:
		animation(false)


func load_saga(_saga_id: int):
	saga_id = _saga_id
	
	get_children().map(func(c): c.visible = false)
	
	var saga_data = GameBook.SAGAS[saga_id]
	for i in saga_data[GameBook.Campagn.PHASES_CONFIG].size():
		var phase: Dictionary = saga_data[GameBook.Campagn.PHASES_CONFIG][i]
		var skin: Texture
		
		if phase[GameBook.Campagn.PHASES_CONFIG] != GameBook.PhaseConfig.NORMAL:
			skin = saga_data[GameBook.Campagn.SKINS][phase[GameBook.Campagn.PHASES_CONFIG]]
		
		var mode = [0, 1, 1, 1, 2][phase[GameBook.Campagn.PHASES_CONFIG]]
		
		get_child(i).visible = true
		get_child(i).level_id = i
		
		get_child(i).begin = i == 0
		get_child(i).last = i + 1 == saga_data[GameBook.Campagn.PHASES_CONFIG].size()
		
		if saga_id != GameConfig.save.campaign_progress:
			get_child(i).set_mode(mode, skin, 2)
			continue
		
		if i < GameConfig.save.saga_progress:
			get_child(i).set_mode(mode, skin, 2)
		
		elif i == GameConfig.save.saga_progress:
			get_child(i).set_mode(mode, skin, 1)
			
		else:
			get_child(i).set_mode(mode, skin, 0)
	
	animation(true)


func load_level(level_id: int):
	animation(false)
	$"../boss_descrition".animation(false)
	$"../backgroud/boss".animation(false)
	$"../backgroud".animation(false)
	
	await get_tree().create_timer(0.5).timeout
	GameConfig.start_game(saga_id, level_id)



