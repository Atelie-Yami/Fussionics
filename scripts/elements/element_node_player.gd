class_name ElementNodePlayer extends Element

enum State {
	NORMAL, BIND_LINK, REMOVE_LINK, ATTACKING, DEFENDING, MOTION, COOKING
}


func _gui_input(event: InputEvent):
	if not (event.is_action("mouse_click") and event.is_pressed()) or disabled:
		return
	
	match Gameplay.action_state:
		Gameplay.ActionState.NORMAL:
			_set_current_node_state(NodeState.SELECTED)
	
		Gameplay.ActionState.LINK:
			if number_electrons_in_valencia > 0 and _is_neighbor_to_link():
				Gameplay.selected_element_target = self
			else:
				Gameplay.action_state = Gameplay.ActionState.NORMAL
	
		Gameplay.ActionState.UNLINK:
			if _is_neighbor_to_link():
				Gameplay.selected_element_target = self
			else:
				Gameplay.action_state = Gameplay.ActionState.NORMAL
		
		Gameplay.ActionState.ATTACK:
			Gameplay.action_state = Gameplay.ActionState.NORMAL


func _get_drag_data(_p):
	if disabled or self.has_link: return null

	var preview: Element = duplicate()
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
	else:
		mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
