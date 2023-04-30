class_name ElementNodePlayer extends Element


#func _gui_input(event: InputEvent):
#	if event.is_action_pressed("mouse_right"):
#		Gameplay.element_info.show_info(self)
#
#	if not event.is_action_pressed("mouse_click") or disabled:
#		return
#
#	match Gameplay.action_state:
#		Gameplay.ActionState.NORMAL:
#			_set_current_node_state(NodeState.SELECTED)
#			Gameplay.passive_status.set_element(self)
#
#		Gameplay.ActionState.LINK:
#			if number_electrons_in_valencia > 0 and GameJudge.is_neighbor_to_link(grid_position):
#				Gameplay.selected_element_target = self
#			else:
#				Gameplay.action_state = Gameplay.ActionState.NORMAL
#
#		Gameplay.ActionState.UNLINK:
#			if GameJudge.is_neighbor_to_link(grid_position):
#				Gameplay.selected_element_target = self
#			else:
#				Gameplay.action_state = Gameplay.ActionState.NORMAL
#
#		Gameplay.ActionState.ATTACK:
#			Gameplay.action_state = Gameplay.ActionState.NORMAL
#
#
#func _get_drag_data(_p):
#	if disabled or self.has_link: return null
#
#	var preview: Element = duplicate()
#	preview.modulate.a = 0.66
#	preview.scale *= 0.75
#
#	Gameplay.element_drag_preview.add_child(preview)
#	preview.position = Vector2(-40, -40)
#	return self
#
#
#func _mouse_entered():
#	if not disabled:
#		_set_current_node_state(NodeState.HOVER)
#		mouse_default_cursor_shape = (
#				Control.CURSOR_POINTING_HAND if has_link else
#				Control.CURSOR_MOVE
#		)
#	else:
#		mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
