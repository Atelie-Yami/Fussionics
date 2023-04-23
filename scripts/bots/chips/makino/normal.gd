extends BotChip


func analysis(bot: Bot):
	if randi_range(0, 4) == 0:
		var pos = bot.get_empty_slot()
		if pos:
			await create_element(bot, randi_range(0, 10), pos)
	
	if bot.player.energy > 2:
		var pos = bot.get_empty_slot()
		if pos:
			var element_A = await create_element(bot, 0, pos)
			
			var pos2: Array = bot.get_neighbor_empty_slot(pos)
			if not pos2.is_empty() and element_A:
				pos2.shuffle()
				
				var element_B = await create_element(bot, 0, pos2[0])
				
				if element_B:
					await Gameplay.arena.link_elements(element_A, element_B)
					await Gameplay.arena.defend_mode(element_A.grid_position)
