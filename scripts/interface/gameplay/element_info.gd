extends PanelContainer

const SERIES := [
	"ALKALINE", "ALKALINE_EARTH", "LANTANIDIUM", 'ACTINIDIUM', 'TRANSITION',
	'OTHERS', 'SEMIMETAL', 'METALLOID', 'HALOGEN', 'NOBLE', 'UNKNOWN'
]


@onready var symbol : TextureRect= $MarginContainer/VBoxContainer/element_profile/symbol
@onready var element_name : Label = $MarginContainer/VBoxContainer/element_profile/VBoxContainer/name
@onready var serie : Label = $MarginContainer/VBoxContainer/element_profile/VBoxContainer/serie
@onready var valentia : Label = $MarginContainer/VBoxContainer/valentia/valentia_text
@onready var extra_neutrons : Label = $MarginContainer/VBoxContainer/valentia/extra_neutrons
@onready var effect: RichTextLabel = $MarginContainer/VBoxContainer/effect
@onready var molecule_effect : RichTextLabel = $MarginContainer/VBoxContainer/molecule_effect


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
		
		info_color(data)
	
	visible = valid

func info_color(data) -> void:
	
	if data[Element.VALENTIA] == 0:
		valentia.modulate = Color.PALE_VIOLET_RED
	else:
		valentia.modulate = Color.WHITE
	
	var diff = Gameplay.selected_element.atomic_number - Gameplay.selected_element.neutrons
	if diff > 0:
		extra_neutrons.modulate = Color.PALE_VIOLET_RED
	else:
		extra_neutrons.modulate = Color.PALE_GREEN


func _close_pressed():
	visible = false
