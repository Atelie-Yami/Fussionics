class_name DeckSlot extends Panel


@export var element: int

var can_drop: bool:
	get:
		return ( can_drop and
			Gameplay.player_controller.current_players[PlayerController.Players.A].energy > element
		)

var simbol: String
var color: Color


func _ready():
	simbol = ElementNode.DATA[element][ElementNode.SIMBOL]
	color = ElementNode.COLOR_SERIES[ElementNode.DATA[element][ElementNode.SERIE]]


func _process(delta):
	queue_redraw()


func _draw():
	var string_size = ElementNode.FUTURE_SALLOW.get_string_size(
			simbol, HORIZONTAL_ALIGNMENT_CENTER, -1, ElementNode.FONT_SIZE
	)
	string_size /= 2
	
	draw_string(
			ElementNode.FUTURE_SALLOW,
			Vector2(41 - string_size.x, ((string_size.y + 7) / 2) + 40),
			simbol, HORIZONTAL_ALIGNMENT_CENTER, -1,
			ElementNode.FONT_SIZE,
			color if can_drop else Color.LIGHT_STEEL_BLUE
	)
	
	modulate = color if can_drop else Color(0.6, 0.6, 0.6, 0.3)


func _gui_input(event):
	if not can_drop:
		mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
	
	else:
		mouse_filter = Control.MOUSE_FILTER_STOP
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


func _get_drag_data(_p):
	if not can_drop:
		return null
	
	var preview: DeckSlot = duplicate()
	preview.modulate.a = 0.66
	preview.scale *= 0.75
	
	Gameplay.element_drag_preview.add_child(preview)
	preview.position = Vector2(-40, -40)
	return self
