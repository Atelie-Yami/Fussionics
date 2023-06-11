class_name BotChip extends RefCounted
## classe que detem as caracteristicas e modus operandi do bot


func get_modus(analysis: FieldAnalysis):
	pass


func execute(desicions: Array[Decision], bot: Bot):
	for desicion in desicions:
		if desicion.is_completed:
			continue
		
		if desicion.decision_link:
			var res: Array = await ExecutionChip.execute_decision(bot, desicion.decision_link, [])
			await ExecutionChip.execute_decision(bot, desicion, res)
		else:
			await ExecutionChip.execute_decision(bot, desicion, [])


func call_modus_action(modus: Bot.ModusOperandi, bot: Bot, analysis: FieldAnalysis) -> Array[Decision]:
	match modus:
		Bot.ModusOperandi.AGGRESSIVE:
			pass
		
		
		Bot.ModusOperandi.DEFENSIVE:
			pass
		
		
		Bot.ModusOperandi.STRATEGICAL_AGGRESSIVE:
			pass
		
		
		Bot.ModusOperandi.STRATEGICAL_DEFENSIVE:
			pass
		
		
		Bot.ModusOperandi.UNDECIDED:
			pass
	
	var ops: Array[Decision]
	return ops


func lockdown(bot: Bot, analysis: FieldAnalysis, modus: Bot.ModusOperandi):
	pass
