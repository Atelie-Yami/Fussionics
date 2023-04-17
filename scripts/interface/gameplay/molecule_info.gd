extends PanelContainer

const RICHTEXT := preload("res://scenes/interface/gameplay/molecule_info_element.tscn")

@onready var header_name = $MarginContainer/VBoxContainer/header/VBoxContainer/name
@onready var header_effect = $MarginContainer/VBoxContainer/header/VBoxContainer/effect
@onready var effect_list = $MarginContainer/VBoxContainer


var kill_list: Array[Node]
var _flag_bind_elements: Dictionary


func _reset():
	kill_list.map(func(c): c.queue_free())
	_flag_bind_elements.clear()
	kill_list.clear()


func _init():
	visibility_changed.connect(_visibility_changed)


func _visibility_changed():
	if not visible:
		_reset()


func _notification(what: int):
	if what == NOTIFICATION_DRAG_BEGIN:
		visible = false


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		visible = false


func load_info(element: Element):
	_reset()
	
	var slot = Gameplay.arena.elements[element.grid_position]
	var molecule: Molecule = slot.molecule
	
	if not molecule:
		visible = false
		return
	
	load_header_info(
			Element.DATA[element.atomic_number], 
			Element.COLOR_SERIES[Element.DATA[element.atomic_number][Element.SERIE]]
	)
	if not element.molecule_effect:
		visible = true
		return
	
	var pack: Array[MoleculeEffect]
	for e in molecule.configuration:
		if e.effect:
			pack.append(e.effect)
	
	var cluster: Dictionary
	EffectCluster.filter_relative_elements(element.molecule_effect.mechanic_mode, pack, cluster)
	
	for list in cluster.cluster:
		for effect in cluster.cluster[list]:
			if _flag_bind_elements.has(effect.element.atomic_number):
				_flag_bind_elements[effect.element.atomic_number].binds += 1
				_flag_bind_elements[effect.element.atomic_number].bake()
				continue
			
			var label = RICHTEXT.instantiate()
			effect_list.add_child(label)
			kill_list.append(label)
			
			_flag_bind_elements[effect.element.atomic_number] = label
			label.color = Element.COLOR_SERIES[Element.DATA[effect.element.atomic_number][Element.SERIE]]
			label.symbol = Element.DATA[effect.element.atomic_number][Element.NAME]
			label.binds = 1
			label.bake()
	
	visible = true


func load_header_info(data: Dictionary, color: Color):
	header_name.text = tr(data[Element.NAME])
	header_name.modulate = (color * 0.35) + (Color.WHITE * 0.75)
	
	header_effect.text = tr("MOLECULA_" + data[Element.NAME])
	header_effect.visible = header_effect.text != "MOLECULA_" + data[Element.NAME]


func _close_pressed():
	visible = false
