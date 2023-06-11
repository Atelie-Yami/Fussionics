class_name FieldAnalysis extends RefCounted


class Report:
	var molecules: Array[Molecule]
	var elements: Array[Element]
	var elements_in_reactor: Array[Element]
	var powerful_element: Element
	var powerful_molecule: Molecule

var my_field: Report
var rival_field: Report


static func make(bot: Bot) -> FieldAnalysis:
	var field_analysis := FieldAnalysis.new()
	field_analysis.my_field = Report.new()
	field_analysis.rival_field = Report.new()
	
	for slot in Arena.elements.values():
		analyze_element(
				slot,
				field_analysis.rival_field if (
						slot.player == PlayerController.Players.A
				) else field_analysis.my_field
		)
	return field_analysis


static func analyze_element(slot: ArenaSlot, report: Report):
	if GameJudge.is_element_in_reactor(slot.element.grid_position):
		report.elements_in_reactor.append(slot.element)
		return
	
	if not slot.molecule:
		report.elements.append(slot.element)
		if not report.powerful_element or report.powerful_element.atomic_number > slot.element.atomic_number:
			report.powerful_element = slot.element
	
	elif not report.molecules.has(slot.molecule):
		report.molecules.append(slot.molecule)
		
		if (
			not report.powerful_molecule or
			GameJudge.calcule_max_molecule_eletrons_power(report.powerful_molecule) >
			GameJudge.calcule_max_molecule_eletrons_power(slot.molecule)
		):
			report.powerful_molecule = slot.molecule
