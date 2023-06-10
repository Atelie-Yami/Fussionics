class_name AmethistChipSet extends ChipSet


static func get_modus(_analysis: BotChip.FieldAnalysis) -> Bot.ModusOperandi:
	if _analysis.rival_single_elements.is_empty() and _analysis.rival_molecules.is_empty():
		return Bot.ModusOperandi.AGGRESSIVE
	
	if (
			(_analysis.my_single_elements.is_empty() and _analysis.my_molecules.is_empty()) and
		not (_analysis.rival_single_elements.is_empty() or _analysis.rival_molecules.is_empty())
	):
		return Bot.ModusOperandi.DEFENSIVE
	
	if _analysis.my_molecules.is_empty():
		return Bot.ModusOperandi.STRATEGICAL_DEFENSIVE
	
	if _analysis.rival_molecules.is_empty():
		return Bot.ModusOperandi.STRATEGICAL_AGGRESSIVE
	
	return Bot.ModusOperandi.UNDECIDED


static func defensive(bot: Bot, analysis: BotChip.FieldAnalysis):
	var decision_list: Array[Decision]
	
	if analysis.my_molecules.size() > 0:
		var sucess: bool
		for d in Decision.create_element_merge_molecule(analysis.my_molecules[0]):
			decision_list.append(d)
			sucess = true
		
		if sucess:
			analysis.my_molecules.erase(analysis.my_molecules[0])
	
	if analysis.my_single_elements.size() == 1:
		var decision_link := Decision.create_element()
		decision_link.is_decision_linked = true
		decision_list.append(decision_link)
		
		var decision := Decision.new()
		decision.decision_link = decision_link
		decision.action = Decision.Action.COOK
		decision.action_target = Decision.ActionTarget.MY_ELEMENT
		decision.targets = [analysis.my_single_elements[0]]
		decision_list.append(decision)
		
		analysis.my_single_elements.erase(analysis.my_single_elements[0])
	
	if bot.player.energy > 5:
		decision_list.append(Decision.create_molecule())
	else:
		decision_list.append(Decision.create_element())
	return decision_list


static func aggressive(bot: Bot, analysis: BotChip.FieldAnalysis):
	var decision_list: Array[Decision]
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
		for d in Decision.create_element_merge_molecule(best_match):
			decision_list.append(d)
		analysis.my_molecules.erase(best_match)
	
	elif bot.player.energy > 6:
		decision_list.append(Decision.create_molecule())
	else:
		decision_list.append(Decision.create_element())
	return decision_list


static func tatical_aggressive(bot: Bot, analysis: BotChip.FieldAnalysis):
	var result: Array = insight_get_best_match_molecule(analysis.my_molecules)
	var decision_list: Array[Decision]
	var best_match_molecule: Molecule = result[0]
	var opening_list: Array[Element]
	
	if best_match_molecule:
		opening_list = insight_molecule_get_opening_elements(best_match_molecule)
	
	if opening_list.is_empty():
		return aggressive(bot, analysis)
	
	analysis.my_molecules.erase(best_match_molecule)
	
	if opening_list.size() > 2 and bot.player.energy > 7:
		var strip = max(int(bot.player.energy / opening_list.size()), 1)
		
		for e in opening_list:
			var d := Decision.create_element()
			decision_list.append(d)
			d.directive[Decision.Directive.MAX_ENERGY] = strip
			
			var decision := Decision.new()
			decision.decision_link = d
			decision.action_target = Decision.ActionTarget.MY_ELEMENT
			decision.action = Decision.Action.MERGE
			decision.targets = [opening_list]
			decision_list.append(decision)
	else:
		for d in Decision.create_element_merge_molecule(best_match_molecule):
			decision_list.append(d)
	
	return decision_list


static func tatical_defensive(bot: Bot, analysis: BotChip.FieldAnalysis):
	var result: Array = insight_get_best_match_molecule(analysis.my_molecules)
	var decision_list: Array[Decision]
	var best_match_molecule: Molecule = result[0]
	var best_match_header: Element = result[1]
	var opening_list: Array[Element]
	
	if best_match_molecule:
		opening_list = insight_molecule_get_opening_elements(best_match_molecule)
		analysis.my_molecules.erase(best_match_molecule)
	
	for molecule in opening_list:
		if molecule != best_match_molecule:
			continue
		
		if best_match_header and GameJudge.can_element_link(best_match_header):
			pass # decision_list.append(insight_potentialize_element(best_match_header))
		
		for d in Decision.create_element_merge_molecule(best_match_molecule):
			decision_list.append(d)
		return decision_list
	
	if opening_list.is_empty():
		return defensive(bot, analysis)
	
	var strip = max(int(bot.player.energy / opening_list.size()), 1)
	
	for e in opening_list:
		var d := Decision.create_element()
		decision_list.append(d)
		d.directive[Decision.Directive.MAX_ENERGY] = strip
		
		var decision := Decision.new()
		decision.decision_link = d
		decision.action_target = Decision.ActionTarget.MY_ELEMENT
		decision.action = Decision.Action.MERGE
		decision.targets = [opening_list]
		
		decision_list.append(decision)
	
	return decision_list


static func indecided(bot: Bot, analysis: BotChip.FieldAnalysis):
	var decision_list: Array[Decision]
	
	if analysis.my_molecules.size() == 1:
		var sucess: bool
		for d in Decision.create_element_merge_molecule(analysis.my_molecules[0]):
			decision_list.append(d)
			sucess = true
		if sucess:
			analysis.my_molecules.erase(analysis.my_molecules[0])
	
	elif analysis.my_molecules.size() > 1:
		var d := Decision.new()
		decision_list.append(d)
		
		d.action_target = Decision.ActionTarget.MY_MOLECULE
		d.action = Decision.Action.MERGE
		
		for m in analysis.my_molecules:
			if GameJudge.is_molecule_opened(m):
				d.targets.append(m)
		
		for m in d.targets:
			analysis.my_molecules.erase(m)
	
	if analysis.my_single_elements.is_empty():
		if bot.player.energy > 8:
			decision_list.append(Decision.create_molecule())
		else:
			decision_list.append(Decision.create_element())
	
	elif analysis.my_single_elements.size() == 1:
		var d := Decision.new()
		decision_list.append(d)
		
		d.action_target = Decision.ActionTarget.MY_ELEMENT
		d.targets = [analysis.my_single_elements[0]]
		
		if analysis.my_single_elements[0].atomic_number < 4:
			d.action = Decision.Action.COOK
		else:
			d.action = Decision.Action.MERGE
		
		analysis.my_single_elements.erase(analysis.my_single_elements[0])
	
	else:
		var match_element: Element
		var sucess_list: Array[Element]
		
		for e in analysis.my_single_elements:
			if not GameJudge.can_element_link(e):
				for i in 4:
					if Arena.elements.has(GameJudge.REACTOR_POSITIONS[i]):
						continue
					
					var d := Decision.new()
					decision_list.append(d)
					
					d.action_target = Decision.ActionTarget.MY_ELEMENT
					d.action = Decision.Action.COOK
					d.targets = [e]
					break
				continue
			
			if not match_element:
				match_element = e
				continue
			
			var d := Decision.new()
			decision_list.append(d)
			
			d.action_target = Decision.ActionTarget.MY_ELEMENT
			d.targets = [e, match_element]
			d.action = Decision.Action.MERGE
			
			sucess_list.append(e)
		
		for e in sucess_list:
			analysis.my_single_elements.erase(e)
	
	return decision_list


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
		
		var slot: ArenaSlot = Arena.get_slot(element.grid_position)
		if not slot.eletrons_charged:
			GameJudge.charge_eletrons_power(element, molecule)
			slot.eletrons_charged = true
		
		await insight_element_match_attack(bot, element, analysis.rival_single_elements)
		
		bot.start(0.1)
		await bot.timeout
		
		if slot.can_act:
			await insight_molecule_match_attack(bot, element, analysis.rival_molecules)
	
	for element in analysis.my_single_elements:
		if not is_instance_valid(element):
			continue
		
		await insight_element_match_attack(bot, element, analysis.rival_single_elements)
		
		bot.start(0.2)
		await bot.timeout
		
		if Arena.get_slot(element.grid_position).can_act:
			await insight_molecule_match_attack(bot, element, analysis.rival_molecules)
		
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
		await bot.set_defende_mode(element)
		
		bot.start(0.1)
		await bot.timeout
	
	for element in analysis.my_single_elements:
		await bot.set_defende_mode(element)
		
		bot.start(0.1)
		await bot.timeout


static func lockdown_indecided(bot: Bot, analysis: BotChip.FieldAnalysis):
	await lockdown_aggressive(bot, analysis)
	
	bot.start(0.3)
	await bot.timeout
	
	await lockdown_defensive(bot, analysis)


static func lockdown_tatical(bot: Bot, analysis: BotChip.FieldAnalysis):
	await lockdown_defensive(bot, analysis)
	
	bot.start(0.3)
	await bot.timeout
	
	var my_best_element: Element
	var rival_best_element: Element
	
	for molecule in analysis.my_molecules:
		var my_element: Element = GameJudge.get_powerful_element_in_molecule(molecule)
		
		if not my_best_element:
			my_best_element = my_element
			continue
		
		if my_element.atomic_number > my_best_element.atomic_number:
			my_best_element = my_element
		
		
	for rival_molecule in analysis.rival_molecules:
		var rival_element: Element = GameJudge.get_powerful_element_in_molecule(rival_molecule)
		
		if not rival_best_element:
			rival_best_element = rival_element
			continue
		
		if rival_element.atomic_number > rival_best_element.atomic_number:
			rival_best_element = rival_element
	
	if not my_best_element or not rival_best_element:
		return
	
	if my_best_element.atomic_number > rival_best_element.atomic_number:
		await lockdown_aggressive(bot, analysis)
