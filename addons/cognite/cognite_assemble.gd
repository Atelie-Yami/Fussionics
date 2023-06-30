@tool
class_name CogniteAssemble extends RefCounted


const ASSEMBLE := {
	"decompose": {},
}

static var assemble_modus := [
	AmethistChipSet.get_modus,
	SapphireChipSet.get_modus,
]

var modus_action := {
	Bot.ModusOperandi.UNDECIDED: ASSEMBLE.duplicate(true),
	Bot.ModusOperandi.DEFENSIVE: ASSEMBLE.duplicate(true),
	Bot.ModusOperandi.AGGRESSIVE: ASSEMBLE.duplicate(true),
	Bot.ModusOperandi.STRATEGICAL_DEFENSIVE: ASSEMBLE.duplicate(true),
	Bot.ModusOperandi.STRATEGICAL_AGGRESSIVE: ASSEMBLE.duplicate(true),
}

var chipset_modus: Callable


func run(modus: Bot.ModusOperandi, bot: Bot, analysis: FieldAnalysis):
	modus_action[modus]
