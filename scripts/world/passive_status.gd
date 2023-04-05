extends Node2D


var element: Element

@onready var debuffs = $PanelContainer/MarginContainer/VBoxContainer/debuffs
@onready var buffs = $PanelContainer/MarginContainer/VBoxContainer/buffs


func _set_element(_element: Element):
	element = _element
	
	var active: bool = element != null
	set_process(active)
	visible = active
	
	if active:
		_size_compare(debuffs.get_child_count(), element.debuffs.size(), debuffs)
		_size_compare(buffs.get_child_count(), element.buffs.size(), buffs)
		
		for i in element.debuffs.size():
			debuffs.get_child(i).load_passive(element.debuffs[i])
		
		for i in element.buffs.size():
			buffs.get_child(i).load_passive(element.buffs[i])


func _process(delta):
	if element:
		position = element.position


func _show_passives():
	pass


func _notification(what: int):
	if what == NOTIFICATION_DRAG_BEGIN:
		visible = false


func _turn_machine_end_turn(player):
	visible = false


func _size_compare(childs: int, size: int, parent: Node):
	if childs < size:
		for i in abs(childs - size):
			parent.add_child(parent.get_child(0).duplicate())
