extends Control


var neutrons : int
var eletrons : int
var atomic_number := -1


func _draw():
	if atomic_number == -1:
		return
	
	# atomic number
	var neutrons_color := Color.WHITE
	if neutrons < atomic_number:
		neutrons_color = Color.LIGHT_SALMON
	elif neutrons > atomic_number:
		neutrons_color = Color.LIGHT_SKY_BLUE
	
	draw_string(
			Element.GIANT_ROBOT, Vector2(11, 16), str(neutrons +1), HORIZONTAL_ALIGNMENT_RIGHT,
			-1, Element.FONT_ATRIBUTES_SIZE, neutrons_color
	)
	# eletrons
	var eletrons_color := Color.WHITE
	if eletrons -1 < atomic_number:
		eletrons_color = Color.ORANGE_RED.lightened(0.5)
	elif eletrons -1 > atomic_number:
		eletrons_color = Color.PALE_GREEN
	
	var eletrons_string_size = Element.GIANT_ROBOT.get_string_size(
			str(eletrons), HORIZONTAL_ALIGNMENT_LEFT, -1, Element.FONT_ATRIBUTES_SIZE
	)
	draw_string(
			Element.GIANT_ROBOT, Vector2(68 - eletrons_string_size.x, 16), str(eletrons),
			HORIZONTAL_ALIGNMENT_LEFT, 200, Element.FONT_ATRIBUTES_SIZE, eletrons_color
	)
