## Classe que define os elementos.
class_name Element extends Control

## Tempos de ação dos efeitos, quando eles irão ser execultados.
enum ActionTime {
	PRE_INIT, INIT, INSTANTIATED, MOVED, LINKED, UNLINKED, BAKED, DIED, ATTACK, DEFEND, END_TURN
}

enum LigamentPosition {
	UP_DOWN, RIGHT_LEFT
}

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

## isso é basicamente oque define que tipo de elemento é, seu valor é o custo para instanciar.
var atomic_number: int

## valor de ataque, é variável, ou seja, esse valor pode mudar de acordo com oque acontece durante o jogo.
var eletrons: int

## valor de durabilidade, é o valor defensivo utilizado durante os combates, não é muito normal esse valor mudar.
var protons: int

## Indica quantos links esse elemento pode ter em simultâneo.
var valentia: int
var number_electrons_in_valencia: int = valentia

## Dicionario que define os efeitos em seus tempos de ação:[br]
## [codeblock]
## {ActionTime.INIT: Callable(self, "nome_da_func")}
## {ActionTime.INIT: nome_da_func)}
## [/codeblock]
var action_time: Dictionary
var grid_position: Vector2i

var links = {
	Vector2i.UP: null, Vector2i.DOWN: null, Vector2i.LEFT: null, Vector2i.RIGHT: null
}


func link_element(neighbor: Element):
	var elements := [self, neighbor]
	var position: LigamentPosition
	var link: Ligament
	
	if neighbor.grid_position.x == grid_position.x:
		position = LigamentPosition.UP_DOWN
		if neighbor.grid_position.y < grid_position.y: elements = [neighbor, self]
		
	elif neighbor.grid_position.y == grid_position.y:
		position = LigamentPosition.RIGHT_LEFT
		if neighbor.grid_position.x > grid_position.x: elements = [neighbor, self]
	
	else: return
	
	link = Ligament.new(elements[0], elements[1], position)






