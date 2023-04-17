extends PanelContainer

const SERIES := [
	"ALKALINE", "ALKALINE_EARTH", "LANTANIDIUM", 'ACTINIDIUM', 'TRANSITION',
	'OTHERS', 'SEMIMETAL', 'METALLOID', 'HALOGEN', 'NOBLE', 'UNKNOWN'
]

@export var molecule_info_path: NodePath
@onready var molecule_info = get_node(molecule_info_path)

@onready var symbol: TextureRect= $MarginContainer/VBoxContainer/element_profile/symbol
@onready var element_name: Label = $MarginContainer/VBoxContainer/element_profile/VBoxContainer/name
@onready var serie: Label = $MarginContainer/VBoxContainer/element_profile/VBoxContainer/HBoxContainer/serie

@onready var stars: Array[Control] = [
	$MarginContainer/VBoxContainer/element_profile/VBoxContainer/HBoxContainer/star1 as Control,
	$MarginContainer/VBoxContainer/element_profile/VBoxContainer/HBoxContainer/star2 as Control,
	$MarginContainer/VBoxContainer/element_profile/VBoxContainer/HBoxContainer/star3 as Control,
]

@onready var valentia: Label = $MarginContainer/VBoxContainer/valentia/valentia_text
@onready var extra_neutrons: Label = $MarginContainer/VBoxContainer/valentia/extra_neutrons
@onready var skill_effect: RichTextLabel = $MarginContainer/VBoxContainer/effect
@onready var molecule_effect: RichTextLabel = $MarginContainer/VBoxContainer/molecule_effect
@onready var skill_effect_title: Label = $MarginContainer/VBoxContainer/skill_effect_title
@onready var molecule_effect_title: Label = $MarginContainer/VBoxContainer/molecule_effect_title


func _init():
	Gameplay.element_info = self


func _notification(what: int):
	if what == NOTIFICATION_DRAG_BEGIN:
		visible = false


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		visible = false


func load_data(data: Dictionary, atomic_number: int):
	var symbol_color: Color = Element.COLOR_SERIES[Element.DATA[atomic_number][Element.SERIE]]
	
	element_name.text = tr(data[Element.NAME])
	element_name.modulate = (symbol_color * 0.35) + (Color.WHITE * 0.75)
	
	serie.text = tr(SERIES[data[Element.SERIE]])
	serie.modulate = (symbol_color * 0.6) + (Color.WHITE * 0.4)
	
	stars.map(func(c): c.visible = false)
	
	for i in data[Element.RANKING]:
		stars[i].visible = true
	
	
	valentia.text = tr("VALENTIA") + str(data[Element.VALENTIA])
	skill_effect.text = tr("EFFECT_" + data[Element.NAME])
	
	var has_text: bool = skill_effect.text != "EFFECT_" + data[Element.NAME]
	skill_effect.visible = has_text
	skill_effect_title.visible = has_text
	
	valentia.modulate = Color.PALE_VIOLET_RED if data[Element.VALENTIA] == 0 else Color.WHITE


func show_info(element: Element):
	var data = Element.DATA[element.atomic_number]
	load_data(data, element.atomic_number)
	
	molecule_info.load_info(element)
	
	if element.neutrons != element.atomic_number:
		extra_neutrons.text = tr("ISOTOPO")
		
		var diff = element.atomic_number - element.neutrons
		extra_neutrons.text += ("+" if diff > 0 else "-") + str(diff)
		extra_neutrons.modulate = Color.PALE_VIOLET_RED if diff > 0 else Color.PALE_GREEN
	else:
		extra_neutrons.text = ""
		extra_neutrons.modulate = Color.WHITE
	
	visible = true


func _close_pressed():
	visible = false
