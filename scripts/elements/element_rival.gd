class_name ElementNodeRival extends Element


func _gui_input(event: InputEvent):
	if event.is_action_pressed("mouse_right"):
		Gameplay.world.element_info.show_info(self)

	if event.is_action_pressed("mouse_click"):
		if Gameplay.action_state == Gameplay.ActionState.ATTACK:
			Gameplay.selected_element_target = self

		else:
			Gameplay.world.element_info.load_data(GameBook.ELEMENTS[atomic_number], atomic_number)
			Gameplay.world.passive_status.set_element(self)


func _mouse_entered():
	if Gameplay.action_state == Gameplay.ActionState.ATTACK:
		mouse_default_cursor_shape = Control.CURSOR_WAIT

	else:
		mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
