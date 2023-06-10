class_name BotChip extends RefCounted
## classe que detem as caracteristicas e modus operandi do bot


class FieldAnalysis:
	var my_molecules: Array[Molecule]
	var rival_molecules: Array[Molecule]
	
	var my_single_elements: Array[Element]
	var rival_single_elements: Array[Element]
	
	var my_elements_in_reactor: Array[Element]
	var rival_elements_in_reactor: Array[Element]
	
	var my_powerful_single_elements: Element
	var rival_powerful_single_elements: Element
	
	var my_powerful_molecules: Molecule
	var rival_powerful_molecules: Molecule


func analysis(bot: Bot) -> FieldAnalysis:
	var field_analysis := FieldAnalysis.new()
	for slot in (Arena.elements as Dictionary).values():
		slot = (slot as ArenaSlot)
		if slot.player == PlayerController.Players.A:
			if GameJudge.is_element_in_reactor(slot.element.grid_position):
				field_analysis.rival_elements_in_reactor.append(slot.element)
				continue
			
			if not slot.molecule:
				field_analysis.rival_single_elements.append(slot.element)
				if (
					not field_analysis.rival_powerful_single_elements or
					field_analysis.rival_powerful_single_elements.atomic_number > slot.element.atomic_number
				):
					field_analysis.rival_powerful_single_elements = slot.element
			
			elif not field_analysis.rival_molecules.has(slot.molecule):
				field_analysis.rival_molecules.append(slot.molecule)
				if (
					not field_analysis.rival_powerful_molecules or
					GameJudge.calcule_max_molecule_eletrons_power(field_analysis.rival_powerful_molecules) >
					GameJudge.calcule_max_molecule_eletrons_power(slot.molecule)
				):
					field_analysis.rival_powerful_molecules = slot.molecule
		else:
			if GameJudge.is_element_in_reactor(slot.element.grid_position):
				field_analysis.my_elements_in_reactor.append(slot.element)
				continue
			
			if not slot.molecule:
				field_analysis.my_single_elements.append(slot.element)
				if (
					not field_analysis.my_powerful_single_elements or
					field_analysis.my_powerful_single_elements.atomic_number > slot.element.atomic_number
				):
					field_analysis.my_powerful_single_elements = slot.element
			
			elif not field_analysis.my_molecules.has(slot.molecule):
				field_analysis.my_molecules.append(slot.molecule)
				if (
					not field_analysis.my_powerful_molecules or
					GameJudge.calcule_max_molecule_eletrons_power(field_analysis.my_powerful_molecules) >
					GameJudge.calcule_max_molecule_eletrons_power(slot.molecule)
				):
					field_analysis.my_powerful_molecules = slot.molecule
	return field_analysis


func get_modus(analysis: FieldAnalysis):
	pass


func execute(desicions: Array[Decision], bot: Bot):
	for desicion in desicions:
		if desicion.is_completed:
			continue
		
		if desicion.decision_link:
			var res = await ChipSet.execute_decision(bot, desicion.decision_link)
			await ChipSet.execute_decision(bot, desicion, res)
		else:
			await ChipSet.execute_decision(bot, desicion)


func call_modus_action(modus: Bot.ModusOperandi, bot: Bot, analysis: BotChip.FieldAnalysis) -> Array[Decision]:
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


func lockdown(bot: Bot, analysis: BotChip.FieldAnalysis, modus: Bot.ModusOperandi):
	pass
