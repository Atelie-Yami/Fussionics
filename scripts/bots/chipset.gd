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
