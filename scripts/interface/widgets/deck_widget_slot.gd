class_name DeckWidgetSlot extends BaseWidgetSlot


func _can_drop_data(at_position, data):
	return data != self


func _drop_data(at_position, data):
	atomic_number = data.atomic_number
	ranking = data.ranking
	
	if data is DeckWidgetSlot:
		data.atomic_number = -1


func _get_drag_data(_p):
	if not can_drop:
		return null
	
	var preview: DeckWidgetSlot = duplicate()
	preview.atomic_number = atomic_number
	preview.ranking = ranking
	preview.is_dragging = true
	
	Gameplay.element_drag_preview.add_child(preview)
	preview.position = Vector2(-22.5, -22.5)
	return self
