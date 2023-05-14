class_name ChipSetAmethist extends ChipSet


static func get_modus(_analysis: BotChip.FieldAnalysis) -> Bot.ModusOperandi:
	if not _analysis.has_my_elements_in_field and _analysis.has_rival_elements_in_field:
		return Bot.ModusOperandi.DEFENSIVE
	
	if _analysis.has_my_elements_in_field and not _analysis.has_rival_elements_in_field:
		return Bot.ModusOperandi.AGGRESSIVE
	
#	for m in _analysis.my_molecules:
#		var power: int = GameJudge.calcule_max_molecule_eletrons_power(m)
#		if power > 7 and GameJudge.is_molecule_opened(m):
#			return Bot.ModusOperandi.STRATEGICAL_AGGRESSIVE
#
#	if _analysis.my_molecules.is_empty():
#		for e in _analysis.my_single_elements:
#			if e.atomic_number > 3:
#				return Bot.ModusOperandi.STRATEGICAL_DEFENSIVE
#
	return Bot.ModusOperandi.UNDECIDED

# ----------------------------------------------------------------------------------------------- #
# MODUS
# ----------------------------------------------------------------------------------------------- #
static func defensive(bot: Bot, analysis: BotChip.FieldAnalysis):
	var decision_list: Array[BotChip.Decision]
	
	if analysis.my_molecules.size() > 0:
		decision_list.append(insight_element_merge_molecule(analysis.my_molecules[0]))
	
	elif bot.player.energy > 7:
		decision_list.append(insight_create_molecule())
	else:
		decision_list.append(insight_create_molecule())
	
	return decision_list


static func aggressive(bot: Bot, analysis: BotChip.FieldAnalysis):
	var decision_list: Array[BotChip.Decision]
	
	if analysis.my_molecules.size() > 0:
		var best_match: Molecule
		var last_power: int
		for molecule in analysis.my_molecules:
			var molecule_power: int = GameJudge.calcule_max_molecule_eletrons_power(molecule)
			if not last_power:
				last_power = molecule_power
				best_match = molecule
				continue
			
			if last_power != molecule_power:
				last_power = molecule_power
				best_match = molecule
				
		if best_match:
			decision_list.append(insight_element_merge_molecule(best_match))
	
	elif bot.player.energy > 6:
		decision_list.append(insight_create_molecule())
	else:
		decision_list.append(insight_create_element())
	
	return decision_list


static func indecided(bot: Bot, analysis: BotChip.FieldAnalysis):
	var decision_list: Array[BotChip.Decision]
	
	if analysis.my_molecules.size() == 1:
		decision_list.append(insight_element_merge_molecule(analysis.my_molecules[0]))
	
	elif analysis.my_molecules.size() > 1:
		var d := BotChip.Decision.new()
		decision_list.append(d)
		
		d.action_target = BotChip.ActionTarget.MY_MOLECULE
		d.action = BotChip.Action.MERGE
		
		for m in analysis.my_molecules:
			if GameJudge.is_molecule_opened(m): ## se da pra por elementos na molecula
				d.targets.append(m)
	
	if analysis.my_single_elements.is_empty():
		if bot.player.energy > 8:
			decision_list.append(insight_create_molecule())
		else:
			decision_list.append(insight_create_element())
	
	elif analysis.my_single_elements.size() == 1:
		var d := BotChip.Decision.new()
		decision_list.append(d)
		
		d.action_target = BotChip.ActionTarget.MY_ELEMENT
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

# ----------------------------------------------------------------------------------------------- #
# EXECUTE
# ----------------------------------------------------------------------------------------------- #
static func execute(bot: Bot, desicions: Array[BotChip.Decision]):
	for dsc in desicions:
		await execute_decision(bot, dsc)


static func execute_decision(bot: Bot, decision: BotChip.Decision):
	if decision.decision_link:
		await execute_decision(bot, decision.decision_link)
	
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
				await bot.create_element(bot.player.energy -1, Vector2i(11, 4 if reactor_selector else 0))
		
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
							decision.targets.size() == 1 and decision.targets[0] is Element
							and GameJudge.can_element_link(decision.targets[0]) and bot.player.energy
					):
						if GameJudge.REACTOR_OUT_POSITIONS.has(decision.targets[0].grid_position):
							var position = bot.get_empty_slot()
							if position != null:
								await bot.move_element_to_slot(decision.targets[0], position)
						
						var positions: Array = bot.get_neighbor_empty_slot(decision.targets[0].grid_position)
						if positions.is_empty():
							return
						
						var element_A = await bot.create_element(bot.player.energy -1, positions[0])
						if element_A:
							await Gameplay.arena.link_elements(element_A, decision.targets[0])
					
					elif decision.targets.size() == 1 and decision.targets[0] is Molecule and bot.player.energy:
						var molecule: Molecule = decision.targets[0]
						for element in molecule.configuration:
							if not GameJudge.can_element_link(element):
								continue
							
							var empty_slots: Array = bot.get_neighbor_empty_slot(element.grid_position)
							if empty_slots.is_empty():
								continue
							
							var element_A: Element = await bot.create_element(bot.player.energy -1, empty_slots[0])
							if element_A:
								await GameJudge.make_full_link_elements(element_A, element)
								break
					
					elif (
							decision.targets.size() == 2 and decision.targets[0] is Element and
							decision.targets[1] is Element
					):
						for element in decision.targets:
							if not element is Element or not GameJudge.can_element_link(element):
								return
						
						var element_A: Element = decision.targets[0]
						var element_B: Element = decision.targets[1]
						
						if not GameJudge.is_positions_neighbor(element_A.grid_position, element_B.grid_position):
							for i in 2:
								var empty_slots: Array = bot.get_neighbor_empty_slot(decision.targets[i].grid_position)
								if empty_slots.is_empty():
									continue
									
								await bot.move_element_to_slot(decision.targets[(i + 1) % 2], empty_slots[0])
								break
						
						if GameJudge.is_positions_neighbor(element_A.grid_position, element_B.grid_position):
							await GameJudge.make_full_link_elements(element_A, element_B)
					
				BotChip.ActionTarget.MY_MOLECULE: 
					var molecule: Molecule = decision.targets[0]
					for element in molecule.configuration:
						if not GameJudge.can_element_link(element):
							continue
						
						var molecules_linked: bool
						
						var ally_slots: Array = bot.get_neighbor_allied_elements(element.grid_position)
						for position in ally_slots:
							var slot: ArenaSlot = Gameplay.arena.elements[position]
							
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
			pass


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

# ----------------------------------------------------------------------------------------------- #
# LOCKDOWN
# ----------------------------------------------------------------------------------------------- #
static func lockdown_aggressive(bot: Bot, analysis: BotChip.FieldAnalysis):
	if Gameplay.arena.turn_machine.turn_count == 0:
		return
	
	for molecule in analysis.my_molecules:
		var element: Element = GameJudge.get_powerful_element_in_molecule(molecule)
		
		if not GameJudge.can_element_attack(element):
			var list: Array =  GameJudge.get_active_elements_in_molecule(molecule)
			
			if list.is_empty():
				continue
			
			element = list[0]
		
		var slot: ArenaSlot = Gameplay.arena.elements[element.grid_position]
		if not slot.eletrons_charged:
			GameJudge.charge_eletrons_power(element, molecule)
			slot.eletrons_charged = true
		
		await insight_element_match_attack(element, analysis.rival_single_elements)
		
		bot.start(0.1)
		await bot.timeout
		
		if slot.can_act:
			await insight_molecule_match_attack(element, analysis.rival_molecules)
	
	for element in analysis.my_single_elements:
		if not is_instance_valid(element):
			continue
		
		await insight_element_match_attack(element, analysis.rival_single_elements)
		
		bot.start(0.2)
		await bot.timeout
		
		if Gameplay.arena.elements[element.grid_position].can_act:
			await insight_molecule_match_attack(element, analysis.rival_molecules)
		
	var can_direct_attack := true
	for rival_element in analysis.rival_single_elements:
		if is_instance_valid(rival_element):
			can_direct_attack = false
			break
	
	if can_direct_attack:
		for molecule in analysis.rival_molecules:
			if molecule:
				can_direct_attack = false
				break
	
	if can_direct_attack:
		for element in analysis.my_single_elements:
			await Gameplay.arena.direct_attack(element.grid_position)
	
	bot.start(0.3)
	await bot.timeout


static func lockdown_defensive(bot: Bot, analysis: BotChip.FieldAnalysis):
	for molecule in analysis.my_molecules:
		var element: Element = GameJudge.get_powerful_element_in_molecule(molecule)
		await insight_set_element_defende_mode(element)
		
		bot.start(0.1)
		await bot.timeout
	
	for element in analysis.my_single_elements:
		await insight_set_element_defende_mode(element)
		
		bot.start(0.1)
		await bot.timeout


static func lockdown_indecided(bot: Bot, analysis: BotChip.FieldAnalysis):
	await lockdown_aggressive(bot, analysis)
	
	bot.start(0.3)
	await bot.timeout
	
	await lockdown_defensive(bot, analysis)


static func lockdown_tatical(bot: Bot, analysis: BotChip.FieldAnalysis):
	pass
