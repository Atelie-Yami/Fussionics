class_name ElementNodeRival extends Element


func _gui_input(event: InputEvent):
	if (
			event.is_action("mouse_click") and event.is_pressed()
			and Gameplay.action_state == Gameplay.ActionState.ATTACK
	):
		Gameplay.selected_element_target = self


func _mouse_entered():
	if Gameplay.action_state == Gameplay.ActionState.ATTACK:
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	else:
		mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
