extends VBoxContainer

@onready var main = $"../../.."

func _enter_pressed():
	main.emit_signal("join_game")
	var manager = ServerManager.new()
	add_child(manager)
	var error = manager.request_me(Gameplay.token)
	
	var response = func(result: int, response_code: int, headers: PackedStringArray, body: Dictionary):
		print(response_code, body)
		manager.queue_free()

	manager.data_recieved.connect(response)
