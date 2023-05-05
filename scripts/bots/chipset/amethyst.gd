class_name ChipSetAmethist extends ChipSet


static func get_modus(_analysis: BotChip.FieldAnalysis) -> Bot.ModusOperandi:
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


static func indecided(bot: Bot, analysis: BotChip.FieldAnalysis):
	var decision_list: Array
	
	for m in analysis.my_molecules:
		if GameJudge.is_molecule_opened(m): ## se da pra por elementos na molecula
			var d := BotChip.Decision.new()
			decision_list.append(d)
			
			d.action_target = BotChip.ActionTarget.NEW ## tag NEW vai criar um elemento
			d.action = BotChip.Action.MERGE ## tag MERGE vai unir o novo elemento na molecula 
			d.targets = [m] ## a molecula
			break
	
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
	
	else:
		pass

static func execute(bot: Bot, desicions: Array[BotChip.Decision]):
	for dsc in desicions:
		await execute_decision(bot, dsc)


static func execute_decision(bot: Bot, decision: BotChip.Decision):
	if decision.decision_link:
		await execute_decision(bot, decision.decision_link)
	
	match decision.action:
		BotChip.Action.COOK:
			if decision.targets:
				## await (mover decision.targets para o forno)
				pass
				
				## espera um tempo né pae kk
				bot.start(0.1)
				await bot.timeout
				
				## await (criar elemento no forno)
				pass
		
		BotChip.Action.CREATE:
			pass
		
		BotChip.Action.DEFEND:
			pass
		
		BotChip.Action.DESTROY:
			pass
		
		BotChip.Action.MERGE:
			pass
		
		BotChip.Action.MITIGATE:
			pass
		
		BotChip.Action.POTENTIALIZE:
			pass
		
	
	decision.completed


