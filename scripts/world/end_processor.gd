extends Timer


@onready var turn_machine: TurnMachine = $".."


func _turn_machine_end_turn(player):
	pass # Processa cada elemento com efeito end
	
	turn_machine.start_turn()
