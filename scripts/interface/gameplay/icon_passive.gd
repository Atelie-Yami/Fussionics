extends TextureRect


@export_enum("Buff", "Debuff") var type: int


func load_passive(_passive: PassiveEffect):
	if type:
		var passive: PassiveEffect.DebuffEffect = _passive
		
		passive.type
	
	else:
		var passive: PassiveEffect.BuffEffect = _passive

