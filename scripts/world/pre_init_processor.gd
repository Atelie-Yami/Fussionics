class_name PreInitProcessor extends ElementEffectProcessor




func _turn_machine_pre_init_turn(player: int):
	pass # Processa cada elemento com efeito pre init
	
	turn_machine.init_turn.emit(player)
