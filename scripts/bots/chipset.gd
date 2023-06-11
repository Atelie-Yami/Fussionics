class_name ChipSet extends RefCounted

static func get_modus(_analysis: FieldAnalysis) -> Bot.ModusOperandi:
	return Bot.ModusOperandi.UNDECIDED

# ----------------------------------------------------------------------------------------------- #
# MODUS
# ----------------------------------------------------------------------------------------------- #
static func aggressive(bot: Bot, analysis: FieldAnalysis):
	var decision_list: Array[Decision]
	return decision_list
static func defensive(bot: Bot, analysis: FieldAnalysis):
	var decision_list: Array[Decision]
	return decision_list
static func indecided(bot: Bot, analysis: FieldAnalysis):
	var decision_list: Array[Decision]
	return decision_list
static func tatical_aggressive(bot: Bot, analysis: FieldAnalysis):
	var decision_list: Array[Decision]
	return decision_list
static func tatical_defensive(bot: Bot, analysis: FieldAnalysis):
	var decision_list: Array[Decision]
	return decision_list

# ----------------------------------------------------------------------------------------------- #
# LOCKDOWN
# ----------------------------------------------------------------------------------------------- #
static func lockdown_aggressive(bot: Bot, analysis: FieldAnalysis):
	pass
static func lockdown_defensive(bot: Bot, analysis: FieldAnalysis):
	pass
static func lockdown_indecided(bot: Bot, analysis: FieldAnalysis):
	pass
static func lockdown_tatical(bot: Bot, analysis: FieldAnalysis):
	pass


# ----------------------------------------------------------------------------------------------- #
# INSIGHTS
# ----------------------------------------------------------------------------------------------- #
static func insight_element_match_attack(bot: Bot, element: Element, targets: Array[Element]):
	for element_rival in targets:
		var rival_slot: ArenaSlot = Arena.elements[element_rival.grid_position]
		if await bot.attack(element, element_rival, rival_slot.defend_mode):
			targets.erase(element_rival)
			return


static func insight_molecule_match_attack(bot: Bot, element: Element, targets: Array[Molecule]):
	for rival_molecules in targets:
		if rival_molecules.defender:
			var rival_slot: ArenaSlot = Arena.elements[rival_molecules.defender.grid_position]
			await bot.attack(element, rival_molecules.defender, rival_slot.defend_mode)
		else:
			var rival_element := GameJudge.get_weak_element_molecule(rival_molecules)
			var rival_slot: ArenaSlot = Arena.elements[rival_element.grid_position]
			await bot.attack(element, rival_element, rival_slot.defend_mode)


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
