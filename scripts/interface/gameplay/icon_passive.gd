extends TextureRect


@export_enum("Buff", "Debuff") var type: int

var passive: PassiveEffect

@onready var passive_descrition = $"../../../../../../info_panel/passive_descrition"


func load_passive(_passive: PassiveEffect):
	passive = _passive
	if type:
		passive = passive as PassiveEffect.DebuffEffect
		passive.type
	
	else:
		passive = passive as PassiveEffect.DebuffEffect


func _gui_input(event):
	if event.is_action("mouse_click") and event.is_pressed():
		passive_descrition.laod_data(passive)
		passive_descrition.visible = true

