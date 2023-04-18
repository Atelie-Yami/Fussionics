class_name WidgetSlot extends Panel

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


func _draw():
	if not ranking:
		modulate = Color(0.6, 0.6, 0.6, 0.3)
		return
	
	_draw_stars()
	_draw_symbol()


func _draw_stars():
	for i in ranking:
		var p = (i * STAR_SPACCAMENT) - (ranking / 2.0 * STAR_SPACCAMENT) + STAR_SIDE_SPACCAMENT
		var final_position: Vector2 = Vector2(CENTER_POSITION.x - (STAR_SIZE.x / 2.0) + p, 5)
		
		draw_texture_rect(STAR, Rect2(final_position, STAR_SIZE), false)


func _draw_symbol():
	var data: Dictionary = Element.DATA[atomic_number]
	var symbol: String = data[Element.SIMBOL]
	var color: Color = Element.COLOR_SERIES[data[Element.SERIE]]
	
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
	modulate = (color * 0.3) + (Color.WHITE * 0.7) if can_drop else Color(0.6, 0.6, 0.6, 0.3)


func _get_drag_data(_p):
	if not can_drop:
		return null
	
	var preview: WidgetSlot = duplicate()
	preview.is_dragging = true
	
	Gameplay.element_drag_preview.add_child(preview)
	preview.position = Vector2(-22.5, -22.5)
	return self
