extends Button

enum Mode {
	NORMAL, MINIBOSS, BOSS
}
enum Type {
	DISABLED, NEXT, PASSED
}
const BALL_RADIUS := 4
const CIRCLE_RADIUS := 4
const LAST_BALL_POS := [26, 15, 1]
const BEGIN_BALL_POS := [94, 105]
const LAST_LINE_POS := [24, 10]
const BEGIN_LINE_POS := [96, 110]

var level_id: int

var mode: int
var type: int
var begin: bool
var last: bool

@onready var phases = $"../"

@onready var mini_boss = $mini_boss
@onready var normal = $normal
@onready var boss = $boss


func set_mode(_mode: int, skin: Texture, _type: int):
	type = _type
	mode = _mode
	
	get_children().map(func(c): c.visible = false)
	get_child(mode).visible = true
	
	disabled = type == Type.DISABLED
	queue_redraw()
	
	match mode:
		Mode.MINIBOSS:
			mini_boss.texture = skin
		
		Mode.BOSS:
			boss.texture = skin


func _draw():
	var color := Color.WHITE
	
	if not begin and mode != 2:
		draw_line(Vector2(0, 60), Vector2(LAST_LINE_POS[mode], 60), Color.WHITE if type != Type.DISABLED else Color.DIM_GRAY, 2)
	
	if not last and mode != 2:
		draw_line(Vector2(BEGIN_LINE_POS[mode], 60), Vector2(120, 60), Color.WHITE if type == Type.PASSED else Color.DIM_GRAY, 2)
	
	
	match type:
		Type.DISABLED:
			draw_circle(Vector2(LAST_BALL_POS[mode], 60), BALL_RADIUS, Color.DIM_GRAY)
			if mode != 2:
				draw_circle(Vector2(BEGIN_BALL_POS[mode], 60), BALL_RADIUS, Color.DIM_GRAY)
		
		Type.NEXT:
			draw_arc(Vector2(LAST_BALL_POS[mode], 60), CIRCLE_RADIUS, 0, TAU, 64, Color.WHITE, 1, true)
			if mode != 2:
				draw_circle(Vector2(BEGIN_BALL_POS[mode], 60), BALL_RADIUS, Color.DIM_GRAY)
		
		Type.PASSED:
			if not begin:
				draw_circle(Vector2(LAST_BALL_POS[mode], 60), BALL_RADIUS, Color.WHITE)
			
			if not last and mode != 2:
				draw_circle(Vector2(BEGIN_BALL_POS[mode], 60), BALL_RADIUS, Color.WHITE)
	
	
	


func _is_pressed():
	phases.load_level(level_id)
