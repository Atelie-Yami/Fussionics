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
	
	elif bot.player.energy > 5:
		decision_list.append(insight_create_molecule())
	else:
		decision_list.append(insight_create_element())
	
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
		if bot.player.energy > 5:
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
		print(dsc.action)
		print(dsc.action_target)
		print(dsc.targets)
		await execute_decision(bot, dsc)


static func execute_decision(bot: Bot, decision: BotChip.Decision):
	if decision.decision_link:
		await execute_decision(bot, decision.decision_link)
	
	match decision.action:
		BotChip.Action.COOK:
			var reactor_selector: int = bot.get_reactor_empty()
			if reactor_selector == -1:
				decision.completed = true
				return
			
			if decision.targets.size() == 2 and decision.targets[0] is Element and decision.targets[1] is Element:
				for i in decision.targets.size():
					await bot.move_element_to_slot(decision.targets[i], Vector2i(9 + (i * 2), 4 if reactor_selector else 0))
					bot.start(0.2)
					await bot.timeout
					
			elif decision.targets.size() == 1:
				await bot.move_element_to_slot(decision.targets[0], Vector2i(9, 4 if reactor_selector else 0))
				bot.start(0.2)
				await bot.timeout
				await bot.create_element(bot.player.energy -1, Vector2i(11, 4 if reactor_selector else 0))
			
			decision.completed = true
		
		BotChip.Action.CREATE:
			if decision.action_target == BotChip.ActionTarget.MY_ELEMENT:
				var position  = bot.get_empty_slot()
				if position != null:
					bot.create_element(bot.player.energy -1, position)
				
			elif decision.action_target == BotChip.ActionTarget.MY_MOLECULE:
				await execute_create_molecule(bot)
			
			decision.completed = true
		
		BotChip.Action.DEFEND:
			pass
		
		BotChip.Action.DESTROY:
			pass
		
		BotChip.Action.MERGE:
			if decision.targets.is_empty():
				decision.completed = true
				return
			
			match decision.action_target:
				BotChip.ActionTarget.MY_ELEMENT:
					if (
							decision.targets.size() == 1 and decision.targets[0] is Element
							and GameJudge.can_element_link(decision.targets[0])
					):
						var positions: Array = bot.get_neighbor_allied_elements(decision.targets[0].grid_position)
						if positions.is_empty():
							decision.completed = true
							return
						
						var element_A = await bot.create_element(bot.player.energy -1, positions[0])
						if element_A:
							await Gameplay.arena.link_elements(element_A, decision.targets[0])
					
					elif decision.targets.size() == 1 and decision.targets[0] is Molecule:
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
								decision.completed = true
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
					
					decision.completed = true
					
				BotChip.ActionTarget.MY_MOLECULE:
					var molecule: Molecule = decision.targets[0]
					for element in molecule.configuration:
						if not GameJudge.can_element_link(element):
							continue
						
						var molecules_linked: bool
						
						var ally_slots: Array = bot.get_neighbor_allied_elements(element.grid_position)
						for e in ally_slots:
							var slot: ArenaSlot = Gameplay.arena.elements[e.grid_position]
							
							if slot.molecule == molecule or not GameJudge.can_element_link(e):
								continue
							
							await GameJudge.make_full_link_elements(element, e)
							molecules_linked = true
							break
						
						if molecules_linked:
							break
		
		BotChip.Action.MITIGATE:
			pass
		
		BotChip.Action.POTENTIALIZE:
			pass
	
	decision.completed = true


static func execute_create_molecule(bot: Bot):
	var position1 = bot.get_empty_slot()
	if position1 == null:
		return
	
	var positions: Array = bot.get_neighbor_empty_slot(position1)
	if positions.is_empty():
		return
	
	var _diff: int = bot.player.energy % 2
	var max_atomic: int = (bot.player.energy + _diff) / 2
	var min_atomic: int = (bot.player.energy - _diff) / 2
	print("max_atomic ", max_atomic)
	print("min_atomic ", min_atomic)
	
	var element_A: Element = await bot.create_element(max_atomic -1, position1)
	var element_B: Element = await bot.create_element(min_atomic -1, positions[0])
	
	if element_A and element_B:
		await GameJudge.make_full_link_elements(element_A, element_B)

# ----------------------------------------------------------------------------------------------- #
# LOCKDOWN
# ----------------------------------------------------------------------------------------------- #
static func lockdown_aggressive(bot: Bot, analysis: BotChip.FieldAnalysis):
	for molecule in analysis.my_molecules:
		var element: Element = GameJudge.get_powerful_element_in_molecule(molecule)
		
		if not GameJudge.can_element_attack(element):
			var list: Array =  GameJudge.get_active_elements_in_molecule(molecule)
			
			if list.is_empty():
				continue
			
			element = list[0]
		
		var slot: ArenaSlot = Gameplay.arena.elements[element.grid_position]
		GameJudge.charge_eletrons_power(element, molecule)
		slot.eletrons_charged = true
		
		for rival_element in analysis.rival_single_elements:
			var rival_slot: ArenaSlot = Gameplay.arena.elements[rival_element.grid_position]
			if (
					GameJudge.combat_check_result(
							element, rival_element, rival_slot.defend_mode
					) == GameJudge.Result.WINNER
			):
				await Gameplay.arena.attack_element(element.grid_position, rival_element.grid_position)
				break
		
		bot.start(0.1)
		await bot.timeout
		
		if slot.can_act:
			for rival_molecules in analysis.rival_molecules:
				if rival_molecules.defender:
					var rival_slot: ArenaSlot = Gameplay.arena.elements[rival_molecules.defender.grid_position]
					if (
							GameJudge.combat_check_result(
									element, rival_molecules.defender, rival_slot.defend_mode
							) == GameJudge.Result.WINNER
					):
						await Gameplay.arena.attack_element(
								element.grid_position, rival_molecules.defender.grid_position
						)
					continue
				
				var weak_element: Element = GameJudge.get_weak_element_molecule(rival_molecules)
				if (
						GameJudge.combat_check_result(
								element, rival_molecules.defender, false
						) == GameJudge.Result.WINNER
				):
					await Gameplay.arena.attack_element(
							element.grid_position, rival_molecules.defender.grid_position
					)
					continue
	
	for element in analysis.my_single_elements:
		var slot: ArenaSlot = Gameplay.arena.elements[element.grid_position]
		
		for rival_element in analysis.rival_single_elements:
			if not rival_element:
				continue
			
			var rival_slot: ArenaSlot = Gameplay.arena.elements[rival_element.grid_position]
			if (
					GameJudge.combat_check_result(
							element, rival_element, rival_slot.defend_mode
					) == GameJudge.Result.WINNER
			):
				await Gameplay.arena.attack_element(element.grid_position, rival_element.grid_position)
				break
		
		bot.start(0.2)
		await bot.timeout
		
		for rival_molecules in analysis.rival_molecules:
			if rival_molecules.defender:
				var rival_slot: ArenaSlot = Gameplay.arena.elements[rival_molecules.defender.grid_position]
				if (
						GameJudge.combat_check_result(
								element, rival_molecules.defender, rival_slot.defend_mode
						) == GameJudge.Result.WINNER
				):
					await Gameplay.arena.attack_element(
							element.grid_position, rival_molecules.defender.grid_position
					)
				continue
			
			var weak_element: Element = GameJudge.get_weak_element_molecule(rival_molecules)
			if (
					GameJudge.combat_check_result(
							element, weak_element, false
					) == GameJudge.Result.WINNER
			):
				await Gameplay.arena.attack_element(
						element.grid_position, rival_molecules.defender.grid_position
				)
				continue
	
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
		await Gameplay.arena.defend_mode(element.grid_position)
		
		bot.start(0.1)
		await bot.timeout
	
	for element in analysis.my_single_elements:
		await Gameplay.arena.defend_mode(element.grid_position)
		
		bot.start(0.1)
		await bot.timeout


static func lockdown_indecided(bot: Bot, analysis: BotChip.FieldAnalysis):
	pass


static func lockdown_tatical(bot: Bot, analysis: BotChip.FieldAnalysis):
	pass
