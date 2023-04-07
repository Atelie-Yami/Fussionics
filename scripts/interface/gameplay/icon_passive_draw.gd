class_name PassiveIcon extends TextureRect

const ICONS := preload("res://assets/img/debuff_buff/buff_debuff.svg")
const ICON_SIZE := 161.0
const ICON_GRID_SIZE := Vector2(ICON_SIZE, ICON_SIZE)
const RECT_ICON := Rect2(6, 6, 28, 28)
const DEBUFFS := {
	PassiveEffect.Debuff.ATTACK_BLOQ: Vector2(3, 0),
	PassiveEffect.Debuff.LINK_BLOQ: Vector2(1, 0),
	PassiveEffect.Debuff.UNLINK_BLOQ: Vector2(0, 0),
	PassiveEffect.Debuff.BURNING: Vector2(2, 0),
}
const BUFFS := {
	PassiveEffect.Buff.IMORTAL: Vector2(0, 1),
	PassiveEffect.Buff.DOUBLE_ATTACK: Vector2(1, 1),
}

var can_draw: bool

var icon_position: Vector2:
	set(value):
		icon_position = value
		can_draw = true
		queue_redraw()


func _draw():
	if can_draw:
		var rect_source := Rect2(ICON_GRID_SIZE * icon_position, ICON_GRID_SIZE)
		draw_texture_rect_region(ICONS, RECT_ICON, rect_source)
