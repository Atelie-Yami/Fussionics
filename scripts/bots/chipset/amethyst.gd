class_name ChipSetAmethist extends Node

func get_modus(_analysis: BotChip.FieldAnalysis) -> Bot.ModusOperandi:
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


func decision(bot: Bot, analysis: BotChip.FieldAnalysis, modus: Bot.ModusOperandi):
	var decision_list: Array
	
	match modus:
		Bot.ModusOperandi.UNDECIDED:
			for m in analysis.my_molecules:
				if GameJudge.is_molecule_opened(m):
					var d := BotChip.Decision.new()
					decision_list.append(d)
					
					d.action_target = BotChip.ActionTarget.NEW
					d.action = BotChip.Action.MERGE
					d.targets = [m]
			
			if analysis.my_single_elements.is_empty():
				var d := BotChip.Decision.new()
				decision_list.append(d)
				
				d.action_target = BotChip.ActionTarget.NEW
				d.action = BotChip.Action.CREATE
			
			elif analysis.my_single_elements.size() == 1:
				var d := BotChip.Decision.new()
				decision_list.append(d)
				
				d.action_target = BotChip.ActionTarget.MY_ELEMENT
				d.targets = [analysis.my_single_elements[0]]
				
				if analysis.my_single_elements[0].atomic_number < 4:
					d.action = BotChip.Action.COOK
				else:
					d.action = BotChip.Action.MERGE
		
		Bot.ModusOperandi.DEFENSIVE:
			analysis
		
		Bot.ModusOperandi.AGGRESSIVE:
			pass
		
		Bot.ModusOperandi.STRATEGICAL_DEFENSIVE:
			pass
		
		Bot.ModusOperandi.STRATEGICAL_AGGRESSIVE:
			pass
	
	analysis
	
	
	
	return decision
