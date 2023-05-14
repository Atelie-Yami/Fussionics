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
static func insight_element_merge_molecule(molecule: Molecule):
	var decision := BotChip.Decision.new()
	decision.action_target = BotChip.ActionTarget.MY_ELEMENT ## tag MY_ELEMENT define que é sobre um elemento solto
	decision.action = BotChip.Action.MERGE ## tag MERGE vai unir o novo elemento na molecula
	decision.targets = [molecule]
	return decision


static func insight_create_molecule():
	var decision := BotChip.Decision.new()
	decision.action_target = BotChip.ActionTarget.MY_MOLECULE
	decision.action = BotChip.Action.CREATE
	return decision


static func insight_create_element():
	var decision := BotChip.Decision.new()
	decision.action_target = BotChip.ActionTarget.MY_ELEMENT
	decision.action = BotChip.Action.CREATE
	return decision


static func insight_get_slots_nearly(bot: Bot, slots_count: int):
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


static func insight_element_match_attack(element: Element, targets: Array[Element]):
	for rival_element in targets:
		var rival_slot: ArenaSlot = Gameplay.arena.elements[rival_element.grid_position]
		if (
				GameJudge.combat_check_result(
						element, rival_element, rival_slot.defend_mode
				) == GameJudge.Result.WINNER
		):
			await Gameplay.arena.attack_element(element.grid_position, rival_element.grid_position)
			return


static func insight_molecule_match_attack(element: Element, targets: Array[Molecule]):
	for rival_molecules in targets:
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
					element.grid_position, weak_element.grid_position
			)
			continue
