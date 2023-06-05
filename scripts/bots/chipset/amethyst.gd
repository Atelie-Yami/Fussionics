class_name AmethistChipSet extends "res://scripts/bots/chipset/amethyst_execute.gd"


static func get_modus(_analysis: BotChip.FieldAnalysis) -> Bot.ModusOperandi:
	if _analysis.rival_single_elements.is_empty() or _analysis.rival_molecules.is_empty():
		return Bot.ModusOperandi.AGGRESSIVE
	
	if (
			(_analysis.my_single_elements.is_empty() or _analysis.my_molecules.is_empty()) and
		not (_analysis.rival_single_elements.is_empty() or _analysis.rival_molecules.is_empty())
	):
		return Bot.ModusOperandi.DEFENSIVE
	
	if _analysis.my_molecules.is_empty():
		return Bot.ModusOperandi.STRATEGICAL_DEFENSIVE
	
	for m in _analysis.my_molecules:
		var power: int = GameJudge.calcule_max_molecule_eletrons_power(m)
		if power < 8 and GameJudge.is_molecule_opened(m):
			continue
		
		var best_match: Element
		for element in _analysis.rival_single_elements:
			if not best_match:
				best_match = element
				continue
			
			if element.eletrons < best_match.eletrons or element.neutrons < best_match.neutrons:
				best_match = element
		
		if best_match:
			return (
					Bot.ModusOperandi.STRATEGICAL_AGGRESSIVE if best_match.neutrons < power else
					Bot.ModusOperandi.STRATEGICAL_DEFENSIVE
			)
		
		elif _analysis.rival_molecules:
			for m_rival in _analysis.rival_molecules:
				var power2: int = GameJudge.calcule_max_molecule_eletrons_power(m_rival)
				return (
						Bot.ModusOperandi.STRATEGICAL_DEFENSIVE if power2 > power else
						Bot.ModusOperandi.STRATEGICAL_AGGRESSIVE
				)
	
	return Bot.ModusOperandi.UNDECIDED


static func defensive(bot: Bot, analysis: BotChip.FieldAnalysis):
	var decision_list: Array[BotChip.Decision]
	
	if analysis.my_molecules.size() > 0:
		decision_list.append(insight_create_element_merge_molecule(analysis.my_molecules[0]))
	
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
			decision_list.append(insight_create_element_merge_molecule(best_match))
	
	elif bot.player.energy > 6:
		decision_list.append(insight_create_molecule())
	else:
		decision_list.append(insight_create_element())
	
	return decision_list


static func indecided(bot: Bot, analysis: BotChip.FieldAnalysis):
	var decision_list: Array[BotChip.Decision]
	
	if analysis.my_molecules.size() == 1:
		decision_list.append(insight_create_element_merge_molecule(analysis.my_molecules[0]))
	
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


static func tatical_aggressive(bot: Bot, analysis: BotChip.FieldAnalysis):
	var result: Array = insight_get_best_match_molecule(analysis.my_molecules)
	var decision_list: Array[BotChip.Decision]
	var best_match_molecule: Molecule = result[0]
	var opening_list: Array[Element]
	
	if best_match_molecule:
		opening_list = insight_molecule_get_opening_elements(best_match_molecule)
	
	if opening_list.is_empty():
		return aggressive(bot, analysis)
	
	if opening_list.size() > 2 and bot.player.energy > 7:
		var strip = max(int(bot.player.energy / opening_list.size()), 1)
		
		for e in opening_list:
			var d := insight_potentialize_element(e)
			decision_list.append(d)
			d.directive = BotChip.Directive.MAX_ENERGY
			d.args = strip
	
	else:
		decision_list.append(insight_create_element_merge_molecule(best_match_molecule))
	
	return decision_list


static func tatical_defensive(bot: Bot, analysis: BotChip.FieldAnalysis):
	var result: Array = insight_get_best_match_molecule(analysis.my_molecules)
	var decision_list: Array[BotChip.Decision]
	var best_match_molecule: Molecule = result[0]
	var best_match_header: Element = result[1]
	var opening_list: Array[Element]
	
	if best_match_molecule:
		opening_list = insight_molecule_get_opening_elements(best_match_molecule)
	
	if opening_list.is_empty():
		return defensive(bot, analysis)
	
	for molecule in opening_list:
		if molecule != best_match_molecule:
			continue
		
		if best_match_header and GameJudge.can_element_link(best_match_header):
			decision_list.append(insight_potentialize_element(best_match_header))
		
		decision_list.append(insight_create_element_merge_molecule(best_match_molecule))
		return decision_list
	
	var strip = max(int(bot.player.energy / opening_list.size()), 1)
		
	for e in opening_list:
		var d := insight_potentialize_element(e)
		decision_list.append(d)
		d.directive = BotChip.Directive.MAX_ENERGY
		d.args = strip
	
	return decision_list

