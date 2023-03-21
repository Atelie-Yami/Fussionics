class_name Molecule extends RefCounted

enum LigamentPosition {
	UP_DOWN, RIGHT_LEFT
}

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

var configuration: Array[ElementNode]


func link_elements(element_a: ElementNode, element_b: ElementNode):
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


func remove_element(element: ElementNode):
	configuration.erase(element)
	element.links.map(func(link: Ligament): link.remove())


func get_eletron_power() -> int:
	var power := 0
	configuration.map(func(c: ElementNode): power += c.eletrons)
	
	return power
