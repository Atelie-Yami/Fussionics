class_name ElementNodePlayer extends Element


func _gui_input(event: InputEvent):
	if event.is_action_pressed("mouse_right"):
		Gameplay.element_info.show_info(self)

	if not event.is_action_pressed("mouse_click") or disabled or in_reactor:
		return

	match Gameplay.action_state:
		Gameplay.ActionState.NORMAL:
			_set_current_node_state(NodeState.SELECTED)
			Gameplay.passive_status.set_element(self)

		Gameplay.ActionState.LINK:
			if number_electrons_in_valencia > 0 and GameJudge.is_neighbor_to_link(grid_position):
				Gameplay.selected_element_target = self
			else:
				Gameplay.action_state = Gameplay.ActionState.NORMAL

		Gameplay.ActionState.UNLINK:
			if GameJudge.is_neighbor_to_link(grid_position):
				Gameplay.selected_element_target = self
			else:
				Gameplay.action_state = Gameplay.ActionState.NORMAL

		Gameplay.ActionState.ATTACK:
			Gameplay.action_state = Gameplay.ActionState.NORMAL


func _get_drag_data(_p):
	if disabled or self.has_link:
		return null

	var preview: Element = duplicate()
	preview.sob.visible = false
	preview.modulate.a = 0.66
	preview.scale *= 0.75

	Gameplay.element_drag_preview.add_child(preview)
	preview.position = Vector2(-40, -40)
	return self


func _mouse_entered():
	if not disabled:
		_set_current_node_state(NodeState.HOVER)
		
		mouse_default_cursor_shape = (
				Control.CURSOR_POINTING_HAND if has_link else
				Control.CURSOR_MOVE
		)
		
		if Gameplay.selected_element != self:
			match Gameplay.action_state:
				Gameplay.ActionState.LINK:
					mouse_default_cursor_shape = Control.CURSOR_HSIZE
				
				Gameplay.ActionState.UNLINK:
					mouse_default_cursor_shape = Control.CURSOR_HSPLIT
		
	else:
		mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN


func _can_drop_data(_p, data):
	return data is WidgetSlot and atomic_number == data.atomic_number


func _drop_data(_p, data):
	var skill: Array = GameBook.WIDGETS[atomic_number][data.ranking]
	
	effect = skill[1].new(self)
	effect.ranking = data.ranking
	
	Gameplay.vfx.emit_get_widget(global_position + Vector2(40, 40), legancy.modulate)
