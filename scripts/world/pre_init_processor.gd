class_name PreInitProcessor extends Timer


@onready var turn_machine: TurnMachine = $".."


func _turn_machine_pre_init_turn(player: int):
	pass # Processa cada elemento com efeito pre init
	
	turn_machine.init_turn.emit(player)
