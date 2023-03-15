## Classe que define os elementos.
class_name Element extends Control

## Tempos de ação dos efeitos, quando eles irão ser execultados.
enum ActionTime {
	PRE_INIT, INIT, INSTANTIATED, MOVED, LINKED, UNLINKED, BAKED, DIED, ATTACK, DEFEND, END_TURN
}
enum LigamentPosition {
	UP_DOWN, RIGHT_LEFT
}
enum {SIMBOL, NAME, VALENTIA, SERIE}
enum {ALKALINE, ALKALINE_EARTH, LANTANIDIUM, ACTINIDIUM, TRANSITION, OTHERS, SEMI, METALLOID, HALOGEN, NOBLE, UNKNOWN}

const COLOR_SERIES = {
	ALKALINE:		Color("B52430"),
	ALKALINE_EARTH: Color('FF8A3D'),
	LANTANIDIUM: 	Color('D323BC'),
	ACTINIDIUM: 	Color('00E42F'),
	TRANSITION: 	Color('4AB593'),
	OTHERS: 		Color('5994FF'),
	SEMI: 			Color('C294FF'),
	METALLOID: 		Color('00FFFF'),
	HALOGEN: 		Color('CEC469'),
	NOBLE: 			Color('84D89E'),
	UNKNOWN: 		Color('A0A0A0'),
}
const DATA = [
	{SIMBOL : "H", NAME : "Hidrogen", VALENTIA : 1, SERIE: METALLOID},
	{SIMBOL : "He", NAME : "Helium", VALENTIA : 0, SERIE: NOBLE},
	{SIMBOL : "Li", NAME : "Lithium", VALENTIA : 1, SERIE: ALKALINE},
	{SIMBOL : "Be", NAME : "Beryllium", VALENTIA : 2, SERIE: ALKALINE_EARTH},
	{SIMBOL : "B", NAME : "Boron", VALENTIA : 3, SERIE: SEMI},
	{SIMBOL : "C", NAME : "Carbon", VALENTIA : 4, SERIE: METALLOID},
	{SIMBOL : "N", NAME : "Nitrogen", VALENTIA : 5, SERIE: METALLOID},
	{SIMBOL : "O", NAME : "Oxygen", VALENTIA : 2, SERIE: METALLOID},
	{SIMBOL : "F", NAME : "Fluorine", VALENTIA : 1, SERIE: HALOGEN},
	{SIMBOL : "Ne", NAME : "Neon", VALENTIA : 0, SERIE: NOBLE},
	{SIMBOL : "Na", NAME : "Sodium", VALENTIA : 1, SERIE: ALKALINE},
	{SIMBOL : "Mg", NAME : "Magnesium", VALENTIA : 2, SERIE: ALKALINE_EARTH},
	{SIMBOL : "Al", NAME : "Aluminium", VALENTIA : 3, SERIE: OTHERS},
	{SIMBOL : "Si", NAME : "Silicon", VALENTIA : 4, SERIE: SEMI},
	{SIMBOL : "P", NAME : "Phosphorus", VALENTIA : 5, SERIE: METALLOID},
	{SIMBOL : "S", NAME : "Sulfur", VALENTIA : 6, SERIE: METALLOID},
	{SIMBOL : "Cl", NAME : "Chlorine", VALENTIA : 7, SERIE: HALOGEN},
	{SIMBOL : "Ar", NAME : "Argon", VALENTIA : 0, SERIE: NOBLE},
	{SIMBOL : "K", NAME : "Potassium", VALENTIA : 1, SERIE: ALKALINE},
	{SIMBOL : "Ca", NAME : "Calcium", VALENTIA : 2, SERIE: ALKALINE_EARTH},
	{SIMBOL : "Sc", NAME : "Scandium", VALENTIA : 3, SERIE: TRANSITION},
	{SIMBOL : "Ti", NAME : "Titanium", VALENTIA : 4, SERIE: TRANSITION},
	{SIMBOL : "V", NAME : "Vanadium", VALENTIA : 5, SERIE: TRANSITION},
	{SIMBOL : "Cr", NAME : "Chromium", VALENTIA : 6, SERIE: TRANSITION},
	{SIMBOL : "Mn", NAME : "Manganese", VALENTIA : 7, SERIE: TRANSITION},
	{SIMBOL : "Fe", NAME : "Iron", VALENTIA : 6, SERIE: TRANSITION},
	{SIMBOL : "Co", NAME : "Cobalt", VALENTIA : 3, SERIE: TRANSITION},
	{SIMBOL : "Ni", NAME : "Nickel", VALENTIA : 3, SERIE: TRANSITION},
	{SIMBOL : "Cu", NAME : "Copper", VALENTIA : 2, SERIE: TRANSITION},
	{SIMBOL : "Zn", NAME : "Zinc", VALENTIA : 2, SERIE: TRANSITION},
	{SIMBOL : "Ga", NAME : "Gallium", VALENTIA : 3, SERIE: OTHERS},
	{SIMBOL : "Ge", NAME : "Germanium", VALENTIA : 4, SERIE: SEMI},
	{SIMBOL : "As", NAME : "Arsenic", VALENTIA : 5, SERIE: SEMI},
	{SIMBOL : "Se", NAME : "Selenium", VALENTIA : 6, SERIE: SEMI},
	{SIMBOL : "Br", NAME : "Bromine", VALENTIA : 7, SERIE: HALOGEN},
	{SIMBOL : "Kr", NAME : "Krypton", VALENTIA : 0, SERIE: NOBLE},
	{SIMBOL : "Rb", NAME : "Rubidium", VALENTIA : 1, SERIE: ALKALINE},
	{SIMBOL : "Sr", NAME : "Strontium", VALENTIA : 2, SERIE: ALKALINE_EARTH},
	{SIMBOL : "Y", NAME : "Yttrium", VALENTIA : 3, SERIE: TRANSITION},
	{SIMBOL : "Zr", NAME : "Zirconium", VALENTIA : 4, SERIE: TRANSITION},
	{SIMBOL : "Nb", NAME : "Niobium", VALENTIA : 5, SERIE: TRANSITION},
	{SIMBOL : "Mo", NAME : "Molybdenum", VALENTIA : 6, SERIE: TRANSITION},
	{SIMBOL : "Tc", NAME : "Technetium", VALENTIA : 7, SERIE: TRANSITION},
	{SIMBOL : "Ru", NAME : "Ruthenium", VALENTIA : 8, SERIE: TRANSITION},
	{SIMBOL : "Rh", NAME : "Rhodium", VALENTIA : 6, SERIE: TRANSITION},
	{SIMBOL : "Pd", NAME : "Palladium", VALENTIA : 4, SERIE: TRANSITION},
	{SIMBOL : "Ag", NAME : "Silver", VALENTIA : 2, SERIE: TRANSITION},
	{SIMBOL : "Cd", NAME : "Cadmium", VALENTIA : 2, SERIE: TRANSITION},
	{SIMBOL : "In", NAME : "Indium", VALENTIA : 3, SERIE: OTHERS},
	{SIMBOL : "Sn", NAME : "Tin", VALENTIA : 4, SERIE: OTHERS},
	{SIMBOL : "Sb", NAME : "Antimony", VALENTIA : 5, SERIE: SEMI},
	{SIMBOL : "Te", NAME : "Tellurium", VALENTIA : 6, SERIE: SEMI},
	{SIMBOL : "I", NAME : "Iodine", VALENTIA : 7, SERIE: HALOGEN},
	{SIMBOL : "Xe", NAME : "Xenon", VALENTIA : 0, SERIE: NOBLE},
	{SIMBOL : "Cs", NAME : "Caesium", VALENTIA : 1, SERIE: ALKALINE},
	{SIMBOL : "Ba", NAME : "Barium", VALENTIA : 2, SERIE: ALKALINE_EARTH},
	{SIMBOL : "La", NAME : "Lanthanum", VALENTIA : 3, SERIE: LANTANIDIUM},
	{SIMBOL : "Ce", NAME : "Cerium", VALENTIA : 4, SERIE: LANTANIDIUM},
	{SIMBOL : "Pr", NAME : "Praseodymium", VALENTIA : 3, SERIE: LANTANIDIUM},
	{SIMBOL : "Nd", NAME : "Neodymium", VALENTIA : 3, SERIE: LANTANIDIUM},
	{SIMBOL : "Pm", NAME : "Promethium", VALENTIA : 3, SERIE: LANTANIDIUM},
	{SIMBOL : "Sm", NAME : "Samarium", VALENTIA : 3, SERIE: LANTANIDIUM},
	{SIMBOL : "Eu", NAME : "Europium", VALENTIA : 3, SERIE: LANTANIDIUM},
	{SIMBOL : "Gd", NAME : "Gadolinium", VALENTIA : 3, SERIE: LANTANIDIUM},
	{SIMBOL : "Tb", NAME : "Terbium", VALENTIA : 3, SERIE: LANTANIDIUM},
	{SIMBOL : "Dy", NAME : "Dysprosium", VALENTIA : 3, SERIE: LANTANIDIUM},
	{SIMBOL : "Ho", NAME : "Holmium", VALENTIA : 3, SERIE: LANTANIDIUM},
	{SIMBOL : "Er", NAME : "Erbium", VALENTIA : 3, SERIE: LANTANIDIUM},
	{SIMBOL : "Tm", NAME : "Thulium", VALENTIA : 3, SERIE: LANTANIDIUM},
	{SIMBOL : "Yb", NAME : "Ytterbium", VALENTIA : 3, SERIE: LANTANIDIUM},
	{SIMBOL : "Lu", NAME : "Lutetium", VALENTIA : 3, SERIE: LANTANIDIUM},
	{SIMBOL : "Hf", NAME : "Hafnium", VALENTIA : 4, SERIE: TRANSITION},
	{SIMBOL : "Ta", NAME : "Tantalum", VALENTIA : 5, SERIE: TRANSITION},
	{SIMBOL : "W", NAME : "Tungsten", VALENTIA : 6, SERIE: TRANSITION},
	{SIMBOL : "Re", NAME : "Rhenium", VALENTIA : 7, SERIE: TRANSITION},
	{SIMBOL : "Os", NAME : "Osmium", VALENTIA : 8, SERIE: TRANSITION},
	{SIMBOL : "Ir", NAME : "Iridium", VALENTIA : 4, SERIE: TRANSITION},
	{SIMBOL : "Pt", NAME : "Platinum", VALENTIA : 4, SERIE: TRANSITION},
	{SIMBOL : "Au", NAME : "Gold", VALENTIA : 3, SERIE: TRANSITION},
	{SIMBOL : "Hg", NAME : "Mercury", VALENTIA : 2, SERIE: TRANSITION},
	{SIMBOL : "Tl", NAME : "Thallium", VALENTIA : 3, SERIE: OTHERS},
	{SIMBOL : "Pb", NAME : "Lead", VALENTIA : 4, SERIE: OTHERS},
	{SIMBOL : "Bi", NAME : "Bismuth", VALENTIA : 5, SERIE: OTHERS},
	{SIMBOL : "Po", NAME : "Polonium", VALENTIA : 4, SERIE: OTHERS},
	{SIMBOL : "At", NAME : "Astatine", VALENTIA : 7, SERIE: HALOGEN},
	{SIMBOL : "Rn", NAME : "Radon", VALENTIA : 0, SERIE: NOBLE},
	{SIMBOL : "Fr", NAME : "Francium", VALENTIA : 1, SERIE: ALKALINE},
	{SIMBOL : "Ra", NAME : "Radium", VALENTIA : 2, SERIE: ALKALINE_EARTH},
	{SIMBOL : "Ac", NAME : "Actinium", VALENTIA : 3, SERIE: ACTINIDIUM},
	{SIMBOL : "Th", NAME : "Thorium", VALENTIA : 4, SERIE: ACTINIDIUM},
	{SIMBOL : "Pa", NAME : "Protactinium", VALENTIA : 5, SERIE: ACTINIDIUM},
	{SIMBOL : "U", NAME : "Uranium", VALENTIA : 6, SERIE: ACTINIDIUM},
	{SIMBOL : "Np", NAME : "Neptunium", VALENTIA : 6, SERIE: ACTINIDIUM},
	{SIMBOL : "Pu", NAME : "Plutonium", VALENTIA : 6, SERIE: ACTINIDIUM},
	{SIMBOL : "Am", NAME : "Americium", VALENTIA : 6, SERIE: ACTINIDIUM},
	{SIMBOL : "Cm", NAME : "Curium", VALENTIA : 4, SERIE: ACTINIDIUM},
	{SIMBOL : "Bk", NAME : "Berkelium", VALENTIA : 4, SERIE: ACTINIDIUM},
	{SIMBOL : "Cf", NAME : "Californium", VALENTIA : 4, SERIE: ACTINIDIUM},
	{SIMBOL : "Es", NAME : "Einsteinium", VALENTIA : 3, SERIE: ACTINIDIUM},
	{SIMBOL : "Fm", NAME : "Fermium", VALENTIA : 3, SERIE: ACTINIDIUM},
	{SIMBOL : "Md", NAME : "Mendelevium", VALENTIA : 3, SERIE: ACTINIDIUM},
	{SIMBOL : "No", NAME : "Nobelium", VALENTIA : 3, SERIE: ACTINIDIUM},
	{SIMBOL : "Lr", NAME : "Lawrencium", VALENTIA : 2, SERIE: ACTINIDIUM},
	{SIMBOL : "Rf", NAME : "Rutherfordium", VALENTIA : 4, SERIE: TRANSITION},
	{SIMBOL : "Db", NAME : "Dubnium", VALENTIA : 5, SERIE: TRANSITION},
	{SIMBOL : "Sg", NAME : "Seaborgium", VALENTIA : 6, SERIE: TRANSITION},
	{SIMBOL : "Bh", NAME : "Bohrium", VALENTIA : 7, SERIE: TRANSITION},
	{SIMBOL : "Hs", NAME : "Hassium", VALENTIA : 8, SERIE: TRANSITION},
	{SIMBOL : "Mt", NAME : "Meitnerium", VALENTIA : 4, SERIE: TRANSITION},
	{SIMBOL : "Ds", NAME : "Darmstadtium", VALENTIA : 4, SERIE: TRANSITION},
	{SIMBOL : "Rg", NAME : "Roentgenium", VALENTIA : 3, SERIE: TRANSITION},
	{SIMBOL : "Cn", NAME : "Copernicium", VALENTIA : 2, SERIE: TRANSITION},
	{SIMBOL : "Nh", NAME : "Nihonium", VALENTIA : 3, SERIE: OTHERS},
	{SIMBOL : "Fl", NAME : "Flerovium", VALENTIA : 4, SERIE: OTHERS},
	{SIMBOL : "Mc", NAME : "Moscovium", VALENTIA : 5, SERIE: OTHERS},
	{SIMBOL : "Lv", NAME : "Livermorium", VALENTIA : 6, SERIE: OTHERS},
	{SIMBOL : "Ts", NAME : "Tennessine", VALENTIA : 6, SERIE: HALOGEN},
	{SIMBOL : "Og", NAME : "Oganesson", VALENTIA : 0, SERIE: NOBLE},
	{SIMBOL : "Uue", NAME : "Ununennium", VALENTIA : 1, SERIE: ALKALINE},
]

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
@export var atomic_number: int

## valor de ataque, é variável, ou seja, esse valor pode mudar de acordo com oque acontece durante o jogo.
var eletrons: int

## isotopo, geralmente o mesmo valor q o numero atomico.
var neutrons: int

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






