class_name ChipSet extends RefCounted

static func get_modus(_analysis: BotChip.FieldAnalysis) -> Bot.ModusOperandi:
	return Bot.ModusOperandi.UNDECIDED

# ----------------------------------------------------------------------------------------------- #
# MODUS
# ----------------------------------------------------------------------------------------------- #
static func aggressive(bot: Bot, analysis: BotChip.FieldAnalysis):
	var decision_list: Array[BotChip.Decision]
	return decision_list
static func defensive(bot: Bot, analysis: BotChip.FieldAnalysis):
	var decision_list: Array[BotChip.Decision]
	return decision_list
static func indecided(bot: Bot, analysis: BotChip.FieldAnalysis):
	var decision_list: Array[BotChip.Decision]
	return decision_list
static func tatical_aggressive(bot: Bot, analysis: BotChip.FieldAnalysis):
	var decision_list: Array[BotChip.Decision]
	return decision_list
static func tatical_defensive(bot: Bot, analysis: BotChip.FieldAnalysis):
	var decision_list: Array[BotChip.Decision]
	return decision_list

# ----------------------------------------------------------------------------------------------- #
# EXECUTE
# ----------------------------------------------------------------------------------------------- #
static func execute_decision(bot: Bot, decision: BotChip.Decision, decision_link_result = null):
	var energy: int = bot.player.energy
	var clear_slot := false
	var relink := false
	var forced := false
	
	for directive in decision.directive:
		match directive:
			BotChip.Directive.MAX_ENERGY:
				energy = decision.directive[BotChip.Directive.MAX_ENERGY]
	
			BotChip.Directive.CLEAR_SLOT:
				clear_slot = true
			
			BotChip.Directive.FORCED:
				forced = true
				
			BotChip.Directive.RELINK:
				relink = true
	
	decision.is_completed = true
	
	match decision.action:
		BotChip.Action.COOK:
			return await execute_cook(bot, decision, energy, decision_link_result)
		
		BotChip.Action.CREATE:
			if not energy:
				return
			
			if decision.action_target == BotChip.ActionTarget.MY_ELEMENT:
				if decision_link_result is Vector3:
					return await bot.create_element(energy, decision_link_result)
				else:
					return await execute_create_handler(bot, energy)
				
			elif decision.action_target == BotChip.ActionTarget.MY_MOLECULE:
				var _diff: int = energy % 2
				var max_atomic: int = (energy + _diff) / 2
				var min_atomic: int = (energy - _diff) / 2
				
				return await execute_create_molecule(bot, max_atomic -1, min_atomic -1)
		
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
						
						return await execute_merge_element_to_element(bot, decision.targets[0], decision.targets[1])
					
					if not bot.player.energy or decision.targets.size() != 1:
						return
					
					if decision.targets[0] is Element and GameJudge.can_element_link(decision.targets[0]):
						return await execute_merge_element_new_element(bot, decision.targets[0], energy)
					
					elif decision.targets[0] is Molecule:
						return await execute_merge_molecule_new_element(bot, decision.targets[0], energy)
				
				BotChip.ActionTarget.MY_MOLECULE:
					var molecule_match: Molecule
					
					for variant in decision.targets:
						if variant is Molecule:
							molecule_match = variant
							return await execute_merge_molecules(bot, variant)
						
						if variant is Element:
							var element_slot: ArenaSlot = Arena.elements[variant.grid_position]
							var ally_slots: Array = bot.get_neighbor_allied_elements(variant.grid_position)
							for position in ally_slots:
								var slot: ArenaSlot = Arena.get_slot(position)
								
								if slot.molecule != element_slot.molecule and GameJudge.can_element_link(slot.element):
									await GameJudge.make_full_link_elements(variant, slot.element)
									return true
		
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


static func execute_cook(bot: Bot, decision: BotChip.Decision, energy: int, decision_link_result = null):
	var reactor_selector: int = bot.get_reactor_empty()
	var success: bool
	
	if decision_link_result != null:
		for element in decision_link_result as Array[Element]:
			for i in 4:
				Gameplay.arena._check_slot_empty(GameJudge.REACTOR_POSITIONS[i])
				await bot.move_element_to_slot(element, GameJudge.REACTOR_POSITIONS[i])
				bot.start(0.2)
				await bot.timeout
		success = true
	
	if decision.targets.size() == 1:
		await bot.move_element_to_slot(decision.targets[0], Vector2i(9, 4 if reactor_selector else 0))
		bot.start(0.2)
		await bot.timeout
		return true
	
	if decision.targets.size() == 2:
		if reactor_selector == -1: # sem slot reactor disponivel
			if (
					not Gameplay.arena._check_slot_empty(GameJudge.REACTOR_POSITIONS[0]) and
					Gameplay.arena._check_slot_empty(GameJudge.REACTOR_POSITIONS[1])
			):
				var e: Element = Gameplay.arena.elements[GameJudge.REACTOR_POSITIONS[0]]
				var pos = bot.get_empty_slot()
				if not pos:
					return false
				
				await bot.move_element_to_slot(e, pos)
			
		for i in decision.targets.size():
			await bot.move_element_to_slot(decision.targets[i], Vector2i(9 + (i * 2), 4 if reactor_selector else 0))
			bot.start(0.2)
			await bot.timeout
		return true
	
	return success


static func execute_create_handler(bot: Bot, energy: int):
	match energy:
		3:
			await execute_create_element_random_position(bot, 0)
			
			var positions: Array = insight_get_slots_nearly(bot, 2)
			if positions.is_empty():
				return
			
			var element_A: Element = await bot.create_element(0, positions[0])
			if not element_A:
				return
			
			var element_B: Element = await bot.create_element(0, positions[1])
			if element_B:
				await GameJudge.make_full_link_elements(element_A, element_B)
				return [element_A, element_B]
		4: 
			return await execute_create_element_random_position(bot, 3)
		6:
			var positions: Array = insight_get_slots_nearly(bot, 3)
			if positions.is_empty():
				return
			
			var element_A: Element = await bot.create_element(3, positions[0])
			if not element_A:
				return
			
			var element_B: Element = await bot.create_element(0, positions[1])
			if not element_B:
				return [element_A]
			
			await GameJudge.make_full_link_elements(element_A, element_B)
			
			var element_C: Element = await bot.create_element(0, positions[2])
			if not element_C:
				return [element_A, element_B]
		
			await GameJudge.make_full_link_elements(element_A, element_C)
			
			return [element_A, element_B, element_C]
		7:
			var positions: Array = insight_get_slots_nearly(bot, 4)
			if positions.is_empty():
				return
			
			var element_A: Element = await bot.create_element(4, positions[0])
			if not element_A:
				return
			
			var element_B: Element = await bot.create_element(0, positions[1])
			if not element_B:
				return [element_A]
			await GameJudge.make_full_link_elements(element_A, element_B)
			
			var element_C: Element = await bot.create_element(0, positions[2])
			if not element_C:
				return [element_A, element_B]
			await GameJudge.make_full_link_elements(element_A, element_C)
			
			var element_D: Element = await bot.create_element(0, positions[3])
			if not element_D:
				return [element_A, element_B, element_C]
			await GameJudge.make_full_link_elements(element_A, element_D)
			
			return [element_A, element_B, element_C, element_D]
		_:
			return await execute_create_molecule(bot, 0, 0)


static func execute_create_element_random_position(bot: Bot, atomic_number: int):
	var position = bot.get_empty_slot()
	if position == null:
		return
	
	return await bot.create_element(atomic_number, position)


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
		return [element_A, element_B]


static func execute_merge_molecules(bot: Bot, molecule: Molecule):
	var sucess: bool
	for element in molecule.configuration:
		if not GameJudge.can_element_link(element):
			continue
		
		var ally_slots: Array = bot.get_neighbor_allied_elements(element.grid_position)
		for position in ally_slots:
			var slot: ArenaSlot = Arena.get_slot(position)
			
			if slot.molecule == molecule or not GameJudge.can_element_link(slot.element):
				continue
			
			await GameJudge.make_full_link_elements(element, slot.element)
			sucess = true
			break
	return sucess


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
		return [element_A]


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
		
		return [element_A, element_B]


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
			return [element_A]


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


# ----------------------------------------------------------------------------------------------- #
# LOCKDOWN
# ----------------------------------------------------------------------------------------------- #
static func lockdown_aggressive(bot: Bot, analysis: BotChip.FieldAnalysis):
	pass
static func lockdown_defensive(bot: Bot, analysis: BotChip.FieldAnalysis):
	pass
static func lockdown_indecided(bot: Bot, analysis: BotChip.FieldAnalysis):
	pass
static func lockdown_tatical(bot: Bot, analysis: BotChip.FieldAnalysis):
	pass


# ----------------------------------------------------------------------------------------------- #
# INSIGHTS
# ----------------------------------------------------------------------------------------------- #
static func insight_create_element_merge_molecule(molecule: Molecule) -> BotChip.Decision:
	var decision := BotChip.Decision.new()
	decision.action_target = BotChip.ActionTarget.MY_ELEMENT ## tag MY_ELEMENT define que é sobre um elemento solto
	decision.action = BotChip.Action.MERGE ## tag MERGE vai unir o novo elemento na molecula
	decision.targets = [molecule]
	return decision


static func insight_create_molecule() -> BotChip.Decision:
	var decision := BotChip.Decision.new()
	decision.action_target = BotChip.ActionTarget.MY_MOLECULE
	decision.action = BotChip.Action.CREATE
	return decision


static func insight_create_element() -> BotChip.Decision:
	var decision := BotChip.Decision.new()
	decision.action_target = BotChip.ActionTarget.MY_ELEMENT
	decision.action = BotChip.Action.CREATE
	return decision


static func insight_potentialize_element(element_pivot: Element) -> BotChip.Decision:
	var decision := BotChip.Decision.new()
	decision.action_target = BotChip.ActionTarget.MY_ELEMENT
	decision.action = BotChip.Action.POTENTIALIZE
	decision.targets = [element_pivot]
	return decision


static func insight_get_slots_nearly(bot: Bot, slots_count: int) -> Array:
	var positions: Array
	
	var count := Bot.MAX_SEARCH_TEST
	while count > 0:
		count -= 1
	
		var position1 = bot.get_empty_slot()
		if position1 == null:
			continue
		
		positions = bot.get_neighbor_empty_slot(position1)
		if positions.size() > (slots_count - 2):
			positions.push_front(position1)
			break
	
	return positions


static func insight_combat_element_attack(element: Element, target: Element, defend_mode: bool) -> bool:
	if GameJudge.combat_check_result(element, target, defend_mode) == GameJudge.Result.WINNER:
		await Gameplay.arena.attack_element(element.grid_position, target.grid_position)
		return true
	return false


static func insight_element_match_attack(element: Element, targets: Array[Element]):
	for element_rival in targets:
		var rival_slot: ArenaSlot = Arena.elements[element_rival.grid_position]
		if await insight_combat_element_attack(element, element_rival, rival_slot.defend_mode):
			targets.erase(element_rival)
			return


static func insight_molecule_match_attack(element: Element, targets: Array[Molecule]):
	for rival_molecules in targets:
		if rival_molecules.defender:
			var rival_slot: ArenaSlot = Arena.elements[rival_molecules.defender.grid_position]
			await insight_combat_element_attack(element, rival_molecules.defender, rival_slot.defend_mode)
		else:
			var rival_element := GameJudge.get_weak_element_molecule(rival_molecules)
			var rival_slot: ArenaSlot = Arena.elements[rival_element.grid_position]
			await insight_combat_element_attack(element, rival_element, rival_slot.defend_mode)


static func insight_set_element_defende_mode(element: Element):
	var slot: ArenaSlot = Arena.elements[element.grid_position]
	if not slot.eletrons_charged:
		await Gameplay.arena.defend_mode(element.grid_position)


static func insight_molecule_get_opening_elements(molecule: Molecule) -> Array[Element]:
	var opening_list: Array[Element]
	for e in molecule.configuration:
		if e.number_electrons_in_valencia == 0:
			continue
		
		for link in e.links:
			if not e.links[link]:
				opening_list.append(e)
				break
		
	return opening_list


static func insight_get_best_match_molecule(molecules: Array[Molecule]):
	var best_match_molecule: Molecule
	var best_match_header: Element
	var best_match_power: int
	
	for m in molecules:
		if not best_match_molecule:
			best_match_molecule = m
			continue
		
		var power: int = GameJudge.calcule_max_molecule_eletrons_power(m)
		if power <= best_match_power:
			continue
		
		var element_header: Element = GameJudge.get_powerful_element_in_molecule(m)
		if best_match_header:
			if (
					(element_header.eletrons + element_header.valentia) <
					(best_match_header.eletrons + best_match_header.valentia)
			):
				continue
		
		best_match_molecule = m
		best_match_header = element_header
		best_match_power = power
	
	return [best_match_molecule, best_match_header]


static func insight_merge_my_single_elements(bot: Bot, elements: Array[Element]):
	if elements.is_empty() or elements.size() < 2:
		return
	
	elements.sort_custom(func(a, b): return a.valentia > b.valentia)
	await _recursive_insight_merge_my_single_elements(bot, elements)


static func _recursive_insight_merge_my_single_elements(bot: Bot, elements: Array[Element]):
	var element: Element = elements.pop_front()
	var element_list := elements.duplicate()
	
	if element_list.is_empty():
		return
	
	var positions: Array[Vector2i] = bot.get_neighbor_empty_slot(element.grid_position)
	if positions.is_empty():
		return
	
	var count: int = element_list.size() if element_list.size() < positions.size() else positions.size()
	for i in count:
		await bot.move_element_to_slot(element_list[i], positions[i])
		await Gameplay.arena.link_elements(element, element_list[i])
	
	if element_list.is_empty():
		return
	
	await _recursive_insight_merge_my_single_elements(bot, element_list)
