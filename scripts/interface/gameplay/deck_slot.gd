class_name DeckSlot extends Panel


@export var element: int

var can_drop: bool


func _gui_input(event):
	if (
			not can_drop or
			Gameplay.player_controller.current_players[PlayerController.Players.A].energy < element +1
	):
		mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
	
	else:
		mouse_filter = Control.MOUSE_FILTER_STOP
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


func _get_drag_data(_p):
	if (
			not can_drop or
			Gameplay.player_controller.current_players[PlayerController.Players.A].energy < element +1
	):
		return null
	
	var preview: DeckSlot = duplicate()
	preview.modulate.a = 0.66
	preview.scale *= 0.75
	
	Gameplay.element_drag_preview.add_child(preview)
	preview.position = Vector2(-40, -40)
	return self
