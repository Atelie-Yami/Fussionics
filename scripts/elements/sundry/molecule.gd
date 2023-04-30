class_name Molecule extends RefCounted

enum Kit {
	ATTACK, EFFECT, DEFENDE
}
enum LigamentPosition {
	UP_DOWN, RIGHT_LEFT
}

const BORDELINE := preload("res://scenes/world/line_contorno.tscn")

#------------------------------------------------------------------------------#
## classe que vai ser a coneção entre 2 elementos
class Ligament:
	var element_A: Element
	var element_B: Element
	var position: LigamentPosition
	
	## quantidade de eletrons linkados, de 1 a 3 pq é assim na quimica kk
	var level: int = 1
	
	func _init(origin: Element, neighbor: Element, pos: LigamentPosition):
		element_A = origin; element_B = neighbor; position = pos
		
		origin  .number_electrons_in_valencia -= 1
		neighbor.number_electrons_in_valencia -= 1
		
		match position:
			LigamentPosition.UP_DOWN:
				origin  .links[Vector2i.UP  ] = self
				neighbor.links[Vector2i.DOWN] = self
			
			LigamentPosition.RIGHT_LEFT:
				origin  .links[Vector2i.RIGHT] = self
				neighbor.links[Vector2i.LEFT ] = self
		
	func evolve_ligament():
		element_A.number_electrons_in_valencia -= 1
		element_B.number_electrons_in_valencia -= 1
		level += 1
	
	func demote_ligament():
		element_A.number_electrons_in_valencia += 1
		element_B.number_electrons_in_valencia += 1
		level -= 1
	
	func remove():
		element_A.number_electrons_in_valencia += level
		element_B.number_electrons_in_valencia += level
		
		match position:
			LigamentPosition.UP_DOWN:
				element_A.links[Vector2i.UP  ] = null
				element_B.links[Vector2i.DOWN] = null
			
			LigamentPosition.RIGHT_LEFT:
				element_A.links[Vector2i.RIGHT] = null
				element_B.links[Vector2i.LEFT ] = null
#------------------------------------------------------------------------------#

var ref_count: int = 1

var defender: Element
var configuration: Array[Element]
var border_line: LineMap = BORDELINE.instantiate()

var effect_pool := {
	MoleculeEffect.MoleculeEffectType.TRIGGER:    [],
	MoleculeEffect.MoleculeEffectType.MECHANICAL: [],
	MoleculeEffect.MoleculeEffectType.UPGRADE:    [],
	MoleculeEffect.MoleculeEffectType.MULTI:      [],
}

func _init():
	Gameplay.arena.add_child(border_line)
	border_line.global_position = Gameplay.arena.GRID_OFFSET - Vector2i(5, 5)


func update_border():
	var array: Array[Vector2]
	
	for element in configuration:
		array.append(Vector2(element.grid_position))
	
	border_line.Update(array)


func gain_ref():
	ref_count += 1
	update_border()


func redux_ref():
	ref_count -= 1
	if ref_count <= 1:
		border_line.queue_free()
	
	else:
		update_border()


func prepare_element_for_attack(header: Element):
	configuration.map(_handle_element_action.bind(header))
	Gameplay.arena.elements[header.grid_position].can_act = false
	header.disabled = true


func _handle_element_action(element: Element, header: Element):
	if element != header and element.eletrons > 0:
		element.eletrons -= 1
		header.eletrons += 1


func link_elements(element_a: Element, element_b: Element):
	var elements_array := [element_a, element_b]
	var orientation: LigamentPosition
	var link: Ligament
	
	if element_b.grid_position.x == element_a.grid_position.x:
		orientation = LigamentPosition.UP_DOWN
		
		if element_b.grid_position.y < element_a.grid_position.y:
			elements_array = [element_b, element_a]
		
	elif element_b.grid_position.y == element_a.grid_position.y:
		orientation = LigamentPosition.RIGHT_LEFT
		
		if element_b.grid_position.x > element_a.grid_position.x:
			elements_array = [element_b, element_a]
	
	else: return
	
	link = Ligament.new(elements_array[0], elements_array[1], orientation)


func remove_element(element: Element):
	configuration.erase(element)
	for link in element.links:
		if element.links[link]:
			element.links[link].remove()
	border_line.Update([])


func add_element(element: Element):
	configuration.append(element)
	Gameplay.arena.elements[element.grid_position].molecule = self


func get_eletron_power() -> int:
	var power := 0
	configuration.map(func(c: Element): power += c.eletrons)
	
	return power


func effects_cluster_assembly(header: ArenaSlot, target: ArenaSlot, kit: Kit):
	if (
			not header.element.effect or not header.element.effect is MoleculeEffect or
			header.element.effect.molecule_effect_type != MoleculeEffect.MoleculeEffectType.TRIGGER
	):
		await GameJudge.combat(header, target)
	
	match kit:
		Kit.ATTACK:
			if header.element.effect is MoleculeEffect and header.element.effect.mechanic_mode == MoleculeEffect.MechanicMode.DESTROYER:
				await assembly_kit_combat_effects(header.element.effect, target.element)
			else:
				await GameJudge.combat(header, target)
				header.element.disabled = true
		Kit.EFFECT:
			pass


func assembly_kit_combat_effects(header: MoleculeEffect, target: Element):
	var pack: Array[MoleculeEffect]
	for e in configuration:
		if e.effect and e.effect is MoleculeEffect:
			pack.append(e.effect)
	
	var cluster := EffectCluster.new(header, pack, self)
	header.get_targets(target)
	cluster.construct(header)
	header.cluster = cluster
	await header.execute()

