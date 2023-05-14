extends Control

enum Mode {
	ATTACK, LINK, UNLINK
}
const EXCLAMATION := preload("res://assets/img/interface/exclamation.png")
const SHIELD_NORMAL := preload("res://resouces/atlas/gameplay/icon_shiled.atlastex")
const SHIELD_TARGET := preload("res://resouces/atlas/gameplay/icon_shiled_target.atlastex")
const SWORD := preload("res://assets/img/interface/sword.png")
const LINK := preload("res://assets/img/interface/link.png")
const UNLINK := preload("res://assets/img/interface/unlink.png")
const SLOT_SIZE := 90.0
const RECT_SIZE := Vector2(SLOT_SIZE, SLOT_SIZE)
const ANIMATION_SPEED := 2.5
const TEXTURE_OFFSET := [Vector2(3, 3), Vector2(5, 5), Vector2(3, 3)]

const INDICATION_ALPHA := 0.7

var mode: Mode
var time := 0.0
var animation := 0.0
var animation_2 := 0.0
var _slots: Array[Vector2i]
var _defended: Array[Vector2i]
var _defensor := Vector2(20, 0)
var element_in_action := Vector2(20, 0)


func _init():
	global_position = Vector2(605, 320)
	z_index = 10


func set_slots(elements: Dictionary, _mode: int, args = null):
	_defended.clear()
	_slots.clear()
	mode = _mode
	time = 0.0
	_defensor.x = 20
	
	if mode == Mode.ATTACK:
		var has_enemies: bool
		for slot in elements:
			if elements[slot].player == PlayerController.Players.B:
				if elements[slot].element.in_reactor:
					continue
				has_enemies = true
				
				if elements[slot].molecule and elements[slot].molecule.defender:
					if elements[slot].molecule.defender == elements[slot].element:
						_defensor = elements[slot].element.grid_position
					else:
						_defended.append(elements[slot].element.grid_position)
				else:
					_slots.append(elements[slot].element.grid_position)
		
		Gameplay.world.attack_omega.visible = not has_enemies
		
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
	animation = abs(cos(time * ANIMATION_SPEED))
	animation_2 = abs(cos(time * ANIMATION_SPEED * 2.0))
	queue_redraw()


func _draw():
	var _motion := Vector2(animation, animation) * 10.0
	
	if mode == Mode.ATTACK:
		for slot in _defended:
			var _pos := Vector2(slot * SLOT_SIZE) + _motion - Vector2(5, 5)
			var _rect := Rect2(_pos, RECT_SIZE - (_motion * 2))
			var _color_a := animation
			
			draw_texture_rect(SHIELD_NORMAL, _rect, false, Color.SKY_BLUE * animation * INDICATION_ALPHA)
	
	if _defensor.x < 20:
		var _pos := Vector2(_defensor * SLOT_SIZE) + _motion - Vector2(5, 5)
		var _rect := Rect2(_pos, RECT_SIZE - (_motion * 2))
		var _color_a := animation
		
		draw_texture_rect(SHIELD_TARGET, _rect, false, Color.ORANGE_RED * animation * INDICATION_ALPHA)
	
	for slot in _slots:
		var _pos := Vector2(slot * SLOT_SIZE) + _motion
		var _rect := Rect2(_pos, RECT_SIZE - (_motion * 2))
		var _color_a := animation
		
		match mode:
			Mode.ATTACK:
				draw_texture_rect(SWORD, _rect, false, Color.RED * animation * INDICATION_ALPHA)
				
			Mode.LINK:
				draw_texture_rect(LINK, _rect, false, Color("#ccffd8") * _color_a)
				
			Mode.UNLINK:
				draw_texture_rect(UNLINK, _rect, false, Color("#ffd2a9") * _color_a)
	
	if element_in_action.x < 20:
		var _pos := element_in_action * SLOT_SIZE
		var _rect := Rect2(_pos + Vector2(15, -20), Vector2(50, 50))
		draw_texture_rect(EXCLAMATION, _rect, false, Color("#ffff6c") * animation_2)

