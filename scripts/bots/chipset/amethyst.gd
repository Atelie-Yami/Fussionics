class_name ChipSetAmethist extends ChipSet


static func get_modus(_analysis: BotChip.FieldAnalysis) -> Bot.ModusOperandi:
	if not _analysis.has_my_elements_in_field and _analysis.has_rival_elements_in_field:
		return Bot.ModusOperandi.DEFENSIVE
	
	if _analysis.has_my_elements_in_field and not _analysis.has_rival_elements_in_field:
		return Bot.ModusOperandi.AGGRESSIVE
	
	for m in _analysis.my_molecules:
		var power: int = GameJudge.calcule_max_molecule_eletrons_power(m)
		if power > 7 and GameJudge.is_molecule_opened(m):
			return Bot.ModusOperandi.STRATEGICAL_AGGRESSIVE
	
	if _analysis.my_molecules.is_empty():
		for e in _analysis.my_single_elements:
			if e.atomic_number > 3:
				return Bot.ModusOperandi.STRATEGICAL_DEFENSIVE
	
	return Bot.ModusOperandi.UNDECIDED


static func indecided(bot: Bot, analysis: BotChip.FieldAnalysis):
	var decision_list: Array[BotChip.Decision]
	
	for m in analysis.my_molecules:
		if GameJudge.is_molecule_opened(m): ## se da pra por elementos na molecula
			var d := BotChip.Decision.new()
			decision_list.append(d)
			
			d.action_target = BotChip.ActionTarget.NEW ## tag NEW vai criar um elemento
			d.action = BotChip.Action.MERGE ## tag MERGE vai unir o novo elemento na molecula
			d.targets = [m] ## a molecula
			break
		
		## criar um MERGE de 2 moleculas target MY_MOLECULE
	
	if analysis.my_single_elements.is_empty():
		var d := BotChip.Decision.new()
		decision_list.append(d)
		
		if bot.player.energy > 6:
			d.action_target = BotChip.ActionTarget.MY_MOLECULE
		else:
			d.action_target = BotChip.ActionTarget.NEW
		
		d.action = BotChip.Action.CREATE
	
	elif analysis.my_single_elements.size() == 1:
		var d := BotChip.Decision.new()
		decision_list.append(d)
		
		d.action_target = BotChip.ActionTarget.NEW
		d.targets = [analysis.my_single_elements[0]]
		
		if analysis.my_single_elements[0].atomic_number < 4:
			d.action = BotChip.Action.COOK
		else:
			d.action = BotChip.Action.MERGE
	
	else:
		var match_element: Element
		
		for e in analysis.my_single_elements:
			if e.number_electrons_in_valencia <= 0 or not GameJudge.can_element_link(e):
				continue
			
			if not match_element:
				match_element = e
				continue
			
			var d := BotChip.Decision.new()
			decision_list.append(d)
			
			d.action_target = BotChip.ActionTarget.MY_ELEMENT
			d.targets = [e, match_element]
			d.action = BotChip.Action.MERGE
	
	return decision_list


static func execute(bot: Bot, desicions: Array[BotChip.Decision]):
	for dsc in desicions:
		await execute_decision(bot, dsc)


static func execute_decision(bot: Bot, decision: BotChip.Decision):
	if decision.decision_link:
		await execute_decision(bot, decision.decision_link)
	
	match decision.action:
		BotChip.Action.COOK:
			var reactor_selector: int = -1 ## 0 fusão 1 acelerador
			if (
					Gameplay.arena._check_slot_empty(GameJudge.REACTOR_POSITIONS[4]) and
					Gameplay.arena._check_slot_empty(GameJudge.REACTOR_POSITIONS[5])
			):
				reactor_selector = 0
			
			elif (
					Gameplay.arena._check_slot_empty(GameJudge.REACTOR_POSITIONS[6]) and
					Gameplay.arena._check_slot_empty(GameJudge.REACTOR_POSITIONS[7])
			): 
				reactor_selector = 1
			
			if (
					reactor_selector != -1 and decision.targets.size() == 2 and
					decision.targets[0] is Element and decision.targets[1] is Element
			):
				for i in decision.targets.size():
					await bot.move_element_to_slot(decision.targets[i], Vector2i(12 + (i * 2), 4 if reactor_selector else 0))
					
					bot.start(0.2)
					await bot.timeout
			
			decision.completed = true
		
		BotChip.Action.CREATE:
			if not decision.targets.is_empty():
				decision.completed = true
				return
			
			if decision.action_target == BotChip.ActionTarget.NEW:
				var position = bot.get_empty_slot()
				
				if position != null:
					bot.create_element(bot.player.energy, position)
				
			elif decision.action_target == BotChip.ActionTarget.MY_MOLECULE:
				var position1 = bot.get_empty_slot()
				
				if position1 != null:
					var positions: Array = bot.get_neighbor_allied_elements(position1)
					if not positions.is_empty():
						var element_A: Element; var element_B: Element
						
						if bot.player.energy % 2 == 0:
							element_A = await bot.create_element(bot.player.energy, position1)
							element_B = await bot.create_element(bot.player.energy, positions[0])
						else:
							element_A = await bot.create_element((bot.player.energy + 1) / 2, position1)
							element_B = await bot.create_element((bot.player.energy - 1) / 2, positions[0])
						
						if element_A and element_B:
							await Gameplay.arena.link_elements(element_A, element_B)
			
			decision.completed = true
		
		BotChip.Action.DEFEND:
			pass
		
		BotChip.Action.DESTROY:
			pass
		
		BotChip.Action.MERGE:
			match decision.action_target:
				BotChip.ActionTarget.NEW:
					if decision.targets.is_empty():
						decision.completed = true
						return
					
					var element = decision.targets[0]
					
					if (
							element is Element and element.number_electrons_in_valencia > 0 and
							GameJudge.can_element_link(element)
					):
						var positions: Array = bot.get_neighbor_allied_elements(element.grid_position)
						if positions.is_empty():
							decision.completed = true
							return
						
						var element_A = await bot.create_element(bot.player.energy, positions[0])
				
				BotChip.ActionTarget.MY_ELEMENT:
					pass
				
				BotChip.ActionTarget.MY_MOLECULE:
					pass
			
			
		
		BotChip.Action.MITIGATE:
			pass
		
		BotChip.Action.POTENTIALIZE:
			pass
	
	decision.completed


