extends PanelContainer

const SERIES := [
	"ALKALINE", "ALKALINE_EARTH", "LANTANIDIUM", 'ACTINIDIUM', 'TRANSITION',
	'OTHERS', 'SEMIMETAL', 'METALLOID', 'HALOGEN', 'NOBLE', 'UNKNOWN'
]


@onready var symbol = $MarginContainer/VBoxContainer/HBoxContainer/symbol
@onready var element_name = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/name
@onready var serie = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/serie
@onready var valentia = $MarginContainer/VBoxContainer/HBoxContainer2/valentia
@onready var extra_neutrons = $MarginContainer/VBoxContainer/HBoxContainer2/extra_neutrons
@onready var effect: RichTextLabel = $MarginContainer/VBoxContainer/effect


func _init():
	Gameplay.element_selected.connect(_element_selected)


func _element_selected(valid: bool):
	if valid:
		var data = Element.DATA[Gameplay.selected_element.atomic_number]
		
		element_name.text = tr(data[Element.NAME])
		serie.text = tr(SERIES[data[Element.SERIE]])
		valentia.text = tr("VALENTIA") + str(data[Element.VALENTIA])
		
		if Gameplay.selected_element.neutrons != Gameplay.selected_element.atomic_number:
			extra_neutrons.text = tr("ISOTOPO")
			
			var diff = Gameplay.selected_element.atomic_number - Gameplay.selected_element.neutrons
			extra_neutrons.text += ("+" if diff > 0 else "-") + str(diff)
		
		effect.text = tr("EFFECT_" + data[Element.NAME])
	
	visible = valid


func _close_pressed():
	visible = false
