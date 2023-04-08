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
	Gameplay.element_info = self


func _notification(what: int):
	if what == NOTIFICATION_DRAG_BEGIN:
		visible = false


func load_data(data: Dictionary, atomic_number: int):
	var symbol_color: Color = Element.COLOR_SERIES[Element.DATA[atomic_number][Element.SERIE]]
	
	element_name.text = tr(data[Element.NAME])
	element_name.modulate = (symbol_color * 0.35) + (Color.WHITE * 0.75)
	
	serie.text = tr(SERIES[data[Element.SERIE]])
	serie.modulate = (symbol_color * 0.6) + (Color.WHITE * 0.4)
	
	valentia.text = tr("VALENTIA") + str(data[Element.VALENTIA])
	effect.text = tr("EFFECT_" + data[Element.NAME])
	molecule_effect.text = tr("MOLECULA_" + data[Element.NAME])
	
	if data[Element.VALENTIA] == 0:
		valentia.modulate = Color.PALE_VIOLET_RED
	else:
		valentia.modulate = Color.WHITE


func _element_selected(valid: bool):
	if valid:
		var data = Element.DATA[Gameplay.selected_element.atomic_number]
		load_data(data, Gameplay.selected_element.atomic_number)
		
		if Gameplay.selected_element.neutrons != Gameplay.selected_element.atomic_number:
			extra_neutrons.text = tr("ISOTOPO")
			
			var diff = Gameplay.selected_element.atomic_number - Gameplay.selected_element.neutrons
			extra_neutrons.text += ("+" if diff > 0 else "-") + str(diff)
			extra_neutrons.modulate = Color.PALE_VIOLET_RED if diff > 0 else Color.PALE_GREEN
		else:
			extra_neutrons.text = ""
			extra_neutrons.modulate = Color.WHITE
	
	visible = valid


func _close_pressed():
	visible = false
