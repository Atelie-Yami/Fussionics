extends TextureRect


@export_enum("Buff", "Debuff") var type: int

var mouse_hover: bool
var passive: PassiveEffect

@onready var passive_descrition = $"../../../../../../info_panel/passive_descrition"


func _init():
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)


func _mouse_entered():
	mouse_hover = true
	passive_descrition.laod_data(passive)
	
	var offset: Vector2
	offset.y = passive_descrition.size.y
	offset.x = passive_descrition.size.x / 2
	passive_descrition.position = global_position - offset
	passive_descrition.visible = true

func _mouse_exited():
	mouse_hover = false
	passive_descrition.visible = false


func load_passive(_passive: PassiveEffect):
	passive = _passive
	if type:
		passive = passive as PassiveEffect.DebuffEffect
		passive.type
	
	else:
		passive = passive as PassiveEffect.DebuffEffect



