extends PanelContainer


@onready var passive_name = $MarginContainer/VBoxContainer/HBoxContainer/name
@onready var debuff = $MarginContainer/VBoxContainer/HBoxContainer/debuff
@onready var buff = $MarginContainer/VBoxContainer/HBoxContainer/buff
@onready var info_container = $MarginContainer/VBoxContainer/HBoxContainer2
@onready var info_1 = $MarginContainer/VBoxContainer/HBoxContainer2/info1
@onready var info_2 = $MarginContainer/VBoxContainer/HBoxContainer2/info2
@onready var info_3 = $MarginContainer/VBoxContainer/HBoxContainer2/info3
@onready var descrition = $MarginContainer/VBoxContainer/descrition


func _process(delta):
	size = Vector2.ZERO


func laod_data(passive: PassiveEffect):
	if passive is PassiveEffect.DebuffEffect:
		debuff.icon_position = debuff.DEBUFFS[passive.type]
		debuff.visible = true
		buff.visible = false
		
		passive_name.text = tr(PassiveEffect.Debuff.keys()[passive.type])
		descrition.text = tr("DESCRITION_" + PassiveEffect.Debuff.keys()[passive.type])
	
	elif passive is PassiveEffect.BuffEffect:
		buff.icon_position = buff.BUFFS[passive.type]
		debuff.visible = false
		buff.visible = true
		
		passive_name.text = tr(PassiveEffect.Buff.keys()[passive.type])
		descrition.text = tr("DESCRITION_" + PassiveEffect.Buff.keys()[passive.type])
	
	info_container.get_children().map(func(c): c.visible = false; c.text = "")
	
	if passive.stack > 0:
		info_1.text = tr("STACK") + str(passive.stack)
		info_1.visible = true
	
	if passive.level > 0:
		info_2.text = tr("LEVEL") + str(passive.level)
		info_2.visible = true
	
	info_3.text = tr(PassiveEffect.PassiveEffectLifetimeType.keys()[passive.cust_type])
	info_3.visible = true
	
	match passive.cust_type:
		PassiveEffect.PassiveEffectLifetimeType.TEMPORAL, PassiveEffect.PassiveEffectLifetimeType.EFEMERAL:
			info_3.text += str(passive.life_time)


