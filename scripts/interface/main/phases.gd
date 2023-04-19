extends HBoxContainer


var saga_data: Dictionary


func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		get_children().map(func(c): c.visible = false)


func load_saga(saga_id: int):
	get_children().map(func(c): c.visible = false)
	
	saga_data = GameBook.SAGAS[saga_id]
	for i in saga_data[GameBook.Campagn.PHASES_CONFIG].size():
		var mode: int = saga_data[GameBook.Campagn.PHASES_CONFIG][i]
		var skin: Texture
		
		if mode > 0:
			skin = saga_data[GameBook.Campagn.SKINS][mode]
		
		mode = [0, 1, 1, 1, 2][mode]
		
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


func load_level(level_id: int):
	print(saga_data[GameBook.Campagn.PHASES_CONFIG][level_id])
