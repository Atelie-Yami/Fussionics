extends Timer


@onready var turn_machine: TurnMachine = $".."


func _turn_machine_init_turn(player):
	pass # Replace with function body.
	
	turn_machine.main_turn.emit(player)
