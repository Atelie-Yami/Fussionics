class_name GameBook extends Node

enum Sagas {
	TUTORIAL, MAKINO, CHAM_INK
}
enum PhaseConfig {
	NORMAL, MINIBOSS_A, MINIBOSS_B, MINIBOSS_C, BOSS
}
enum Campagn {
	PHASES_CONFIG, NORMAL_PHASE_ID, MINIBOSS_A_ID, MINIBOSS_B_ID, MINIBOSS_C_ID, BOSS_ID,
	SKINS, BOTS
}
enum Series {
	ALKALINE, ALKALINE_EARTH, LANTANIDIUM, ACTINIDIUM, TRANSITION, OTHERS, SEMI, METALLOID, HALOGEN, NOBLE, UNKNOWN
}
enum {
	SYMBOL, NAME, VALENCY, SERIE
}
enum Ranking {
	NORMAL,   ## sem efeito, isso aq não é utilizado, mas serve pra fazer o proximo ter valor de 1
	IMPROVED, ## tem um efeito simples
	ENHANCED, ## tem um efeito significativo
	ELITE,    ## tem um efeito poderoso
}
enum EffectType {
	SKILL,    ## age quando estiver sem link
	MOLECULE, ## age quando estiver em molecula
}
const DECK := [[], [], [], [], [], [], [], [], [], [], [], []]
const COLOR_SERIES = {
	Series.ALKALINE:       Color("f05459"),
	Series.ALKALINE_EARTH: Color('FF8A3D'),
	Series.LANTANIDIUM:    Color('D323BC'),
	Series.ACTINIDIUM:     Color('00E42F'),
	Series.TRANSITION:     Color('4AB593'),
	Series.OTHERS:         Color('5994FF'),
	Series.SEMI:           Color('C294FF'),
	Series.METALLOID:      Color('00FFFF'),
	Series.HALOGEN:        Color('CEC469'),
	Series.NOBLE:          Color('84D89E'),
	Series.UNKNOWN:        Color('A0A0A0'),
}
const ELEMENTS = [
	{SYMBOL : "H", NAME : "HYDROGEN", VALENCY :1, SERIE : Series.METALLOID},
	{SYMBOL : "He", NAME : "HELIUM", VALENCY :0, SERIE : Series.NOBLE},
	{SYMBOL : "Li", NAME : "LITHIUM", VALENCY :1, SERIE : Series.ALKALINE},
	{SYMBOL : "Be", NAME : "BERYLLIUM", VALENCY :2, SERIE : Series.ALKALINE_EARTH},
	{SYMBOL : "B", NAME : "BORON", VALENCY :3, SERIE : Series.SEMI},
	{SYMBOL : "C", NAME : "CARBON", VALENCY :4, SERIE : Series.METALLOID},
	{SYMBOL : "N", NAME : "NITROGEN", VALENCY :5, SERIE : Series.METALLOID},
	{SYMBOL : "O", NAME : "OXYGEN", VALENCY :2, SERIE : Series.METALLOID},
	{SYMBOL : "F", NAME : "FLUORINE", VALENCY :1, SERIE : Series.HALOGEN},
	{SYMBOL : "Ne", NAME : "NEON", VALENCY :0, SERIE : Series.NOBLE},
	{SYMBOL : "Na", NAME : "SODIUM", VALENCY :1, SERIE : Series.ALKALINE},
	{SYMBOL : "Mg", NAME : "MAGNESIUM", VALENCY :2, SERIE : Series.ALKALINE_EARTH},
	{SYMBOL : "Al", NAME : "ALUMINIUM", VALENCY :3, SERIE : Series.OTHERS},
	{SYMBOL : "Si", NAME : "SILICON", VALENCY :4, SERIE : Series.SEMI},
	{SYMBOL : "P", NAME : "PHOSPHORUS", VALENCY :5, SERIE : Series.METALLOID},
	{SYMBOL : "S", NAME : "SULFUR", VALENCY :6, SERIE : Series.METALLOID},
	{SYMBOL : "Cl", NAME : "CHLORINE", VALENCY :7, SERIE : Series.HALOGEN},
	{SYMBOL : "Ar", NAME : "ARGON", VALENCY :0, SERIE : Series.NOBLE},
	{SYMBOL : "K", NAME : "POTASSIUM", VALENCY :1, SERIE : Series.ALKALINE},
	{SYMBOL : "Ca", NAME : "CALCIUM", VALENCY :2, SERIE : Series.ALKALINE_EARTH},
	{SYMBOL : "Sc", NAME : "SCANDIUM", VALENCY :3, SERIE : Series.TRANSITION},
	{SYMBOL : "Ti", NAME : "TITANIUM", VALENCY :4, SERIE : Series.TRANSITION},
	{SYMBOL : "V", NAME : "VANADIUM", VALENCY :5, SERIE : Series.TRANSITION},
	{SYMBOL : "Cr", NAME : "CHROMIUM", VALENCY :6, SERIE : Series.TRANSITION},
	{SYMBOL : "Mn", NAME : "MANGANESE", VALENCY :7, SERIE : Series.TRANSITION},
	{SYMBOL : "Fe", NAME : "IRON", VALENCY :6, SERIE : Series.TRANSITION},
	{SYMBOL : "Co", NAME : "COBALT", VALENCY :3, SERIE : Series.TRANSITION},
	{SYMBOL : "Ni", NAME : "NICKEL", VALENCY :3, SERIE : Series.TRANSITION},
	{SYMBOL : "Cu", NAME : "COPPER", VALENCY :2, SERIE : Series.TRANSITION},
	{SYMBOL : "Zn", NAME : "ZINC", VALENCY :2, SERIE : Series.TRANSITION},
	{SYMBOL : "Ga", NAME : "GALLIUM", VALENCY :3, SERIE : Series.OTHERS},
	{SYMBOL : "Ge", NAME : "GERMANIUM", VALENCY :4, SERIE : Series.SEMI},
	{SYMBOL : "As", NAME : "ARSENIC", VALENCY :5, SERIE : Series.SEMI},
	{SYMBOL : "Se", NAME : "SELENIUM", VALENCY :6, SERIE : Series.SEMI},
	{SYMBOL : "Br", NAME : "BROMINE", VALENCY :7, SERIE : Series.HALOGEN},
	{SYMBOL : "Kr", NAME : "KRYPTON", VALENCY :0, SERIE : Series.NOBLE},
	{SYMBOL : "Rb", NAME : "RUBIDIUM", VALENCY :1, SERIE : Series.ALKALINE},
	{SYMBOL : "Sr", NAME : "STRONTIUM", VALENCY :2, SERIE : Series.ALKALINE_EARTH},
	{SYMBOL : "Y", NAME : "YTTRIUM", VALENCY :3, SERIE : Series.TRANSITION},
	{SYMBOL : "Zr", NAME : "ZIRCONIUM", VALENCY :4, SERIE : Series.TRANSITION},
	{SYMBOL : "Nb", NAME : "NIOBIUM", VALENCY :5, SERIE : Series.TRANSITION},
	{SYMBOL : "Mo", NAME : "MOLYBDENUM", VALENCY :6, SERIE : Series.TRANSITION},
	{SYMBOL : "Tc", NAME : "TECHNETIUM", VALENCY :7, SERIE : Series.TRANSITION},
	{SYMBOL : "Ru", NAME : "RUTHENIUM", VALENCY :8, SERIE : Series.TRANSITION},
	{SYMBOL : "Rh", NAME : "RHODIUM", VALENCY :6, SERIE : Series.TRANSITION},
	{SYMBOL : "Pd", NAME : "PALLADIUM", VALENCY :4, SERIE : Series.TRANSITION},
	{SYMBOL : "Ag", NAME : "SILVER", VALENCY :2, SERIE : Series.TRANSITION},
	{SYMBOL : "Cd", NAME : "CADMIUM", VALENCY :2, SERIE : Series.TRANSITION},
	{SYMBOL : "In", NAME : "INDIUM", VALENCY :3, SERIE : Series.OTHERS},
	{SYMBOL : "Sn", NAME : "TIN", VALENCY :4, SERIE : Series.OTHERS},
	{SYMBOL : "Sb", NAME : "ANTIMONY", VALENCY :5, SERIE : Series.SEMI},
	{SYMBOL : "Te", NAME : "TELLURIUM", VALENCY :6, SERIE : Series.SEMI},
	{SYMBOL : "I", NAME : "IODINE", VALENCY :7, SERIE : Series.HALOGEN},
	{SYMBOL : "Xe", NAME : "XENON", VALENCY :0, SERIE : Series.NOBLE},
	{SYMBOL : "Cs", NAME : "CESIUM", VALENCY :1, SERIE : Series.ALKALINE},
	{SYMBOL : "Ba", NAME : "BARIUM", VALENCY :2, SERIE : Series.ALKALINE_EARTH},
	{SYMBOL : "La", NAME : "LANTHANUM", VALENCY :3, SERIE : Series.LANTANIDIUM},
	{SYMBOL : "Ce", NAME : "CERIUM", VALENCY :4, SERIE : Series.LANTANIDIUM},
	{SYMBOL : "Pr", NAME : "PRASEODYMIUM", VALENCY :3, SERIE : Series.LANTANIDIUM},
	{SYMBOL : "Nd", NAME : "NEODYMIUM", VALENCY :3, SERIE : Series.LANTANIDIUM},
	{SYMBOL : "Pm", NAME : "PROMETHIUM", VALENCY :3, SERIE : Series.LANTANIDIUM},
	{SYMBOL : "Sm", NAME : "SAMARIUM", VALENCY :3, SERIE : Series.LANTANIDIUM},
	{SYMBOL : "Eu", NAME : "EUROPIUM", VALENCY :3, SERIE : Series.LANTANIDIUM},
	{SYMBOL : "Gd", NAME : "GADOLINIUM", VALENCY :3, SERIE : Series.LANTANIDIUM},
	{SYMBOL : "Tb", NAME : "TERBIUM", VALENCY :3, SERIE : Series.LANTANIDIUM},
	{SYMBOL : "Dy", NAME : "DYSPROSIUM", VALENCY :3, SERIE : Series.LANTANIDIUM},
	{SYMBOL : "Ho", NAME : "HOLMIUM", VALENCY :3, SERIE : Series.LANTANIDIUM},
	{SYMBOL : "Er", NAME : "ERBIUM", VALENCY :3, SERIE : Series.LANTANIDIUM},
	{SYMBOL : "Tm", NAME : "THULIUM", VALENCY :3, SERIE : Series.LANTANIDIUM},
	{SYMBOL : "Yb", NAME : "YTTERBIUM", VALENCY :3, SERIE : Series.LANTANIDIUM},
	{SYMBOL : "Lu", NAME : "LUTETIUM", VALENCY :3, SERIE : Series.LANTANIDIUM},
	{SYMBOL : "Hf", NAME : "HAFNIUM", VALENCY :4, SERIE : Series.TRANSITION},
	{SYMBOL : "Ta", NAME : "TANTALUM", VALENCY :5, SERIE : Series.TRANSITION},
	{SYMBOL : "W", NAME : "TUNGSTEN", VALENCY :6, SERIE : Series.TRANSITION},
	{SYMBOL : "Re", NAME : "RHENIUM", VALENCY :7, SERIE : Series.TRANSITION},
	{SYMBOL : "Os", NAME : "OSMIUM", VALENCY :8, SERIE : Series.TRANSITION},
	{SYMBOL : "Ir", NAME : "IRIDIUM", VALENCY :4, SERIE : Series.TRANSITION},
	{SYMBOL : "Pt", NAME : "PLATINUM", VALENCY :4, SERIE : Series.TRANSITION},
	{SYMBOL : "Au", NAME : "GOLD", VALENCY :3, SERIE : Series.TRANSITION},
	{SYMBOL : "Hg", NAME : "MERCURY", VALENCY :2, SERIE : Series.TRANSITION},
	{SYMBOL : "Tl", NAME : "THALLIUM", VALENCY :3, SERIE : Series.OTHERS},
	{SYMBOL : "Pb", NAME : "LEAD", VALENCY :4, SERIE : Series.OTHERS},
	{SYMBOL : "Bi", NAME : "BISMUTH", VALENCY :5, SERIE : Series.OTHERS},
	{SYMBOL : "Po", NAME : "POLONIUM", VALENCY :4, SERIE : Series.OTHERS},
	{SYMBOL : "At", NAME : "ASTATINE", VALENCY :7, SERIE : Series.HALOGEN},
	{SYMBOL : "Rn", NAME : "RADON", VALENCY :0, SERIE : Series.NOBLE},
	{SYMBOL : "Fr", NAME : "FRANCIUM", VALENCY :1, SERIE : Series.ALKALINE},
	{SYMBOL : "Ra", NAME : "RADIUM", VALENCY :2, SERIE : Series.ALKALINE_EARTH},
	{SYMBOL : "Ac", NAME : "ACTINIUM", VALENCY :3, SERIE : Series.ACTINIDIUM},
	{SYMBOL : "Th", NAME : "THORIUM", VALENCY :4, SERIE : Series.ACTINIDIUM},
	{SYMBOL : "Pa", NAME : "PROTACTINIUM", VALENCY :5, SERIE : Series.ACTINIDIUM},
	{SYMBOL : "U", NAME : "URANIUM", VALENCY :6, SERIE : Series.ACTINIDIUM},
	{SYMBOL : "Np", NAME : "NEPTUNIUM", VALENCY :6, SERIE : Series.ACTINIDIUM},
	{SYMBOL : "Pu", NAME : "PLUTONIUM", VALENCY :6, SERIE : Series.ACTINIDIUM},
	{SYMBOL : "Am", NAME : "AMERICIUM", VALENCY :6, SERIE : Series.ACTINIDIUM},
	{SYMBOL : "Cm", NAME : "CURIUM", VALENCY :4, SERIE : Series.ACTINIDIUM},
	{SYMBOL : "Bk", NAME : "BERKELIUM", VALENCY :4, SERIE : Series.ACTINIDIUM},
	{SYMBOL : "Cf", NAME : "CALIFORNIUM", VALENCY :4, SERIE : Series.ACTINIDIUM},
	{SYMBOL : "Es", NAME : "EINSTEINIUM", VALENCY :3, SERIE : Series.ACTINIDIUM},
	{SYMBOL : "Fm", NAME : "FERMIUM", VALENCY :3, SERIE : Series.ACTINIDIUM},
	{SYMBOL : "Md", NAME : "MENDELEVIUM", VALENCY :3, SERIE : Series.ACTINIDIUM},
	{SYMBOL : "No", NAME : "NOBELIUM", VALENCY :3, SERIE : Series.ACTINIDIUM},
	{SYMBOL : "Lr", NAME : "LAWRENCIUM", VALENCY :2, SERIE : Series.ACTINIDIUM},
	{SYMBOL : "Rf", NAME : "RUTHERFORDIUM", VALENCY :4, SERIE : Series.TRANSITION},
	{SYMBOL : "Db", NAME : "DUBNIUM", VALENCY :5, SERIE : Series.TRANSITION},
	{SYMBOL : "Sg", NAME : "SEABORGIUM", VALENCY :6, SERIE : Series.TRANSITION},
	{SYMBOL : "Bh", NAME : "BOHRIUM", VALENCY :7, SERIE : Series.TRANSITION},
	{SYMBOL : "Hs", NAME : "HASSIUM", VALENCY :8, SERIE : Series.TRANSITION},
	{SYMBOL : "Mt", NAME : "MEITNERIUM", VALENCY :4, SERIE : Series.TRANSITION},
	{SYMBOL : "Ds", NAME : "DARMSTADTIUM", VALENCY :4, SERIE : Series.TRANSITION},
	{SYMBOL : "Rg", NAME : "ROENTGENIUM", VALENCY :3, SERIE : Series.TRANSITION},
	{SYMBOL : "Cn", NAME : "COPERNICIUM", VALENCY :2, SERIE : Series.TRANSITION},
	{SYMBOL : "Nh", NAME : "NIHONIUM", VALENCY :3, SERIE : Series.OTHERS},
	{SYMBOL : "Fl", NAME : "FLEROVIUM", VALENCY :4, SERIE : Series.OTHERS},
	{SYMBOL : "Mc", NAME : "MOSCOVIUM", VALENCY :5, SERIE : Series.OTHERS},
	{SYMBOL : "Lv", NAME : "LIVERMORIUM", VALENCY :6, SERIE : Series.OTHERS},
	{SYMBOL : "Ts", NAME : "TENNESSINE", VALENCY :6, SERIE : Series.HALOGEN},
	{SYMBOL : "Og", NAME : "OGANESSON", VALENCY :0, SERIE : Series.NOBLE},
	{SYMBOL : "Uue", NAME : "UNUNENNUIUM", VALENCY :1, SERIE : Series.ALKALINE},
]
const WIDGETS := {
	0: {
		Ranking.IMPROVED: [EffectType.SKILL, preload("res://scripts/elements/effects/hidrogen.gd")],
#		Ranking.ENHANCED: [EffectType.MOLECULE, preload("res://scripts/elements/effects/hidrogen.gd")],
#		Ranking.ELITE: [EffectType.SKILL, preload("res://scripts/elements/effects/hidrogen.gd")],
	},
	2: {
		Ranking.ENHANCED: [EffectType.SKILL, preload("res://scripts/elements/effects/lithium.gd")],
	},
}
const SAGAS := {
	Sagas.TUTORIAL: {
		Campagn.PHASES_CONFIG: [
			PhaseConfig.NORMAL, PhaseConfig.NORMAL, PhaseConfig.NORMAL,
			PhaseConfig.NORMAL, PhaseConfig.NORMAL, PhaseConfig.BOSS,
		],
		Campagn.NORMAL_PHASE_ID: 0,
		Campagn.BOSS_ID: 0,
		Campagn.SKINS: {
			PhaseConfig.BOSS: preload("res://assets/img/icon.svg")
		},
	},
	Sagas.MAKINO: {
		Campagn.PHASES_CONFIG: [
			PhaseConfig.NORMAL, PhaseConfig.NORMAL, PhaseConfig.NORMAL, PhaseConfig.MINIBOSS_A,
			PhaseConfig.NORMAL, PhaseConfig.NORMAL, PhaseConfig.BOSS,
		],
		Campagn.SKINS: {
			PhaseConfig.MINIBOSS_A: preload("res://assets/img/icon.svg"),
			PhaseConfig.BOSS: preload("res://assets/img/icon.svg")
		},
		Campagn.BOTS: {
			PhaseConfig.NORMAL: 0,
			PhaseConfig.MINIBOSS_A: 0,
			PhaseConfig.BOSS: 0,
		}
	},
	Sagas.CHAM_INK: {
		Campagn.PHASES_CONFIG: [
			PhaseConfig.NORMAL, PhaseConfig.NORMAL, PhaseConfig.NORMAL, PhaseConfig.MINIBOSS_A,
			PhaseConfig.NORMAL, PhaseConfig.NORMAL, PhaseConfig.BOSS,
		],
		Campagn.SKINS: {
			PhaseConfig.MINIBOSS_A: preload("res://assets/img/icon.svg"),
			PhaseConfig.BOSS: preload("res://assets/img/icon.svg")
		},
	},
	
}