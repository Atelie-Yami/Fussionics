@static_unload
class_name BotChip extends RefCounted

static var modus: Callable
static var modus_action := {
	Bot.ModusOperandi.UNDECIDED: [],
	Bot.ModusOperandi.DEFENSIVE: [],
	Bot.ModusOperandi.AGGRESSIVE: [],
	Bot.ModusOperandi.STRATEGICAL_DEFENSIVE: [],
	Bot.ModusOperandi.STRATEGICAL_AGGRESSIVE: [],
}
static var instructions := {
	"decompose": null,
}


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
