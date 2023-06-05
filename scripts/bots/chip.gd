class_name BotChip extends RefCounted
## classe que detem as caracteristicas e modus operandi do bot

enum Action {
	DESTROY, DEFEND, POTENTIALIZE, MITIGATE, MERGE, COOK, CREATE
}
enum ActionTarget {
	MY_ELEMENT, MY_MOLECULE, RIVAL_ELEMENT, RIVAL_MOLECULE,
}
enum Directive {
	NON = 0, # sem diretiva
	FORCED = 1, # força a execução a garantir sucesso
	RELINK = 2, # remova os links e os ligue novamente
	CLEAR_SLOT = 4, # remova o elemento do slot caso haja algo
	MAX_ENERGY = 8
}

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

class Decision:
	var decision_link: Decision # se tem outra tarefa antes dessa completar
	var action: Action
	var action_target: ActionTarget
	var directive: Directive
	var targets: Array
	var args: Array


func analysis(bot: Bot) -> FieldAnalysis:
	var field_analysis := FieldAnalysis.new()
	
	bot.start(0.3)
	await bot.timeout
	
	for slot in (Arena.elements as Dictionary).values():
		slot = (slot as ArenaSlot)
		if slot.player == PlayerController.Players.A:
			element_analysis(
					slot, field_analysis.rival_elements_in_reactor, field_analysis.rival_molecules,
					field_analysis.rival_powerful_molecules, field_analysis.rival_single_elements,
					field_analysis.rival_powerful_single_elements
			)
		else:
			element_analysis(
					slot, field_analysis.my_elements_in_reactor, field_analysis.my_molecules,
					field_analysis.my_powerful_molecules, field_analysis.my_single_elements,
					field_analysis.my_powerful_single_elements
			)
	
	bot.start(0.3)
	await bot.timeout
	return field_analysis


func element_analysis(
		slot: ArenaSlot, elements_in_reactor: Array[Element],
		molecules: Array[Molecule], powerful_molecule: Molecule,
		single_elements: Array[Element], powerful_single_element: Element
):
	if GameJudge.is_element_in_reactor(slot.element.grid_position):
		elements_in_reactor.append(slot.element)
		return
	
	if not slot.molecule:
		single_elements.append(slot.element)
		
		if powerful_single_element == null or powerful_single_element.atomic_number > slot.element.atomic_number:
			powerful_single_element = slot.element
		
	elif not molecules.has(slot.molecule):
		molecules.append(slot.molecule)
		if (
				powerful_molecule == null or
				GameJudge.calcule_max_molecule_eletrons_power(powerful_molecule) >
				GameJudge.calcule_max_molecule_eletrons_power(slot.molecule)
		):
			powerful_molecule = slot.molecule


func get_modus(analysis: FieldAnalysis):
	pass


func call_modus_action(modus: Bot.ModusOperandi, bot: Bot, analysis: BotChip.FieldAnalysis) -> Array[BotChip.Decision]:
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
	
	var ops: Array[BotChip.Decision]
	return ops


func execute(bot: Bot, desicions: Array[BotChip.Decision]):
	pass


func lockdown(bot: Bot, analysis: BotChip.FieldAnalysis, modus: Bot.ModusOperandi):
	pass
