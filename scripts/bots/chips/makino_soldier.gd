extends BotChip


func get_modus(_analysis: FieldAnalysis) -> Bot.ModusOperandi:
	return ChipSetAmethist.get_modus(_analysis)


func call_modus_action(modus: Bot.ModusOperandi, bot: Bot, _analysis: BotChip.FieldAnalysis) -> Array[BotChip.Decision]:
	match modus:
		Bot.ModusOperandi.AGGRESSIVE:
			return ChipSetAmethist.aggressive(bot, _analysis)
		
		Bot.ModusOperandi.DEFENSIVE:
			return ChipSetAmethist.defensive(bot, _analysis)
		
		Bot.ModusOperandi.STRATEGICAL_AGGRESSIVE:
			return ChipSetAmethist.tatical_aggressive(bot, _analysis)
		
		Bot.ModusOperandi.STRATEGICAL_DEFENSIVE:
			return ChipSetAmethist.tatical_defensive(bot, _analysis)
		
		Bot.ModusOperandi.UNDECIDED:
			return ChipSetAmethist.indecided(bot, _analysis)
	
	var ops: Array[BotChip.Decision]
	return ops


func execute(bot: Bot, desicions: Array[BotChip.Decision]):
	await ChipSetAmethist.execute(bot, desicions)


func lockdown(bot: Bot, analysis: BotChip.FieldAnalysis, modus: Bot.ModusOperandi):
	match modus:
		Bot.ModusOperandi.AGGRESSIVE:
			await ChipSetAmethist.lockdown_aggressive(bot, analysis)
		
		Bot.ModusOperandi.DEFENSIVE:
			await ChipSetAmethist.lockdown_defensive(bot, analysis)
		
		Bot.ModusOperandi.STRATEGICAL_AGGRESSIVE, Bot.ModusOperandi.STRATEGICAL_DEFENSIVE:
			await ChipSetAmethist.lockdown_tatical(bot, analysis)
		
		Bot.ModusOperandi.UNDECIDED:
			await ChipSetAmethist.lockdown_indecided(bot, analysis)

