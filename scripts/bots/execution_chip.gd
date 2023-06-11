class_name ExecutionChip extends RefCounted


static func execute_decision(bot: Bot, decision: Decision, decision_link_result: Array) -> Array:
	var energy: int = bot.player.energy
	var clear_slot := false
	var relink := false
	var forced := false
	
	for directive in decision.directive:
		if directive == Decision.Directive.MAX_ENERGY:
			energy = decision.directive[Decision.Directive.MAX_ENERGY]
	
	decision.is_completed = true
	
	match decision.action:
		Decision.Action.COOK:
			return await execute_cook(bot, decision, energy, decision_link_result)
		
		Decision.Action.CREATE:
			if energy < 1:
				return []
			
			if decision.action_target == Decision.ActionTarget.MY_ELEMENT:
				if not decision.extra_args.is_empty():
					return await bot.create_element(energy, decision.extra_args[0])
				else:
					return await _create_handler(bot, energy)
				
			elif decision.action_target == Decision.ActionTarget.MY_MOLECULE:
				var _diff: int = energy % 2
				var max_atomic: int = (energy + _diff) / 2
				var min_atomic: int = (energy - _diff) / 2
				
				return await _create_molecule(bot, max_atomic -1, min_atomic -1)
		
		Decision.Action.DEFEND:
			pass
		
		Decision.Action.DESTROY:
			pass
		
		Decision.Action.MITIGATE:
			pass
		
		Decision.Action.MERGE:
			if decision.targets.is_empty():
				return []

			match decision.action_target:
				Decision.ActionTarget.MY_ELEMENT:
					_merge_element(bot, decision, energy, decision_link_result)

				Decision.ActionTarget.MY_MOLECULE:
					var molecule_match: Molecule

					for variant in decision.targets:
						if variant is Molecule:
							molecule_match = variant
							return await _merge_molecules(bot, variant)

						if variant is Element:
							var element_slot: ArenaSlot = Arena.elements[variant.grid_position]
							var ally_slots: Array = bot.get_neighbor_allied_elements(variant.grid_position)
							for position in ally_slots:
								var slot: ArenaSlot = Arena.get_slot(position)

								if slot.molecule != element_slot.molecule and GameJudge.can_element_link(slot.element):
									await GameJudge.make_full_link_elements(variant, slot.element)
									return [true]
	return []


static func execute_cook(bot: Bot, decision: Decision, energy: int, decision_link_result: Array) -> Array:
	var is_forced: bool
	var prev_position: Array[Vector2i]
	var success: bool
	
	for d in decision.directive:
		if d == Decision.Directive.FORCED:
			is_forced = true

		elif d == Decision.Directive.CLEAR_SLOT:
			var reactor_slots := [0, 1, 2, 3]

			if not decision.extra_args.is_empty():
				for tag in decision.extra_args as Array[Decision.Tags]:
					if tag == Decision.Tags.FUSION:
						reactor_slots.resize(2)

					elif tag == Decision.Tags.ACCELR:
						reactor_slots.pop_front()
						reactor_slots.pop_front()

			for i in reactor_slots:
				if Gameplay.arena._check_slot_empty(GameJudge.REACTOR_POSITIONS[i]):
					await bot.move_element_to_ramdom_slot(Arena.elements[GameJudge.REACTOR_POSITIONS[i]])
					bot.start(0.2)
					await bot.timeout

	if not decision.extra_args.is_empty():
		prev_position = decision.extra_args
	
	if decision.targets.size() == 2:
		if is_forced:
			for i in decision.targets.size():
				if not Gameplay.arena._check_slot_empty(prev_position[i]):
					await bot.move_element_to_ramdom_slot(Arena.elements[prev_position[i]])

				await bot.move_element_to_slot(decision.targets[i], prev_position[i])
				bot.start(0.2)
				await bot.timeout
			return [true]
		else:
			for slot_a in [0, 2]:
				if success:
					break
				
				if not Gameplay.arena._check_slot_empty(GameJudge.REACTOR_POSITIONS[slot_a]):
					continue
				
				for slot_b in [1, 3]:
					if not Gameplay.arena._check_slot_empty(GameJudge.REACTOR_POSITIONS[slot_b]):
						continue
					
					await bot.move_element_to_slot(decision.targets[0], GameJudge.REACTOR_POSITIONS[slot_a])
					await bot.move_element_to_slot(decision.targets[1], GameJudge.REACTOR_POSITIONS[slot_b])
					success = true
					break
	
	if not decision_link_result.is_empty():
		for i in decision_link_result.size():
			if is_forced:
				if not Gameplay.arena._check_slot_empty(prev_position[i]):
					await bot.move_element_to_ramdom_slot(Arena.elements[prev_position[i]])
				await bot.move_element_to_slot(decision_link_result[i], prev_position[i])
				prev_position.erase(prev_position[i])

			else:
				for slot in 4:
					if not Gameplay.arena._check_slot_empty(GameJudge.REACTOR_POSITIONS[slot]):
						continue
			
					await bot.move_element_to_slot(decision_link_result[i], GameJudge.REACTOR_POSITIONS[slot])
					break
			
			bot.start(0.2)
			await bot.timeout
			success = true
	
	if decision.targets.size() == 1:
		if is_forced:
			if not Gameplay.arena._check_slot_empty(prev_position[0]):
				await bot.move_element_to_ramdom_slot(Arena.elements[prev_position[0]])
			await bot.move_element_to_slot(decision.targets[0], prev_position[0])
			return [true]
		
		for i in 4:
			if not Gameplay.arena._check_slot_empty(GameJudge.REACTOR_POSITIONS[i]):
				continue
			await bot.move_element_to_slot(decision.targets[0], GameJudge.REACTOR_POSITIONS[i])
			return [true]
	return [success]


static func _create_handler(bot: Bot, energy: int) -> Array:
	match energy:
		3:
			await _create_element_random_position(bot, 0)
			
			var positions: Array = bot.get_slots_nearly(2)
			if positions.is_empty():
				return []
			
			var element_A: Element = await bot.create_element(0, positions[0])
			if not element_A:
				return []
			
			var element_B: Element = await bot.create_element(0, positions[1])
			if element_B:
				await GameJudge.make_full_link_elements(element_A, element_B)
				return [element_A, element_B]
		4: 
			return await _create_element_random_position(bot, 3)
		6:
			var positions: Array = bot.get_slots_nearly(3)
			if positions.is_empty():
				return []
			
			var element_A: Element = await bot.create_element(3, positions[0])
			if not element_A:
				return []
			
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
			var positions: Array = bot.get_slots_nearly(4)
			if positions.is_empty():
				return []
			
			var element_A: Element = await bot.create_element(4, positions[0])
			if not element_A:
				return []
			
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
			return await _create_molecule(bot, 0, 0)
	return []


static func _create_element_random_position(bot: Bot, atomic_number: int) -> Array:
	var position = bot.get_empty_slot()
	if position == null:
		return []
	
	return [await bot.create_element(atomic_number, position)]


static func _create_molecule(bot: Bot, atomic_number_1: int, atomic_number_2: int) -> Array:
	var position1 = bot.get_empty_slot()
	if position1 == null:
		return []
	
	var positions: Array = bot.get_neighbor_empty_slot(position1)
	if positions.is_empty():
		return []
	
	var element_A: Element = await bot.create_element(atomic_number_1, position1)
	var element_B: Element = await bot.create_element(atomic_number_2, positions[0])
	
	if element_A and element_B:
		await GameJudge.make_full_link_elements(element_A, element_B)
		return [element_A, element_B]
	return []


static func _merge_element(bot: Bot, decision: Decision, energy: int, decision_link_result: Array) -> Array:
	if decision.targets.size() == 2:
		if decision.targets[0] is Element and decision.targets[1] is Element:
			return await _merge_element_to_element(bot, decision.targets[0], decision.targets[1])
		
		elif decision.targets[0] is Molecule and decision.targets[1] is Element:
			return await _merge_molecule_element(bot, decision.targets[0], decision.targets[1])
	
	if decision.targets.is_empty() or decision_link_result.is_empty():
		return []
	
	if decision.targets[0] is Element and GameJudge.can_element_link(decision.targets[0]):
		return await _merge_element_to_element(bot, decision.targets[0], decision_link_result[0])
		
	elif decision.targets[0] is Molecule:
		return await _merge_molecule_element(bot, decision.targets[0], decision_link_result[0])
	return []


static func _merge_molecules(bot: Bot, molecule: Molecule) -> Array:
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
	return [sucess]


static func _merge_molecule_element(bot: Bot, molecule: Molecule, element_target: Element) -> Array:
	for element in molecule.configuration:
		if not GameJudge.can_element_link(element):
			continue
		
		var positions: Array = bot.get_neighbor_empty_slot(element.grid_position)
		if positions.is_empty():
			continue
		
		await bot.move_element_to_slot(element_target, positions[0])
		await GameJudge.make_full_link_elements(element_target, element)
		return [true]
	return []


static func _merge_element_to_element(bot: Bot, element_A: Element, element_B: Element) -> Array:
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
	return []




