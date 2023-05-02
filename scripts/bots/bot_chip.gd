class_name BotChip extends RefCounted
## classe que detem as caracteristicas e modus operandi do bot

enum Action {
	DESTROY, DEFEND, POTENTIALIZE, MITIGATE, MERGE, COOK,
}
enum ActionTarget {
	MY_ELEMENT, MY_MOLECULE, RIVAL_ELEMENT, RIVAL_MOLECULE,
}

class FieldAnalysis:
	var my_molecules: Array[Molecule]
	var my_single_elements: Array[Element]
	
	var rival_single_elements: Array[Element]
	var rival_molecules: Array[Molecule]
	
	var has_my_elements_in_reactor: bool
	var has_rival_elements_in_reactor: bool
	
	var has_my_elements_in_field: bool
	var has_rival_elements_in_field: bool


func analysis(bot: Bot) -> FieldAnalysis:
	var field_analysis := FieldAnalysis.new()
	
	bot.start(0.3)
	await bot.timeout
	
	for slot in (Gameplay.arena.elements as Dictionary).values():
		slot = (slot as ArenaSlot)
		if slot.player == PlayerController.Players.A:
			if GameJudge.is_element_in_reactor(slot.element.grid_position):
				field_analysis.has_rival_elements_in_reactor = true
			else:
				field_analysis.has_rival_elements_in_field = true
			
			if slot.molecule:
				if not field_analysis.rival_molecules.has(slot.molecule):
					field_analysis.rival_molecules.append(slot.molecule)
			else:
				field_analysis.rival_single_elements.append(slot.element)
		else:
			if GameJudge.is_element_in_reactor(slot.element.grid_position):
				field_analysis.has_my_elements_in_reactor = true
			else:
				field_analysis.has_my_elements_in_field = true
			
			if slot.molecule:
				if not field_analysis.my_molecules.has(slot.molecule):
					field_analysis.my_molecules.append(slot.molecule)
			else:
				field_analysis.my_single_elements.append(slot.element)
	
	bot.start(0.3)
	await bot.timeout
	return field_analysis


func get_modus(analysis: FieldAnalysis):
	pass


func make_decision(bot: Bot, analysis: FieldAnalysis, modus: Bot.ModusOperandi):
	pass
