extends Panel


@onready var grid_container = $GridContainer
var has_widget: bool


func _ready():
	for i in 12:
		if (GameConfig.save.widgets_deck[i] as Array).is_empty():
			continue
		
		(grid_container.get_child(i) as WidgetSlot).atomic_number = GameConfig.save.widgets_deck[i][0]
		(grid_container.get_child(i) as WidgetSlot).ranking = GameConfig.save.widgets_deck[i][1]
		has_widget = true

