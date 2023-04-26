extends GridContainer


func _ready():
	for i in GameConfig.widgets.size():
		get_child(i).modulate.a    = 1.0
		get_child(i).ranking       = GameConfig.widgets[i].ranking
		get_child(i).atomic_number = GameConfig.widgets[i].atomic_number
