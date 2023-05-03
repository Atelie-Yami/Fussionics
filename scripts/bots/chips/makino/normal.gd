extends BotChip



func get_modus(_analysis: FieldAnalysis) -> Bot.ModusOperandi:
	if not _analysis.has_my_elements_in_field and _analysis.has_rival_elements_in_field:
		return Bot.ModusOperandi.DEFENSIVE
	
	if _analysis.has_my_elements_in_field and not _analysis.has_rival_elements_in_field:
		return Bot.ModusOperandi.AGGRESSIVE
	
	for m in _analysis.my_molecules:
		var power: int = GameJudge.calcule_max_molecule_eletrons_power(m)
		if power > 7 and GameJudge.is_molecule_opened(m):
			return Bot.ModusOperandi.STRATEGICAL_AGGRESSIVE
	
	if _analysis.my_molecules.is_empty():
		for e in _analysis.my_single_elements:
			if e.atomic_number > 3:
				return Bot.ModusOperandi.STRATEGICAL_DEFENSIVE
	
	return Bot.ModusOperandi.UNDECIDED


func make_decision(bot: Bot, analysis: FieldAnalysis, modus: Bot.ModusOperandi) -> Dictionary:
	return {}


