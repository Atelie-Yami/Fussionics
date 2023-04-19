extends Button

enum Mode {
	NORMAL, MINIBOSS, BOSS
}

var level_id: int

@onready var phases = $"../"

@onready var mini_boss = $mini_boss
@onready var normal = $normal
@onready var boss = $boss


func set_mode(mode: int, skin: Texture):
	get_children().map(func(c): c.visible = false)
	get_child(mode).visible = true
	
	match mode:
		Mode.MINIBOSS:
			mini_boss.texture = skin
		
		Mode.BOSS:
			boss.texture = skin


func _is_pressed():
	phases.load_level(level_id)
