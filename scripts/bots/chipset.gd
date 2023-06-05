class_name ChipSet extends RefCounted

static func get_modus(_analysis: BotChip.FieldAnalysis) -> Bot.ModusOperandi:
	return Bot.ModusOperandi.UNDECIDED


static func execute(bot: Bot, desicions: Array[BotChip.Decision]):
	pass


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
