extends Button

const TEXTURE := preload("res://assets/img/interface/menu.svg")

enum Mode {
	NORMAL, MINIBOSS, BOSS
}
enum Type {
	DISABLED, NEXT, PASSED
}
const BALL_RADIUS := 4
const CIRCLE_RADIUS := 4
const LAST_BALL_POS := [34, 15, 1]
const BEGIN_BALL_POS := [86, 105]
const BEGIN_LINE_POS := [88, 109]
const LAST_LINE_POS := [30, 11]
const RECT_BASE := [
	Rect2(Vector2(44, 44), Vector2(32, 32)),
	Rect2(Vector2(20, 20), Vector2(80, 80)),
	Rect2(Vector2(-9.7, 7), Vector2(136, 110.5)),
]
const RECT_SOUCE := [
	[
		Rect2(Vector2(1364, 957), Vector2(301, 301)),
		Rect2(Vector2(495, 957), Vector2(301, 301)),
		Rect2(Vector2(941, 957), Vector2(301, 301)),
	],
	[
		Rect2(Vector2(1356, 1310), Vector2(317, 317)),
		Rect2(Vector2(482, 1306), Vector2(326, 326)),
		Rect2(Vector2(932, 1310), Vector2(317, 317)),
	],
	[
		Rect2(Vector2(1316, 1669), Vector2(387, 314)),
		Rect2(Vector2(446, 1669), Vector2(387, 314)),
		Rect2(Vector2(893, 1669), Vector2(387, 314)),
	],
]

var level_id: int
var mode: Mode
var type: Type
var begin: bool
var last: bool

@onready var phases = $"../"

@onready var mini_boss = $mini_boss
@onready var boss = $boss


func set_mode(_mode: int, skin: Texture, _type: int):
	type = _type
	mode = _mode
	
	get_children().map(func(c): c.visible = false)
	disabled = type == Type.DISABLED
	queue_redraw()
	
	match mode:
		Mode.MINIBOSS:
			mini_boss.texture = skin
			mini_boss.visible = true
		
		Mode.BOSS:
			boss.texture = skin
			boss.visible = true


func _draw():
	if mode != Mode.BOSS:
		if not begin:
			draw_line(Vector2(0, 60), Vector2(LAST_LINE_POS[mode], 60), Color.WHITE if type != Type.DISABLED else Color.DIM_GRAY, 2)
		
		if not last:
			draw_line(Vector2(BEGIN_LINE_POS[mode], 60), Vector2(120, 60), Color.WHITE if type == Type.PASSED else Color.DIM_GRAY, 2)
			
			if type == Type.PASSED:
				draw_circle(Vector2(BEGIN_BALL_POS[mode], 60), BALL_RADIUS, Color.WHITE)
		
		match type:
			Type.DISABLED:
				draw_circle(Vector2(BEGIN_BALL_POS[mode], 60), BALL_RADIUS, Color.DIM_GRAY)
			
			Type.NEXT:
				draw_circle(Vector2(BEGIN_BALL_POS[mode], 60), BALL_RADIUS, Color.DIM_GRAY)
	
	match type:
		Type.DISABLED:
			draw_circle(Vector2(LAST_BALL_POS[mode], 60), BALL_RADIUS, Color.DIM_GRAY)
			
		Type.NEXT:
			draw_arc(Vector2(LAST_BALL_POS[mode], 60), CIRCLE_RADIUS, 0, TAU, 64, Color.WHITE, 1, true)
			
		Type.PASSED:
			if not begin:
				draw_circle(Vector2(LAST_BALL_POS[mode], 60), BALL_RADIUS, Color.WHITE)
	
	draw_texture_rect_region(TEXTURE, RECT_BASE[mode], RECT_SOUCE[mode][type], Color.WHITE)
	
	if mode == Mode.NORMAL and type == Type.PASSED:
		draw_circle(Vector2(60, 60), 10, Color.WHITE)


func _is_pressed():
	phases.load_level(level_id)
