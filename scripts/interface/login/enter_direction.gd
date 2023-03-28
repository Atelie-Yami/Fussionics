extends VBoxContainer

@onready var main = $"../../.."

func _enter_pressed():
	main.emit_signal("join_game")
	main.get_user_data()
