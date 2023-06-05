extends "res://scripts/bots/chipset/amethyst_lockdown.gd"


static func execute(bot: Bot, desicions: Array[BotChip.Decision]):
	for dsc in desicions:
		if dsc.decision_link:
			await execute_decision(bot, dsc.decision_link)
		
		await execute_decision(bot, dsc)


static func execute_decision(bot: Bot, decision: BotChip.Decision):
	var energy: int = bot.player.energy -1
	if decision.directive == BotChip.Directive.MAX_ENERGY:
		energy = decision.args[0]
	
	match decision.action:
		BotChip.Action.COOK:
			var reactor_selector: int = bot.get_reactor_empty()
			if reactor_selector == -1:
				return
			
			if decision.targets.size() == 2 and decision.targets[0] is Element and decision.targets[1] is Element:
				for i in decision.targets.size():
					await bot.move_element_to_slot(decision.targets[i], Vector2i(9 + (i * 2), 4 if reactor_selector else 0))
					bot.start(0.2)
					await bot.timeout
					
			elif decision.targets.size() == 1:
				if not bot.player.energy:
					return
				
				await bot.move_element_to_slot(decision.targets[0], Vector2i(9, 4 if reactor_selector else 0))
				bot.start(0.2)
				await bot.timeout
				await bot.create_element(energy, Vector2i(11, 4 if reactor_selector else 0))
		
		BotChip.Action.CREATE:
			if not bot.player.energy:
				return
			
			if decision.action_target == BotChip.ActionTarget.MY_ELEMENT:
				await execute_create_handler(bot, bot.player.energy)
				
			elif decision.action_target == BotChip.ActionTarget.MY_MOLECULE:
				var _diff: int = bot.player.energy % 2
				var max_atomic: int = (bot.player.energy + _diff) / 2
				var min_atomic: int = (bot.player.energy - _diff) / 2
					
				await execute_create_molecule(bot, max_atomic -1, min_atomic -1)
		
		BotChip.Action.DEFEND:
			pass
		
		BotChip.Action.DESTROY:
			pass
		
		BotChip.Action.MERGE:
			if decision.targets.is_empty():
				return
			
			match decision.action_target:
				BotChip.ActionTarget.MY_ELEMENT:
					if (
							decision.targets.size() == 2 and
							decision.targets[0] is Element and decision.targets[1] is Element
					):
						for element in decision.targets:
							if not element is Element or not GameJudge.can_element_link(element):
								return
						
						await execute_merge_element_to_element(bot, decision.targets[0], decision.targets[1])
					
					if not bot.player.energy or decision.targets.size() != 1:
						return
					
					if decision.targets[0] is Element and GameJudge.can_element_link(decision.targets[0]):
						await execute_merge_element_new_element(bot, decision.targets[0], energy)
					
					elif decision.targets[0] is Molecule:
						await execute_merge_molecule_new_element(bot, decision.targets[0], energy)
						
				BotChip.ActionTarget.MY_MOLECULE: 
					var molecule: Molecule = decision.targets[0]
					for element in molecule.configuration:
						if not GameJudge.can_element_link(element):
							continue
						
						var molecules_linked: bool
						
						var ally_slots: Array = bot.get_neighbor_allied_elements(element.grid_position)
						for position in ally_slots:
							var slot: ArenaSlot = Arena.get_slot(position)
							
							if slot.molecule == molecule or not GameJudge.can_element_link(slot.element):
								continue
							
							await GameJudge.make_full_link_elements(element, slot.element)
							molecules_linked = true
							break
						
						if molecules_linked:
							break
		
		BotChip.Action.MITIGATE:
			pass
		
		BotChip.Action.POTENTIALIZE:
			match decision.action_target:
				BotChip.ActionTarget.MY_ELEMENT: # elemento q ta numa molecula
					if not bot.player.energy:
						return
					
					var element: Element = decision.targets[0]
					if (
							decision.targets.size() == 1 and element is Element and
							GameJudge.can_element_link(element)
					):
						await execute_potencialize_element(bot, element, energy)


static func execute_create_handler(bot: Bot, energy: int):
	match energy:
		4: 
			await execute_create_element_random_position(bot, 3)
		6:
			var positions: Array = insight_get_slots_nearly(bot, 3)
			if positions.is_empty():
				return
			
			var element_A: Element = await bot.create_element(3, positions[0])
			var element_B: Element = await bot.create_element(0, positions[1])
			var element_C: Element = await bot.create_element(0, positions[2])
			
			if not element_A:
				return
			
			if element_B:
				await GameJudge.make_full_link_elements(element_A, element_B)
		
			if element_C:
				await GameJudge.make_full_link_elements(element_A, element_C)
		7:
			var positions: Array = insight_get_slots_nearly(bot, 4)
			if positions.is_empty():
				return
			
			var element_A: Element = await bot.create_element(4, positions[0])
			var element_B: Element = await bot.create_element(0, positions[1])
			var element_C: Element = await bot.create_element(0, positions[2])
			var element_D: Element = await bot.create_element(0, positions[3])
			
			if not element_A:
				return
			
			if element_B:
				await GameJudge.make_full_link_elements(element_A, element_B)
			if element_C:
				await GameJudge.make_full_link_elements(element_A, element_C)
			if element_D:
				await GameJudge.make_full_link_elements(element_A, element_D)
		_:
			await execute_create_molecule(bot, 0, 0)


static func execute_create_element_random_position(bot: Bot, atomic_number: int):
	var position = bot.get_empty_slot()
	if position == null:
		return
	
	await bot.create_element(atomic_number, position)


static func execute_create_molecule(bot: Bot, atomic_number_1: int, atomic_number_2: int):
	var position1 = bot.get_empty_slot()
	if position1 == null:
		return
	
	var positions: Array = bot.get_neighbor_empty_slot(position1)
	if positions.is_empty():
		return
	
	var element_A: Element = await bot.create_element(atomic_number_1, position1)
	var element_B: Element = await bot.create_element(atomic_number_2, positions[0])
	
	if element_A and element_B:
		await GameJudge.make_full_link_elements(element_A, element_B)


static func execute_merge_element_new_element(bot: Bot, element: Element, energy: int):
	if GameJudge.REACTOR_OUT_POSITIONS.has(element.grid_position):
		var position = bot.get_empty_slot()
		if position != null:
			await bot.move_element_to_slot(element, position)
	
	var positions: Array = bot.get_neighbor_empty_slot(element.grid_position)
	if positions.is_empty():
		return
	
	var element_A = await bot.create_element(energy, positions[0])
	if element_A:
		await Gameplay.arena.link_elements(element_A, element)


static func execute_merge_element_to_element(bot: Bot, element_A: Element, element_B: Element):
	if not GameJudge.is_positions_neighbor(element_A.grid_position, element_B.grid_position):
		for i in 2:
			var empty_slots: Array = bot.get_neighbor_empty_slot([element_A, element_B][i].grid_position)
			if empty_slots.is_empty():
				continue
				
			await bot.move_element_to_slot([element_A, element_B][(i + 1) % 2], empty_slots[0])
			break
	
	if GameJudge.is_positions_neighbor(element_A.grid_position, element_B.grid_position):
		await GameJudge.make_full_link_elements(element_A, element_B)


static func execute_merge_molecule_new_element(bot: Bot, molecule: Molecule, energy: int):
	for element in molecule.configuration:
		if not is_instance_valid(element) or not GameJudge.can_element_link(element):
			continue
		
		var empty_slots: Array = bot.get_neighbor_empty_slot(element.grid_position)
		if empty_slots.is_empty():
			continue
		
		var element_A: Element = await bot.create_element(energy, empty_slots[0])
		if element_A:
			await GameJudge.make_full_link_elements(element_A, element)
			return


static func execute_potencialize_element(bot: Bot, element: Element, energy: int):
	# se tem lugar livre
	var positions: Array = bot.get_neighbor_empty_slot(element.grid_position)
	if not positions.is_empty():
		await execute_merge_element_new_element(bot, element, energy)
		return
	
	# nao tem mas se tem rival ao lado
	var rival_positions: Array[Element] = bot.get_neighbor_rival_elements(element.grid_position)
	if not rival_positions.is_empty():
		for e in rival_positions:
			var rival_slot: ArenaSlot = Arena.elements[e.grid_position]
			if rival_slot.molecule:
				continue
			
			for slot in (Arena.elements as Dictionary).values():
				if (
						slot.player == PlayerController.Players.A or slot.element == element or
						not GameJudge.combat_check_result(slot.element, e, rival_slot.defend_mode)
				):
					continue
				
				if not Arena.elements[element.grid_position].molecule:
					await insight_combat_element_attack(slot.element, e, rival_slot.defend_mode)
					break
				if (
						Arena.elements[element.grid_position].molecule and not
						Arena.elements[element.grid_position].molecule.configuration.has(element)
				):
					var p_e := GameJudge.get_powerful_element_in_molecule(Arena.elements[element.grid_position].molecule)
					await insight_combat_element_attack(p_e, e, rival_slot.defend_mode)
					break
			
			positions = bot.get_neighbor_empty_slot(element.grid_position)
			if not positions.is_empty():
				await execute_merge_element_new_element(bot, element, energy)
				return
	
	# não tem mas tem elemento solto ao lado
	var ally_elements: Array[Element] = bot.get_neighbor_allied_elements(element.grid_position)
	for e in ally_elements:
		if Arena.get_slot(e.grid_position).molecule:
			continue
		
		var pos = bot.get_empty_slot()
		if not pos:
			continue
		
		await bot.move_element_to_slot(ally_elements[0], pos)
		bot.start(0.5)
		await bot.timeout
		
		positions = bot.get_neighbor_empty_slot(element.grid_position)
		if positions.is_empty():
			continue
		
		await execute_merge_element_new_element(bot, element, energy)
		return
