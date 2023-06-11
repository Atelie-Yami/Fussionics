extends BotChip


func get_modus(_analysis: FieldAnalysis) -> Bot.ModusOperandi:
	return AmethistChipSet.get_modus(_analysis)


func call_modus_action(modus: Bot.ModusOperandi, bot: Bot, _analysis: FieldAnalysis) -> Array[Decision]:
	match modus:
		Bot.ModusOperandi.AGGRESSIVE:
			return AmethistChipSet.aggressive(bot, _analysis)
		
		Bot.ModusOperandi.DEFENSIVE:
			return AmethistChipSet.defensive(bot, _analysis)
		
		Bot.ModusOperandi.STRATEGICAL_AGGRESSIVE:
			return AmethistChipSet.tatical_aggressive(bot, _analysis)
		
		Bot.ModusOperandi.STRATEGICAL_DEFENSIVE:
			return AmethistChipSet.tatical_defensive(bot, _analysis)
		
		Bot.ModusOperandi.UNDECIDED:
			return AmethistChipSet.indecided(bot, _analysis)
	
	var ops: Array[Decision]
	return ops


func lockdown(bot: Bot, analysis: FieldAnalysis, modus: Bot.ModusOperandi):
	match modus:
		Bot.ModusOperandi.AGGRESSIVE:
			await AmethistChipSet.lockdown_aggressive(bot, analysis)
		
		Bot.ModusOperandi.DEFENSIVE:
			await AmethistChipSet.lockdown_defensive(bot, analysis)
		
		Bot.ModusOperandi.STRATEGICAL_AGGRESSIVE, Bot.ModusOperandi.STRATEGICAL_DEFENSIVE:
			await AmethistChipSet.lockdown_tatical(bot, analysis)
		
		Bot.ModusOperandi.UNDECIDED:
			await AmethistChipSet.lockdown_indecided(bot, analysis)


