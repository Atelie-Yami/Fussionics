
class_name TableElement extends Element


# Called when the node enters the scene tree for the first time.
func _ready():
	modulate=COLOR_SERIES[DATA[atomic_number][SERIE]]
	active = true
	disabled = true
	super()



func _mouse_entered():
	pass


func _mouse_exited():
	pass
