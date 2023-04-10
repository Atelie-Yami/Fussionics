class_name DeckSlot extends Panel


@export var element: int
@export var player_a_path: NodePath
@export var element_info_path: NodePath

var element_info: Control
var player_a: Player

var can_drop: bool:
	get:
		return can_drop and player_a.energy > element

var simbol: String
var color: Color

var is_dragging: bool


func _ready():
	if not is_dragging:
		player_a = get_node(player_a_path)
		element_info = get_node(element_info_path)
		
	simbol = Element.DATA[element][Element.SIMBOL]
	color = Element.COLOR_SERIES[Element.DATA[element][Element.SERIE]]


func _process(delta):
	queue_redraw()


func _draw():
	var string_size = Element.FUTURE_SALLOW.get_string_size(
			simbol, HORIZONTAL_ALIGNMENT_CENTER, -1, Element.FONT_SIZE
	) / 2.0
	
	draw_string(
			Element.FUTURE_SALLOW,
			Vector2(41 - string_size.x, ((string_size.y + 7) / 2) + 40),
			simbol, HORIZONTAL_ALIGNMENT_CENTER, -1,
			Element.FONT_SIZE,
			color if can_drop else Color.LIGHT_STEEL_BLUE
	)
	modulate = color if can_drop else Color(0.6, 0.6, 0.6, 0.3)


func _gui_input(event):
	if event.is_action_pressed("mouse_right"):
		element_info.load_data(Element.DATA[element], element)
		element_info.visible = true
	
	if not can_drop:
		mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
	
	else:
		mouse_filter = Control.MOUSE_FILTER_STOP
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


func _get_drag_data(_p):
	if not can_drop:
		return null
	
	var preview: DeckSlot = duplicate()
	preview.scale *= 0.75
	preview.is_dragging = true
	
	Gameplay.element_drag_preview.add_child(preview)
	preview.position = Vector2(-40, -40)
	return self
