class_name ElementGhost extends Control


var atomic_number: int
var neutrons: int
var eletrons: int


func _init():
	custom_minimum_size = Vector2(80, 80)
	pivot_offset = Vector2(40, 40)
	focus_mode = Control.FOCUS_NONE


func _process(delta):
	queue_redraw()
	modulate = (Color.WHITE * 0.7) +  (GameBook.COLOR_SERIES[GameBook.ELEMENTS[atomic_number][GameBook.SERIE]] * 0.3)
	modulate.a = 1.0


func _draw():
	draw_texture_rect(Element.SLOT, Rect2(-8, -8, 96, 96), false, Color.WHITE)
	
	# obter a cor
	var symbol_color: Color = GameBook.COLOR_SERIES[GameBook.ELEMENTS[atomic_number][GameBook.SERIE]]
	
	# escrever simbolo centralizado
	var string_size = Element.FUTURE_SALLOW.get_string_size(
			GameBook.ELEMENTS[atomic_number][GameBook.SYMBOL], HORIZONTAL_ALIGNMENT_CENTER, -1, Element.FONT_SIZE
	) / 2
	draw_string(
			Element.FUTURE_SALLOW, Vector2(41 - string_size.x, ((string_size.y + 7) / 2) + 40),
			GameBook.ELEMENTS[atomic_number][GameBook.SYMBOL], HORIZONTAL_ALIGNMENT_CENTER, -1, Element.FONT_SIZE, symbol_color
	)
	
	# atomic number
	draw_string(
			Element.GIANT_ROBOT, Vector2(11, 16), str(neutrons +1), HORIZONTAL_ALIGNMENT_RIGHT,
			-1, Element.FONT_ATRIBUTES_SIZE, symbol_color
	)
	# eletrons
	var eletrons_string_size = Element.GIANT_ROBOT.get_string_size(
			str(eletrons), HORIZONTAL_ALIGNMENT_LEFT, -1, Element.FONT_ATRIBUTES_SIZE
	)
	draw_string(
			Element.GIANT_ROBOT, Vector2(68 - eletrons_string_size.x, 16), str(eletrons),
			HORIZONTAL_ALIGNMENT_LEFT, 200, Element.FONT_ATRIBUTES_SIZE, symbol_color
	)
