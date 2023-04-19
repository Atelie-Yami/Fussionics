extends HBoxContainer


var saga_data: Dictionary


func load_saga(saga_id: int):
	get_children().map(func(c): c.visible = false)
	
	saga_data = GameBook.SAGAS[saga_id]
	for i in saga_data[GameBook.Campagn.PHASES_CONFIG].size():
		var mode: int = saga_data[GameBook.Campagn.PHASES_CONFIG][i]
		var skin: Texture
		
		if mode > 0:
			skin = saga_data[GameBook.Campagn.SKINS][mode]
		
		mode = [0, 1, 1, 1, 2][mode]
		
		get_child(i).set_mode(mode, skin)
		get_child(i).visible = true
		get_child(i).level_id = i


func load_level(level_id: int):
	print(saga_data[GameBook.Campagn.PHASES_CONFIG][level_id])
