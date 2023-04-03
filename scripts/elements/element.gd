## Classe que define os elementos.
class_name Element extends Control

signal selected_changed(value: bool)

## Tempos de ação dos efeitos, quando eles irão ser execultados.
enum ActionTime {
	PRE_INIT, INIT, INSTANTIATED, MOVED, LINKED, UNLINKED, BAKED, DIED, ATTACK, DEFEND, END_TURN
}
enum {
	ALKALINE, ALKALINE_EARTH, LANTANIDIUM, ACTINIDIUM, TRANSITION, OTHERS, SEMI, METALLOID, HALOGEN, NOBLE, UNKNOWN
}
enum {
	SIMBOL, NAME, VALENTIA, SERIE
}
#enum State {
#	NORMAL, BIND_LINK, REMOVE_LINK, ATTACKING, DEFENDING, MOTION, COOKING
#}
enum NodeState {
	NORMAL, HOVER, SELECTED
}

const FUTURE_SALLOW := preload("res://assets/fonts/Future Sallow.ttf")
const GIANT_ROBOT := preload("res://assets/fonts/GiantRobotArmy-Medium.ttf")
const SLOT := preload("res://assets/img/elements/Slot_0.png")
const LEGANCY := preload("res://scenes/elements/legancy.tscn")
const GLOW := preload("res://scenes/elements/glow.tscn")

const FONT_SIZE := 48.0
const COLOR_SERIES = {
	ALKALINE:		Color("f05459"),
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
	{SIMBOL : "H", NAME : "HIDROGÊNIO", VALENTIA :1, SERIE : METALLOID},
	{SIMBOL : "He", NAME : "HÉLIO", VALENTIA :0, SERIE : NOBLE},
	{SIMBOL : "Li", NAME : "LÍTIO", VALENTIA :1, SERIE : ALKALINE},
	{SIMBOL : "Be", NAME : "BERÍLIO", VALENTIA :2, SERIE : ALKALINE_EARTH},
	{SIMBOL : "B", NAME : "BORO", VALENTIA :3, SERIE : SEMI},
	{SIMBOL : "C", NAME : "CARBONO", VALENTIA :4, SERIE : METALLOID},
	{SIMBOL : "N", NAME : "AZOTO", VALENTIA :5, SERIE : METALLOID},
	{SIMBOL : "O", NAME : "OXIGÊNIO", VALENTIA :2, SERIE : METALLOID},
	{SIMBOL : "F", NAME : "FLÚOR", VALENTIA :1, SERIE : HALOGEN},
	{SIMBOL : "Ne", NAME : "NÉON", VALENTIA :0, SERIE : NOBLE},
	{SIMBOL : "Na", NAME : "SÓDIO", VALENTIA :1, SERIE : ALKALINE},
	{SIMBOL : "Mg", NAME : "MAGNÉSIO", VALENTIA :2, SERIE : ALKALINE_EARTH},
	{SIMBOL : "Al", NAME : "ALUMÍNIO", VALENTIA :3, SERIE : OTHERS},
	{SIMBOL : "Si", NAME : "SILÍCIO", VALENTIA :4, SERIE : SEMI},
	{SIMBOL : "P", NAME : "FÓSFORO", VALENTIA :5, SERIE : METALLOID},
	{SIMBOL : "S", NAME : "ENXOFRE", VALENTIA :6, SERIE : METALLOID},
	{SIMBOL : "Cl", NAME : "CLORO", VALENTIA :7, SERIE : HALOGEN},
	{SIMBOL : "Ar", NAME : "ARGÔNIO", VALENTIA :0, SERIE : NOBLE},
	{SIMBOL : "K", NAME : "POTÁSSIO", VALENTIA :1, SERIE : ALKALINE},
	{SIMBOL : "Ca", NAME : "CÁLCIO", VALENTIA :2, SERIE : ALKALINE_EARTH},
	{SIMBOL : "Sc", NAME : "ESCÂNDIO", VALENTIA :3, SERIE : TRANSITION},
	{SIMBOL : "Ti", NAME : "TITÂNIO", VALENTIA :4, SERIE : TRANSITION},
	{SIMBOL : "V", NAME : "VANÁDIO", VALENTIA :5, SERIE : TRANSITION},
	{SIMBOL : "Cr", NAME : "CROMO", VALENTIA :6, SERIE : TRANSITION},
	{SIMBOL : "Mn", NAME : "MANGANÊS", VALENTIA :7, SERIE : TRANSITION},
	{SIMBOL : "Fe", NAME : "FERRO", VALENTIA :6, SERIE : TRANSITION},
	{SIMBOL : "Co", NAME : "COBALTO", VALENTIA :3, SERIE : TRANSITION},
	{SIMBOL : "Ni", NAME : "NÍQUEL", VALENTIA :3, SERIE : TRANSITION},
	{SIMBOL : "Cu", NAME : "COBRE", VALENTIA :2, SERIE : TRANSITION},
	{SIMBOL : "Zn", NAME : "ZINCO", VALENTIA :2, SERIE : TRANSITION},
	{SIMBOL : "Ga", NAME : "GÁLIO", VALENTIA :3, SERIE : OTHERS},
	{SIMBOL : "Ge", NAME : "GERMÂNIO", VALENTIA :4, SERIE : SEMI},
	{SIMBOL : "As", NAME : "ARSÊNICO", VALENTIA :5, SERIE : SEMI},
	{SIMBOL : "Se", NAME : "SELÊNIO", VALENTIA :6, SERIE : SEMI},
	{SIMBOL : "Br", NAME : "BROMO", VALENTIA :7, SERIE : HALOGEN},
	{SIMBOL : "Kr", NAME : "KRYPTON", VALENTIA :0, SERIE : NOBLE},
	{SIMBOL : "Rb", NAME : "RUBÍDIO", VALENTIA :1, SERIE : ALKALINE},
	{SIMBOL : "Sr", NAME : "ESTRÔNCIO", VALENTIA :2, SERIE : ALKALINE_EARTH},
	{SIMBOL : "Y", NAME : "ÍTRIO", VALENTIA :3, SERIE : TRANSITION},
	{SIMBOL : "Zr", NAME : "ZIRCÔNIO", VALENTIA :4, SERIE : TRANSITION},
	{SIMBOL : "Nb", NAME : "NIÓBIO", VALENTIA :5, SERIE : TRANSITION},
	{SIMBOL : "Mo", NAME : "MOLIBDÊNIO", VALENTIA :6, SERIE : TRANSITION},
	{SIMBOL : "Tc", NAME : "TECNÉCIO", VALENTIA :7, SERIE : TRANSITION},
	{SIMBOL : "Ru", NAME : "RUTÊNIO", VALENTIA :8, SERIE : TRANSITION},
	{SIMBOL : "Rh", NAME : "RÓDIO", VALENTIA :6, SERIE : TRANSITION},
	{SIMBOL : "Pd", NAME : "PALÁDIO", VALENTIA :4, SERIE : TRANSITION},
	{SIMBOL : "Ag", NAME : "PRATA", VALENTIA :2, SERIE : TRANSITION},
	{SIMBOL : "Cd", NAME : "CÁDMIO", VALENTIA :2, SERIE : TRANSITION},
	{SIMBOL : "In", NAME : "ÍNDIO", VALENTIA :3, SERIE : OTHERS},
	{SIMBOL : "Sn", NAME : "ESTANHO", VALENTIA :4, SERIE : OTHERS},
	{SIMBOL : "Sb", NAME : "ANTIMÔNIO", VALENTIA :5, SERIE : SEMI},
	{SIMBOL : "Te", NAME : "TELÚRIO", VALENTIA :6, SERIE : SEMI},
	{SIMBOL : "I", NAME : "IODO", VALENTIA :7, SERIE : HALOGEN},
	{SIMBOL : "Xe", NAME : "XENÔNIO", VALENTIA :0, SERIE : NOBLE},
	{SIMBOL : "Cs", NAME : "CÉSIO", VALENTIA :1, SERIE : ALKALINE},
	{SIMBOL : "Ba", NAME : "BÁRIO", VALENTIA :2, SERIE : ALKALINE_EARTH},
	{SIMBOL : "La", NAME : "LANTÂNIO", VALENTIA :3, SERIE : LANTANIDIUM},
	{SIMBOL : "Ce", NAME : "CÉRIO", VALENTIA :4, SERIE : LANTANIDIUM},
	{SIMBOL : "Pr", NAME : "PRASEODÍMIO", VALENTIA :3, SERIE : LANTANIDIUM},
	{SIMBOL : "Nd", NAME : "NEODÍMIO", VALENTIA :3, SERIE : LANTANIDIUM},
	{SIMBOL : "Pm", NAME : "PROMÉCIO", VALENTIA :3, SERIE : LANTANIDIUM},
	{SIMBOL : "Sm", NAME : "SAMÁRIO", VALENTIA :3, SERIE : LANTANIDIUM},
	{SIMBOL : "Eu", NAME : "EUROPA", VALENTIA :3, SERIE : LANTANIDIUM},
	{SIMBOL : "Gd", NAME : "GADOLÍNIO", VALENTIA :3, SERIE : LANTANIDIUM},
	{SIMBOL : "Tb", NAME : "TÉRBIO", VALENTIA :3, SERIE : LANTANIDIUM},
	{SIMBOL : "Dy", NAME : "DISPRÓSIO", VALENTIA :3, SERIE : LANTANIDIUM},
	{SIMBOL : "Ho", NAME : "HÓLMIO", VALENTIA :3, SERIE : LANTANIDIUM},
	{SIMBOL : "Er", NAME : "ÉRBIO", VALENTIA :3, SERIE : LANTANIDIUM},
	{SIMBOL : "Tm", NAME : "TÚLIO", VALENTIA :3, SERIE : LANTANIDIUM},
	{SIMBOL : "Yb", NAME : "ITÉRBIO", VALENTIA :3, SERIE : LANTANIDIUM},
	{SIMBOL : "Lu", NAME : "PARIS", VALENTIA :3, SERIE : LANTANIDIUM},
	{SIMBOL : "Hf", NAME : "HÁFNIO", VALENTIA :4, SERIE : TRANSITION},
	{SIMBOL : "Ta", NAME : "TÂNTALO", VALENTIA :5, SERIE : TRANSITION},
	{SIMBOL : "W", NAME : "TUNGSTÊNIO", VALENTIA :6, SERIE : TRANSITION},
	{SIMBOL : "Re", NAME : "RÊNIO", VALENTIA :7, SERIE : TRANSITION},
	{SIMBOL : "Os", NAME : "ÓSMIO", VALENTIA :8, SERIE : TRANSITION},
	{SIMBOL : "Ir", NAME : "IRÍDIO", VALENTIA :4, SERIE : TRANSITION},
	{SIMBOL : "Pt", NAME : "PLATINA", VALENTIA :4, SERIE : TRANSITION},
	{SIMBOL : "Au", NAME : "OURO", VALENTIA :3, SERIE : TRANSITION},
	{SIMBOL : "Hg", NAME : "MERCÚRIO", VALENTIA :2, SERIE : TRANSITION},
	{SIMBOL : "Tl", NAME : "TÁLIO", VALENTIA :3, SERIE : OTHERS},
	{SIMBOL : "Pb", NAME : "LIDERAR", VALENTIA :4, SERIE : OTHERS},
	{SIMBOL : "Bi", NAME : "BISMUTO", VALENTIA :5, SERIE : OTHERS},
	{SIMBOL : "Po", NAME : "POLÔNIO", VALENTIA :4, SERIE : OTHERS},
	{SIMBOL : "At", NAME : "ASTATO", VALENTIA :7, SERIE : HALOGEN},
	{SIMBOL : "Rn", NAME : "RADÔNIO", VALENTIA :0, SERIE : NOBLE},
	{SIMBOL : "Fr", NAME : "FRÂNCIO", VALENTIA :1, SERIE : ALKALINE},
	{SIMBOL : "Ra", NAME : "RÁDIO", VALENTIA :2, SERIE : ALKALINE_EARTH},
	{SIMBOL : "Ac", NAME : "ACTÍNIO", VALENTIA :3, SERIE : ACTINIDIUM},
	{SIMBOL : "Th", NAME : "TÓRIO", VALENTIA :4, SERIE : ACTINIDIUM},
	{SIMBOL : "Pa", NAME : "PROTACTÍNIO", VALENTIA :5, SERIE : ACTINIDIUM},
	{SIMBOL : "U", NAME : "URÂNIO", VALENTIA :6, SERIE : ACTINIDIUM},
	{SIMBOL : "Np", NAME : "NETUNO", VALENTIA :6, SERIE : ACTINIDIUM},
	{SIMBOL : "Pu", NAME : "PLUTÔNIO", VALENTIA :6, SERIE : ACTINIDIUM},
	{SIMBOL : "Am", NAME : "AMERÍCIO", VALENTIA :6, SERIE : ACTINIDIUM},
	{SIMBOL : "Cm", NAME : "TRIBUNAL", VALENTIA :4, SERIE : ACTINIDIUM},
	{SIMBOL : "Bk", NAME : "BERQUÉLIO", VALENTIA :4, SERIE : ACTINIDIUM},
	{SIMBOL : "Cf", NAME : "CALIFÓRNIA", VALENTIA :4, SERIE : ACTINIDIUM},
	{SIMBOL : "Es", NAME : "EINSTEINIUM", VALENTIA :3, SERIE : ACTINIDIUM},
	{SIMBOL : "Fm", NAME : "FÉRMIO", VALENTIA :3, SERIE : ACTINIDIUM},
	{SIMBOL : "Md", NAME : "MENDELEEV", VALENTIA :3, SERIE : ACTINIDIUM},
	{SIMBOL : "No", NAME : "NOBRE", VALENTIA :3, SERIE : ACTINIDIUM},
	{SIMBOL : "Lr", NAME : "LAURÊNCIO", VALENTIA :2, SERIE : ACTINIDIUM},
	{SIMBOL : "Rf", NAME : "RUTHERFÓRDIO", VALENTIA :4, SERIE : TRANSITION},
	{SIMBOL : "Db", NAME : "DÚBNIO", VALENTIA :5, SERIE : TRANSITION},
	{SIMBOL : "Sg", NAME : "SEABORGIO", VALENTIA :6, SERIE : TRANSITION},
	{SIMBOL : "Bh", NAME : "BOHRIUM", VALENTIA :7, SERIE : TRANSITION},
	{SIMBOL : "Hs", NAME : "HÁSSIO", VALENTIA :8, SERIE : TRANSITION},
	{SIMBOL : "Mt", NAME : "MEITNÉRIO", VALENTIA :4, SERIE : TRANSITION},
	{SIMBOL : "Ds", NAME : "DARMSTADTIUM", VALENTIA :4, SERIE : TRANSITION},
	{SIMBOL : "Rg", NAME : "ROENTGENIUM", VALENTIA :3, SERIE : TRANSITION},
	{SIMBOL : "Cn", NAME : "COPÉRNICIO", VALENTIA :2, SERIE : TRANSITION},
	{SIMBOL : "Nh", NAME : "NIHÔNIO", VALENTIA :3, SERIE : OTHERS},
	{SIMBOL : "Fl", NAME : "FLERÓVIO", VALENTIA :4, SERIE : OTHERS},
	{SIMBOL : "Mc", NAME : "MOSCÓVIO", VALENTIA :5, SERIE : OTHERS},
	{SIMBOL : "Lv", NAME : "LIVERMÓRIO", VALENTIA :6, SERIE : OTHERS},
	{SIMBOL : "Ts", NAME : "TENESSO", VALENTIA :6, SERIE : HALOGEN},
	{SIMBOL : "Og", NAME : "OGANESSÔNIO", VALENTIA :0, SERIE : NOBLE},
	{SIMBOL : "Uue", NAME : "UNUNÉNNIO", VALENTIA :1, SERIE : ALKALINE},
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
			Gameplay.arena.remove_element(grid_position)

var max_valentia: int
## Indica quantos links esse elemento pode ter em simultâneo.
var valentia: int
@onready var number_electrons_in_valencia: int = valentia

## isso é basicamente oque define que tipo de elemento é, seu valor é o custo para instanciar.
@export var atomic_number: int:
	set(value):
		atomic_number = value
		eletrons = value if not max_eletrons else max_eletrons
		neutrons = value if not max_neutrons else max_neutrons
		valentia = DATA[atomic_number][VALENTIA] if not max_valentia else max_valentia
		tooltip_text = DATA[atomic_number][NAME]
		
		if not effect and SkillEffect.BOOK.has(atomic_number):
			effect = SkillEffect.BOOK[atomic_number].new(self)

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

var has_link: bool:
	get:
		for link in links:
			if links[link]: return true
		
		return false

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
var effect: SkillEffect

#var current_state: State
var current_node_state: NodeState
var position_offset: Vector2
var selected: bool

var legancy: Panel = LEGANCY.instantiate()
var glow: Sprite2D = GLOW.instantiate()


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


func _draw_ligaments():
	for link in links:
		var ligament : Molecule.Ligament = links[link]
		if not ligament:
			continue
		
		for i in ligament.level:
			var p = (i * 10.0) - (ligament.level / 2.0 * 10.0) + 5.0
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
			GIANT_ROBOT, Vector2(11, 16), str(neutrons +1), HORIZONTAL_ALIGNMENT_RIGHT, -1, 12, symbol_color
	)
	
	# eletrons
	var eletrons_string_size = GIANT_ROBOT.get_string_size(str(eletrons +1), HORIZONTAL_ALIGNMENT_LEFT, -1, 12)
	draw_string(
			GIANT_ROBOT, Vector2(68 - eletrons_string_size.x, 16), str(eletrons +1),
			HORIZONTAL_ALIGNMENT_LEFT, 200, 12, symbol_color
	)
	
	# dar uma corzinha pra tudo
	modulate = (Color.WHITE * 0.7) +  (COLOR_SERIES[DATA[atomic_number][SERIE]] * 0.3)
	modulate.a = 1.0
	glow.modulate = COLOR_SERIES[DATA[atomic_number][SERIE]] if active else Color(0.1, 0.1, 0.1, 1.0)


func _exit_tree():
	if Gameplay.selected_element == self:
		Gameplay.selected_element = null
	
	if effect:
		effect.unregister(0)


func reset():
	if neutrons == atomic_number:
		eletrons = atomic_number
	
	else:
		neutrons = neutrons + signi(atomic_number - neutrons)
		eletrons = neutrons


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
