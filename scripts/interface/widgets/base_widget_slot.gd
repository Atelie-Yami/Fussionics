class_name BaseWidgetSlot extends Panel


const STAR := preload("res://resouces/atlas/gameplay/star.atlastex")

const FONT_CENTER_POSITION := Vector2(28, 33)
const FONT_SIZE := 34

const CENTER_POSITION := Vector2(27.5, 27.5)
const STAR_SPACCAMENT := 13.0
const STAR_SIDE_SPACCAMENT := STAR_SPACCAMENT / 2.0
const STAR_SIZE := Vector2(14, 14)

var ranking: int:
	set(value):
		ranking = value
		queue_redraw()

var atomic_number: int = -1:
	set(value):
		atomic_number = value
		can_drop = atomic_number != -1
		queue_redraw()

var is_dragging: bool
var can_drop: bool


func _draw():
	if atomic_number == -1:
		return
	
	_draw_stars()
	
	var data: Dictionary = GameBook.ELEMENTS[atomic_number]
	var color: Color = GameBook.COLOR_SERIES[data[GameBook.SERIE]]
	
	_draw_symbol(data[GameBook.SYMBOL], color)


func _draw_stars():
	for i in ranking:
		var p = (i * STAR_SPACCAMENT) - (ranking / 2.0 * STAR_SPACCAMENT) + STAR_SIDE_SPACCAMENT
		var final_position: Vector2 = Vector2(CENTER_POSITION.x - (STAR_SIZE.x / 2.0) + p, 5)
		
		draw_texture_rect(STAR, Rect2(final_position, STAR_SIZE), false)


func _draw_symbol(symbol: String, color: Color):
	var string_size = Element.FUTURE_SALLOW.get_string_size(
			symbol, HORIZONTAL_ALIGNMENT_CENTER, -1, FONT_SIZE
	) / 2.0
	
	draw_string(
			Element.FUTURE_SALLOW,
			Vector2(FONT_CENTER_POSITION.x - string_size.x, ((string_size.y + 7) / 2) + FONT_CENTER_POSITION.y),
			symbol, HORIZONTAL_ALIGNMENT_CENTER, -1,
			FONT_SIZE,
			(color * 0.2) + (Color.WHITE * 0.8)
	)


func _can_drop_data(at_position, data):
	return data is DeckWidgetSlot


func _drop_data(at_position, data):
	data.atomic_number = -1


func _get_drag_data(_p):
	if not can_drop:
		return null
	
	var preview = duplicate()
	preview.atomic_number = atomic_number
	preview.ranking = ranking
	preview.is_dragging = true
	
	Gameplay.element_drag_preview.add_child(preview)
	preview.position = Vector2(-22.5, -22.5)
	return self


func _notification(what: int):
	if what == NOTIFICATION_DRAG_BEGIN:
		Gameplay.element_drag_preview.z_index = 1
	
	if what == NOTIFICATION_DRAG_END:
		Gameplay.element_drag_preview.z_index = 0
