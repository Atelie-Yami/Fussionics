class_name WidgetSlot extends Panel

const STYLEBOX := preload("res://resouces/stylebox/widget_panel.stylebox")
const STAR := preload("res://resouces/atlas/gameplay/star.atlastex")
const CENTER_POSITION := Vector2(27.5, 27.5)

const STAR_SPACCAMENT := 13.0
const STAR_SIDE_SPACCAMENT := STAR_SPACCAMENT / 2.0
const STAR_SIZE := Vector2(14, 14)

const FONT_CENTER_POSITION := Vector2(28, 33)
const FONT_SIZE := 34

var atomic_number: int
var ranking: int

var is_dragging: bool
var can_drop: bool = true


func _init():
	add_theme_stylebox_override("panel", STYLEBOX)


func _draw():
	if not ranking:
		modulate = Color(0.6, 0.6, 0.6, 0.3)
		return
	
	_draw_stars()
	
	var data: Dictionary = GameBook.ELEMENTS[atomic_number]
	var color: Color = GameBook.COLOR_SERIES[data[GameBook.SERIE]]
	
	if is_dragging:
		color = Color.WHITE
	
	_draw_symbol(data[GameBook.SYMBOL], color)
	
	if not is_dragging:
		modulate = (color * 0.3) + (Color.WHITE * 0.7) if can_drop else Color(0.6, 0.6, 0.6, 0.3)


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
			(color * 0.2) + (Color.WHITE * 0.8) if can_drop else Color.LIGHT_STEEL_BLUE
	)


func _get_drag_data(_p):
	if not can_drop:
		return null
	
	var preview: WidgetSlot = duplicate()
	preview.atomic_number = atomic_number
	preview.ranking = ranking
	preview.is_dragging = true
	
	Gameplay.element_drag_preview.add_child(preview)
	preview.position = Vector2(-22.5, -22.5)
	return self
