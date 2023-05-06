class_name ChipSet extends RefCounted

static func get_modus(_analysis: BotChip.FieldAnalysis) -> Bot.ModusOperandi:
	return Bot.ModusOperandi.UNDECIDED


static func execute(bot: Bot, desicions: Array[BotChip.Decision]):
	pass


static func decision(bot: Bot, analysis: BotChip.FieldAnalysis, modus: Bot.ModusOperandi):
	var decision_list: Array[BotChip.Decision]
	return decision_list


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

