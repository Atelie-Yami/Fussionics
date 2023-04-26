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

@onready var valentia: Label = $MarginContainer/VBoxContainer/valentia_text
@onready var skill_effect: RichTextLabel = $MarginContainer/VBoxContainer/effect
@onready var molecule_effect: RichTextLabel = $MarginContainer/VBoxContainer/molecule_effect
@onready var skill_effect_title: Label = $MarginContainer/VBoxContainer/skill_effect_title
@onready var molecule_effect_title: Label = $MarginContainer/VBoxContainer/molecule_effect_title


func _notification(what: int):
	if what == NOTIFICATION_DRAG_BEGIN:
		visible = false


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		visible = false


func load_data(data: Dictionary, atomic_number: int):
	var symbol_color: Color = GameBook.COLOR_SERIES[GameBook.ELEMENTS[atomic_number][GameBook.SERIE]]
	
	element_name.text = tr(data[GameBook.NAME])
	element_name.modulate = (symbol_color * 0.35) + (Color.WHITE * 0.75)
	
	serie.text = tr(SERIES[data[GameBook.SERIE]])
	serie.modulate = (symbol_color * 0.6) + (Color.WHITE * 0.4)
	
	valentia.text = tr("VALENTIA") + str(data[GameBook.VALENCY])
	valentia.modulate = Color.PALE_VIOLET_RED if data[GameBook.VALENCY] == 0 else Color.WHITE


func show_info(element: Element):
	var data = GameBook.ELEMENTS[element.atomic_number]
	
	stars.map(func(c): c.visible = false)
	skill_effect_title.visible = false
	skill_effect.visible = false
	
	load_data(data, element.atomic_number)
	visible = true
	
	if not element.effect:
		return
	
	if element.effect is MoleculeEffect:
		molecule_info.load_info(element)
	
	var ranking: int = element.effect.ranking
	
	skill_effect.text = tr("EFFECT_" + str(ranking) + "_" + data[GameBook.NAME])
	skill_effect.visible = true
	skill_effect_title.visible = true
	
	for i in ranking:
		stars[i].visible = true



func _close_pressed():
	visible = false
