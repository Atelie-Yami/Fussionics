extends ChipSet


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
		
		if Arena.get_slot(element.grid_position).can_act:
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

