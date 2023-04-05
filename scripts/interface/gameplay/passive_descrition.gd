extends PanelContainer


@onready var passive_name = $MarginContainer/VBoxContainer/HBoxContainer/name
@onready var debuff = $MarginContainer/VBoxContainer/HBoxContainer/debuff
@onready var buff = $MarginContainer/VBoxContainer/HBoxContainer/buff
@onready var info = $MarginContainer/VBoxContainer/info
@onready var descrition = $MarginContainer/VBoxContainer/descrition


func laod_data(passive: PassiveEffect):
	if passive is PassiveEffect.DebuffEffect:
		debuff.visible = true
		buff.visible = false
		
		passive_name.text = tr(PassiveEffect.Debuff.keys()[passive.type])
		descrition.text = tr("DESCRITION_" + PassiveEffect.Debuff.keys()[passive.type])
	
	elif passive is PassiveEffect.BuffEffect:
		debuff.visible = false
		buff.visible = true
		
		passive_name.text = tr(PassiveEffect.Buff.keys()[passive.type])
		descrition.text = tr("DESCRITION_" + PassiveEffect.Buff.keys()[passive.type])


func _close_pressed():
	visible = false


func _unhandled_input(event):
	if (event.is_action("mouse_click") or event.is_action("ui_cancel")) and event.is_pressed():
		visible = false
