extends GridContainer



func _ready():
	for i in 12:
		var widget: Array = GameConfig.save.widgets_deck[i]
		if widget.is_empty():
			continue
		
		get_child(i).atomic_number = widget[0]
		get_child(i).ranking       = widget[1]


func save():
	for i in 12:
		if get_child(i).atomic_number == -1:
			GameConfig.save.widgets_deck[i] = []
		
		else:
			GameConfig.save.widgets_deck[i] = [
				get_child(i).atomic_number,
				get_child(i).ranking
			]
		
