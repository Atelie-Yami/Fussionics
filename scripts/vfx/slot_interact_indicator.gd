extends Control

enum Mode {
	ATTACK, LINK, UNLINK
}
const SWORD := preload("res://assets/img/interface/sword.png")
const LINK := preload("res://assets/img/interface/link.png")
const UNLINK := preload("res://assets/img/interface/unlink.png")
const SLOT_SIZE := 90.0
const RECT_SIZE := Vector2(SLOT_SIZE, SLOT_SIZE)
const ANIMATION_SPEED := 2.5
const TEXTURE_OFFSET := [Vector2(3, 3), Vector2(5, 5), Vector2(3, 3)]

var mode: Mode
var time := 0.0
var animation := 0.0
var _slots: Array[Vector2i]


func _init():
	global_position = Vector2(605, 320)
	z_index = 10


func set_slots(elements: Dictionary, _mode: int, args = null):
	_slots.clear()
	queue_redraw()
	time = 1.0
	set_process(not elements.is_empty())
	mode = _mode
	
	if mode == Mode.ATTACK:
		var has_enemies: bool
		for slot in elements:
			if elements[slot].player == 1:
				_slots.append(elements[slot].element.grid_position)
				has_enemies = true
		
		if not has_enemies:
			Gameplay.attack_omega_handler.visible = true
	
	elif args != null:
		var _position = args as Vector2i
		
		match mode:
			Mode.LINK:
				for xy in [Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, -1), Vector2i(0, 1)]:
					var _pos = _position + xy
					if _pos != _position and elements.has(_pos) and elements[_pos].player == 0:
						_slots.append(_pos)
			
			Mode.UNLINK:
				## elements aqui é a lista link do elemento
				for link in elements:
					var _l = elements[link]
					if not _l:
						continue
					
					if _l.element_A.grid_position == _position:
						_slots.append(_l.element_B.grid_position)
					
					else:
						_slots.append(_l.element_A.grid_position)


func _process(delta):
	time += delta
	animation = cos(time * ANIMATION_SPEED)
	queue_redraw()


func _draw():
	var _motion := Vector2(abs(animation), abs(animation)) * 20.0
	
	for slot in _slots:
		var _pos := Vector2((slot * SLOT_SIZE) - TEXTURE_OFFSET[mode]) - _motion
		var _rect := Rect2(_pos, RECT_SIZE + (_motion * 2))
		
		match mode:
			Mode.ATTACK:
				var color := Color.RED
				color.a = abs(animation * 0.5)
				
				draw_texture_rect(SWORD, _rect, false, color)
				
			Mode.LINK:
				var color := Color.DARK_SEA_GREEN
				color.a = abs(animation * 0.7)
				draw_texture_rect(LINK, _rect, false, color)
				
			Mode.UNLINK:
				var color := Color.INDIAN_RED
				color.a = abs(animation * 0.7)
				draw_texture_rect(UNLINK, _rect, false, color)


