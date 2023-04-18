## Classe que define os elementos.
class_name Element extends Control

signal selected_changed(value: bool)

## Tempos de ação dos efeitos, quando eles irão ser execultados.
enum ActionTime {
	PRE_INIT, INIT, INSTANTIATED, MOVED, LINKED, UNLINKED, BAKED, DIED, ATTACK, DEFEND, END_TURN
}
enum Series {
	ALKALINE, ALKALINE_EARTH, LANTANIDIUM, ACTINIDIUM, TRANSITION, OTHERS, SEMI, METALLOID, HALOGEN, NOBLE, UNKNOWN
}
enum {
	SIMBOL, NAME, VALENTIA, SERIE
}
enum NodeState {
	NORMAL, HOVER, SELECTED
}

const ICON_PASSIVE := preload("res://assets/img/elements/buff_debuff.svg")
const FUTURE_SALLOW := preload("res://assets/fonts/Future Sallow.ttf")
const GIANT_ROBOT := preload("res://assets/fonts/GiantRobotArmy-Medium.ttf")
const SLOT := preload("res://assets/img/elements/Slot_0.png")
const LEGANCY := preload("res://scenes/elements/legancy.tscn")
const GLOW := preload("res://scenes/elements/glow.tscn")

const LIGAMENT_SPACCAMENT := 10.0
const LIGAMENT_SIDE_SPACCAMENT := LIGAMENT_SPACCAMENT / 2.0
const MAX_PASSIVE_ICON := 3
const FONT_SIZE := 48.0
const FONT_ATRIBUTES_SIZE := 13.0
const COLOR_SERIES = {
	Series.ALKALINE:		Color("f05459"),
	Series.ALKALINE_EARTH: Color('FF8A3D'),
	Series.LANTANIDIUM: 	Color('D323BC'),
	Series.ACTINIDIUM: 	Color('00E42F'),
	Series.TRANSITION: 	Color('4AB593'),
	Series.OTHERS: 		Color('5994FF'),
	Series.SEMI: 			Color('C294FF'),
	Series.METALLOID: 		Color('00FFFF'),
	Series.HALOGEN: 		Color('CEC469'),
	Series.NOBLE: 			Color('84D89E'),
	Series.UNKNOWN: 		Color('A0A0A0'),
}
const DATA = [
	{SIMBOL : "H", NAME : "HYDROGEN", VALENTIA :1, SERIE : Series.METALLOID},
	{SIMBOL : "He", NAME : "HELIUM", VALENTIA :0, SERIE : Series.NOBLE},
	{SIMBOL : "Li", NAME : "LITHIUM", VALENTIA :1, SERIE : Series.ALKALINE},
	{SIMBOL : "Be", NAME : "BERYLLIUM", VALENTIA :2, SERIE : Series.ALKALINE_EARTH},
	{SIMBOL : "B", NAME : "BORON", VALENTIA :3, SERIE : Series.SEMI},
	{SIMBOL : "C", NAME : "CARBON", VALENTIA :4, SERIE : Series.METALLOID},
	{SIMBOL : "N", NAME : "NITROGEN", VALENTIA :5, SERIE : Series.METALLOID},
	{SIMBOL : "O", NAME : "OXYGEN", VALENTIA :2, SERIE : Series.METALLOID},
	{SIMBOL : "F", NAME : "FLUORINE", VALENTIA :1, SERIE : Series.HALOGEN},
	{SIMBOL : "Ne", NAME : "NEON", VALENTIA :0, SERIE : Series.NOBLE},
	{SIMBOL : "Na", NAME : "SODIUM", VALENTIA :1, SERIE : Series.ALKALINE},
	{SIMBOL : "Mg", NAME : "MAGNESIUM", VALENTIA :2, SERIE : Series.ALKALINE_EARTH},
	{SIMBOL : "Al", NAME : "ALUMINIUM", VALENTIA :3, SERIE : Series.OTHERS},
	{SIMBOL : "Si", NAME : "SILICON", VALENTIA :4, SERIE : Series.SEMI},
	{SIMBOL : "P", NAME : "PHOSPHORUS", VALENTIA :5, SERIE : Series.METALLOID},
	{SIMBOL : "S", NAME : "SULFUR", VALENTIA :6, SERIE : Series.METALLOID},
	{SIMBOL : "Cl", NAME : "CHLORINE", VALENTIA :7, SERIE : Series.HALOGEN},
	{SIMBOL : "Ar", NAME : "ARGON", VALENTIA :0, SERIE : Series.NOBLE},
	{SIMBOL : "K", NAME : "POTASSIUM", VALENTIA :1, SERIE : Series.ALKALINE},
	{SIMBOL : "Ca", NAME : "CALCIUM", VALENTIA :2, SERIE : Series.ALKALINE_EARTH},
	{SIMBOL : "Sc", NAME : "SCANDIUM", VALENTIA :3, SERIE : Series.TRANSITION},
	{SIMBOL : "Ti", NAME : "TITANIUM", VALENTIA :4, SERIE : Series.TRANSITION},
	{SIMBOL : "V", NAME : "VANADIUM", VALENTIA :5, SERIE : Series.TRANSITION},
	{SIMBOL : "Cr", NAME : "CHROMIUM", VALENTIA :6, SERIE : Series.TRANSITION},
	{SIMBOL : "Mn", NAME : "MANGANESE", VALENTIA :7, SERIE : Series.TRANSITION},
	{SIMBOL : "Fe", NAME : "IRON", VALENTIA :6, SERIE : Series.TRANSITION},
	{SIMBOL : "Co", NAME : "COBALT", VALENTIA :3, SERIE : Series.TRANSITION},
	{SIMBOL : "Ni", NAME : "NICKEL", VALENTIA :3, SERIE : Series.TRANSITION},
	{SIMBOL : "Cu", NAME : "COPPER", VALENTIA :2, SERIE : Series.TRANSITION},
	{SIMBOL : "Zn", NAME : "ZINC", VALENTIA :2, SERIE : Series.TRANSITION},
	{SIMBOL : "Ga", NAME : "GALLIUM", VALENTIA :3, SERIE : Series.OTHERS},
	{SIMBOL : "Ge", NAME : "GERMANIUM", VALENTIA :4, SERIE : Series.SEMI},
	{SIMBOL : "As", NAME : "ARSENIC", VALENTIA :5, SERIE : Series.SEMI},
	{SIMBOL : "Se", NAME : "SELENIUM", VALENTIA :6, SERIE : Series.SEMI},
	{SIMBOL : "Br", NAME : "BROMINE", VALENTIA :7, SERIE : Series.HALOGEN},
	{SIMBOL : "Kr", NAME : "KRYPTON", VALENTIA :0, SERIE : Series.NOBLE},
	{SIMBOL : "Rb", NAME : "RUBIDIUM", VALENTIA :1, SERIE : Series.ALKALINE},
	{SIMBOL : "Sr", NAME : "STRONTIUM", VALENTIA :2, SERIE : Series.ALKALINE_EARTH},
	{SIMBOL : "Y", NAME : "YTTRIUM", VALENTIA :3, SERIE : Series.TRANSITION},
	{SIMBOL : "Zr", NAME : "ZIRCONIUM", VALENTIA :4, SERIE : Series.TRANSITION},
	{SIMBOL : "Nb", NAME : "NIOBIUM", VALENTIA :5, SERIE : Series.TRANSITION},
	{SIMBOL : "Mo", NAME : "MOLYBDENUM", VALENTIA :6, SERIE : Series.TRANSITION},
	{SIMBOL : "Tc", NAME : "TECHNETIUM", VALENTIA :7, SERIE : Series.TRANSITION},
	{SIMBOL : "Ru", NAME : "RUTHENIUM", VALENTIA :8, SERIE : Series.TRANSITION},
	{SIMBOL : "Rh", NAME : "RHODIUM", VALENTIA :6, SERIE : Series.TRANSITION},
	{SIMBOL : "Pd", NAME : "PALLADIUM", VALENTIA :4, SERIE : Series.TRANSITION},
	{SIMBOL : "Ag", NAME : "SILVER", VALENTIA :2, SERIE : Series.TRANSITION},
	{SIMBOL : "Cd", NAME : "CADMIUM", VALENTIA :2, SERIE : Series.TRANSITION},
	{SIMBOL : "In", NAME : "INDIUM", VALENTIA :3, SERIE : Series.OTHERS},
	{SIMBOL : "Sn", NAME : "TIN", VALENTIA :4, SERIE : Series.OTHERS},
	{SIMBOL : "Sb", NAME : "ANTIMONY", VALENTIA :5, SERIE : Series.SEMI},
	{SIMBOL : "Te", NAME : "TELLURIUM", VALENTIA :6, SERIE : Series.SEMI},
	{SIMBOL : "I", NAME : "IODINE", VALENTIA :7, SERIE : Series.HALOGEN},
	{SIMBOL : "Xe", NAME : "XENON", VALENTIA :0, SERIE : Series.NOBLE},
	{SIMBOL : "Cs", NAME : "CESIUM", VALENTIA :1, SERIE : Series.ALKALINE},
	{SIMBOL : "Ba", NAME : "BARIUM", VALENTIA :2, SERIE : Series.ALKALINE_EARTH},
	{SIMBOL : "La", NAME : "LANTHANUM", VALENTIA :3, SERIE : Series.LANTANIDIUM},
	{SIMBOL : "Ce", NAME : "CERIUM", VALENTIA :4, SERIE : Series.LANTANIDIUM},
	{SIMBOL : "Pr", NAME : "PRASEODYMIUM", VALENTIA :3, SERIE : Series.LANTANIDIUM},
	{SIMBOL : "Nd", NAME : "NEODYMIUM", VALENTIA :3, SERIE : Series.LANTANIDIUM},
	{SIMBOL : "Pm", NAME : "PROMETHIUM", VALENTIA :3, SERIE : Series.LANTANIDIUM},
	{SIMBOL : "Sm", NAME : "SAMARIUM", VALENTIA :3, SERIE : Series.LANTANIDIUM},
	{SIMBOL : "Eu", NAME : "EUROPIUM", VALENTIA :3, SERIE : Series.LANTANIDIUM},
	{SIMBOL : "Gd", NAME : "GADOLINIUM", VALENTIA :3, SERIE : Series.LANTANIDIUM},
	{SIMBOL : "Tb", NAME : "TERBIUM", VALENTIA :3, SERIE : Series.LANTANIDIUM},
	{SIMBOL : "Dy", NAME : "DYSPROSIUM", VALENTIA :3, SERIE : Series.LANTANIDIUM},
	{SIMBOL : "Ho", NAME : "HOLMIUM", VALENTIA :3, SERIE : Series.LANTANIDIUM},
	{SIMBOL : "Er", NAME : "ERBIUM", VALENTIA :3, SERIE : Series.LANTANIDIUM},
	{SIMBOL : "Tm", NAME : "THULIUM", VALENTIA :3, SERIE : Series.LANTANIDIUM},
	{SIMBOL : "Yb", NAME : "YTTERBIUM", VALENTIA :3, SERIE : Series.LANTANIDIUM},
	{SIMBOL : "Lu", NAME : "LUTETIUM", VALENTIA :3, SERIE : Series.LANTANIDIUM},
	{SIMBOL : "Hf", NAME : "HAFNIUM", VALENTIA :4, SERIE : Series.TRANSITION},
	{SIMBOL : "Ta", NAME : "TANTALUM", VALENTIA :5, SERIE : Series.TRANSITION},
	{SIMBOL : "W", NAME : "TUNGSTEN", VALENTIA :6, SERIE : Series.TRANSITION},
	{SIMBOL : "Re", NAME : "RHENIUM", VALENTIA :7, SERIE : Series.TRANSITION},
	{SIMBOL : "Os", NAME : "OSMIUM", VALENTIA :8, SERIE : Series.TRANSITION},
	{SIMBOL : "Ir", NAME : "IRIDIUM", VALENTIA :4, SERIE : Series.TRANSITION},
	{SIMBOL : "Pt", NAME : "PLATINUM", VALENTIA :4, SERIE : Series.TRANSITION},
	{SIMBOL : "Au", NAME : "GOLD", VALENTIA :3, SERIE : Series.TRANSITION},
	{SIMBOL : "Hg", NAME : "MERCURY", VALENTIA :2, SERIE : Series.TRANSITION},
	{SIMBOL : "Tl", NAME : "THALLIUM", VALENTIA :3, SERIE : Series.OTHERS},
	{SIMBOL : "Pb", NAME : "LEAD", VALENTIA :4, SERIE : Series.OTHERS},
	{SIMBOL : "Bi", NAME : "BISMUTH", VALENTIA :5, SERIE : Series.OTHERS},
	{SIMBOL : "Po", NAME : "POLONIUM", VALENTIA :4, SERIE : Series.OTHERS},
	{SIMBOL : "At", NAME : "ASTATINE", VALENTIA :7, SERIE : Series.HALOGEN},
	{SIMBOL : "Rn", NAME : "RADON", VALENTIA :0, SERIE : Series.NOBLE},
	{SIMBOL : "Fr", NAME : "FRANCIUM", VALENTIA :1, SERIE : Series.ALKALINE},
	{SIMBOL : "Ra", NAME : "RADIUM", VALENTIA :2, SERIE : Series.ALKALINE_EARTH},
	{SIMBOL : "Ac", NAME : "ACTINIUM", VALENTIA :3, SERIE : Series.ACTINIDIUM},
	{SIMBOL : "Th", NAME : "THORIUM", VALENTIA :4, SERIE : Series.ACTINIDIUM},
	{SIMBOL : "Pa", NAME : "PROTACTINIUM", VALENTIA :5, SERIE : Series.ACTINIDIUM},
	{SIMBOL : "U", NAME : "URANIUM", VALENTIA :6, SERIE : Series.ACTINIDIUM},
	{SIMBOL : "Np", NAME : "NEPTUNIUM", VALENTIA :6, SERIE : Series.ACTINIDIUM},
	{SIMBOL : "Pu", NAME : "PLUTONIUM", VALENTIA :6, SERIE : Series.ACTINIDIUM},
	{SIMBOL : "Am", NAME : "AMERICIUM", VALENTIA :6, SERIE : Series.ACTINIDIUM},
	{SIMBOL : "Cm", NAME : "CURIUM", VALENTIA :4, SERIE : Series.ACTINIDIUM},
	{SIMBOL : "Bk", NAME : "BERKELIUM", VALENTIA :4, SERIE : Series.ACTINIDIUM},
	{SIMBOL : "Cf", NAME : "CALIFORNIUM", VALENTIA :4, SERIE : Series.ACTINIDIUM},
	{SIMBOL : "Es", NAME : "EINSTEINIUM", VALENTIA :3, SERIE : Series.ACTINIDIUM},
	{SIMBOL : "Fm", NAME : "FERMIUM", VALENTIA :3, SERIE : Series.ACTINIDIUM},
	{SIMBOL : "Md", NAME : "MENDELEVIUM", VALENTIA :3, SERIE : Series.ACTINIDIUM},
	{SIMBOL : "No", NAME : "NOBELIUM", VALENTIA :3, SERIE : Series.ACTINIDIUM},
	{SIMBOL : "Lr", NAME : "LAWRENCIUM", VALENTIA :2, SERIE : Series.ACTINIDIUM},
	{SIMBOL : "Rf", NAME : "RUTHERFORDIUM", VALENTIA :4, SERIE : Series.TRANSITION},
	{SIMBOL : "Db", NAME : "DUBNIUM", VALENTIA :5, SERIE : Series.TRANSITION},
	{SIMBOL : "Sg", NAME : "SEABORGIUM", VALENTIA :6, SERIE : Series.TRANSITION},
	{SIMBOL : "Bh", NAME : "BOHRIUM", VALENTIA :7, SERIE : Series.TRANSITION},
	{SIMBOL : "Hs", NAME : "HASSIUM", VALENTIA :8, SERIE : Series.TRANSITION},
	{SIMBOL : "Mt", NAME : "MEITNERIUM", VALENTIA :4, SERIE : Series.TRANSITION},
	{SIMBOL : "Ds", NAME : "DARMSTADTIUM", VALENTIA :4, SERIE : Series.TRANSITION},
	{SIMBOL : "Rg", NAME : "ROENTGENIUM", VALENTIA :3, SERIE : Series.TRANSITION},
	{SIMBOL : "Cn", NAME : "COPERNICIUM", VALENTIA :2, SERIE : Series.TRANSITION},
	{SIMBOL : "Nh", NAME : "NIHONIUM", VALENTIA :3, SERIE : Series.OTHERS},
	{SIMBOL : "Fl", NAME : "FLEROVIUM", VALENTIA :4, SERIE : Series.OTHERS},
	{SIMBOL : "Mc", NAME : "MOSCOVIUM", VALENTIA :5, SERIE : Series.OTHERS},
	{SIMBOL : "Lv", NAME : "LIVERMORIUM", VALENTIA :6, SERIE : Series.OTHERS},
	{SIMBOL : "Ts", NAME : "TENNESSINE", VALENTIA :6, SERIE : Series.HALOGEN},
	{SIMBOL : "Og", NAME : "OGANESSON", VALENTIA :0, SERIE : Series.NOBLE},
	{SIMBOL : "Uue", NAME : "UNUNENNUIUM", VALENTIA :1, SERIE : Series.ALKALINE},
]

var max_eletrons: int
## valor de ataque, é variável, ou seja, esse valor pode mudar de acordo com oque acontece durante o jogo.
var eletrons: int

var max_neutrons: int
## isotopo, geralmente o mesmo valor q o numero atomico, determina a vida.
var neutrons: int:
	set(value):
		neutrons = value
		if neutrons < 0:
			Gameplay.arena.call_deferred("remove_element", grid_position)

var max_valentia: int
## Indica quantos links esse elemento pode ter em simultâneo.
var valentia: int
@onready var number_electrons_in_valencia: int = valentia

## isso é basicamente oque define que tipo de elemento é, seu valor é o custo para instanciar.
@export var atomic_number: int

## Dicionario que define os efeitos em seus tempos de ação:[br]
## [codeblock]
## {ActionTime.INIT: Callable(self, "nome_da_func")}
## {ActionTime.INIT: nome_da_func)}
## [/codeblock]
var action_time: Dictionary

var links = {
	Vector2i.UP: null, Vector2i.DOWN: null, Vector2i.LEFT: null, Vector2i.RIGHT: null
}

var disabled: bool:
	set(value):
		disabled = value
		legancy.set_fade(float(!value))

var active: bool:
	set(value):
		active = value
		disabled = !active
		if not active:
			_set_current_node_state(NodeState.NORMAL)

# {PassiveEffect.Debuff.Type: PassiveEffect.DebuffEffect}
var debuffs: Dictionary
var buffs: Dictionary
var skill_effect: SkillEffect
var molecule_effect: MoleculeEffect

#var current_state: State
var current_node_state: NodeState
var position_offset: Vector2
var selected: bool

var grid_position: Vector2i

var legancy: Panel = LEGANCY.instantiate()
var glow: Sprite2D = GLOW.instantiate()

var has_link: bool:
	get:
		for link in links:
			if links[link]: return true
		
		return false


func can_link(ref: Element):
	if number_electrons_in_valencia == 0:
		return false
	
	if not has_link:
		return true
	
	for link in links:
		if links[link] and links[link].level < 3 and (links[link].element_A == ref or links[link].element_B == ref):
			return true
	
	for link in links:
		if not links[link]:
			return true
	
	return false


func _init():
	custom_minimum_size = Vector2(80, 80)
	focus_mode = Control.FOCUS_NONE
	add_child(legancy)
	add_child(glow)
	glow.position = Vector2(40, 40)


func _ready():
	legancy.modulate = COLOR_SERIES[DATA[atomic_number][SERIE]]
	mouse_entered.connect(_mouse_entered)
	mouse_exited .connect(_mouse_exited )


func _process(delta):
	queue_redraw()
	# dar uma corzinha pra tudo
	modulate = (Color.WHITE * 0.7) +  (COLOR_SERIES[DATA[atomic_number][SERIE]] * 0.3)
	modulate.a = 1.0
	glow.modulate = COLOR_SERIES[DATA[atomic_number][SERIE]] if active else Color(0.1, 0.1, 0.1, 1.0)


func _draw_ligaments():
	for link in links:
		var ligament : Molecule.Ligament = links[link]
		if not ligament:
			continue
		
		for i in ligament.level:
			var p = (i * LIGAMENT_SPACCAMENT) - (ligament.level / 2.0 * LIGAMENT_SPACCAMENT) + LIGAMENT_SIDE_SPACCAMENT
			var base = Vector2(40, 40) - (Vector2(Vector2i.ONE - abs(link)) * p)
			
			draw_line(
					base + Vector2(-link) * (Vector2(30, 30)),
					base + Vector2(-link) * (Vector2(45, 45)),
					Color.WHITE, 5, true
			)


func _draw():
	# desenhar os ligamentos
	if has_link:
		_draw_ligaments()
	
	# desenhar o retangulo
	var alpha: float = 0.5
	if current_node_state == NodeState.HOVER or current_node_state == NodeState.SELECTED:
		alpha = 0.7
	
	alpha += 0.3 if active else 0.0
	
	draw_texture_rect(SLOT, Rect2(-8, -8, 96, 96), false, Color.WHITE * alpha)
	
	# obter a cor
	var symbol_color: Color = COLOR_SERIES[DATA[atomic_number][SERIE]]
	if not active:
		var gray := (symbol_color.r + symbol_color.g + symbol_color.b) / 3.0
		symbol_color = Color(gray, gray, gray)
	
	# escrever simbolo centralizado
	var string_size = FUTURE_SALLOW.get_string_size(
			DATA[atomic_number][SIMBOL], HORIZONTAL_ALIGNMENT_CENTER, -1, FONT_SIZE
	) / 2
	draw_string(
			FUTURE_SALLOW, Vector2(41 - string_size.x, ((string_size.y + 7) / 2) + 40) + position_offset,
			DATA[atomic_number][SIMBOL], HORIZONTAL_ALIGNMENT_CENTER, -1, FONT_SIZE, symbol_color
	)
	# atomic number
	draw_string(
			GIANT_ROBOT, Vector2(11, 16), str(neutrons +1), HORIZONTAL_ALIGNMENT_RIGHT,
			-1, FONT_ATRIBUTES_SIZE, symbol_color
	)
	# eletrons
	var eletrons_string_size = GIANT_ROBOT.get_string_size(
			str(eletrons), HORIZONTAL_ALIGNMENT_LEFT, -1, FONT_ATRIBUTES_SIZE
	)
	draw_string(
			GIANT_ROBOT, Vector2(68 - eletrons_string_size.x, 16), str(eletrons),
			HORIZONTAL_ALIGNMENT_LEFT, 200, FONT_ATRIBUTES_SIZE, symbol_color
	)
	# icone de passivo
	if not debuffs.is_empty():
		for i in min(debuffs.size(), MAX_PASSIVE_ICON):
			draw_texture_rect_region(
					ICON_PASSIVE, Rect2(70, 69 - (i * 9), 14, 10), Rect2(17, 0, 15, 11)
			)
	
	if not buffs.is_empty():
		for i in min(buffs.size(), MAX_PASSIVE_ICON):
			draw_texture_rect_region(
					ICON_PASSIVE, Rect2(-5, 69 - (i * 9), 14, 10), Rect2(0, 0, 15, 11)
			)


func _exit_tree():
	if Gameplay.selected_element == self:
		Gameplay.selected_element = null
	
	if skill_effect:
		skill_effect.unregister(0)


func build(_atomic_number: int):
	atomic_number = min(_atomic_number, DATA.size())
	eletrons = atomic_number + 1
	neutrons = atomic_number
	valentia = DATA[atomic_number][VALENTIA]
	tooltip_text = DATA[atomic_number][NAME]
	
#	if SkillEffect.BOOK.has(atomic_number):
#		skill_effect = SkillEffect.BOOK[atomic_number][0].new(self)
#
#	if MoleculeEffect.BOOK.has(atomic_number):
#		molecule_effect = MoleculeEffect.BOOK[atomic_number][0].new(self)


func reset():
	disabled = false
	if debuffs.is_empty() and neutrons > 0:
		neutrons = atomic_number
		
	eletrons = atomic_number +1


func _set_current_node_state(state: NodeState):
	if current_node_state == state: return

	if current_node_state == NodeState.SELECTED:
		selected_changed.emit(false)

	current_node_state = state

	if current_node_state == NodeState.SELECTED:
		Gameplay.selected_element = self
		selected_changed.emit(true)


func _mouse_entered():
	if active:
		_set_current_node_state(NodeState.HOVER)
	
	mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN


func _mouse_exited():
	if active:
		_set_current_node_state(NodeState.NORMAL)


func _is_neighbor_to_link():
	var x: int = abs(Gameplay.selected_element.grid_position.x - grid_position.x)
	var y: int = abs(Gameplay.selected_element.grid_position.y - grid_position.y)
	return (x == 1 and y != 1) or (x != 1 and y == 1)
