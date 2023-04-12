extends Control

const SWORD := preload("res://assets/img/interface/sword.png")
const SLOT_SIZE := 90.0
const RECT_SIZE := Vector2(SLOT_SIZE, SLOT_SIZE)
const ANIMATION_SPEED := 2.0

var time := 0.0
var animation := 0.0
var _slots: Array[Vector2i]


func _init():
	global_position = Vector2(605, 320)
	z_index = 10


func set_slots(elements: Dictionary):
	_slots.clear()
	queue_redraw()
	time = 1.0
	set_process(not elements.is_empty())
	
	for slot in elements:
		if elements[slot].player == 1:
			_slots.append(elements[slot].element.grid_position)


func _process(delta):
	time += delta
	animation = cos(time * ANIMATION_SPEED)
	queue_redraw()


func _draw():
	for slot in _slots:
		var color := Color.RED
		color.a = abs(animation * 0.5)
		draw_texture_rect(SWORD, Rect2(Vector2((slot * SLOT_SIZE) - Vector2(3, 3)), RECT_SIZE), false, color)
