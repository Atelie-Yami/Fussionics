extends PanelContainer


var can_drop: bool

@onready var h_box_container = $MarginContainer/HBoxContainer




func _turn_machine_end_turn(player):
	h_box_container.get_children().map(func(c): c.can_drop = false)
	


func _turn_machine_main_turn(player):
	if player == PlayerController.Players.A:
		h_box_container.get_children().map(func(c): c.can_drop = true)


