extends Control
class_name GuiMenu

@export var Settings:Control


func _modo_campanha_pressed():
	pass # Replace with function body.


func _partida_rapida_pressed():
	get_tree().change_scene_to_file("res://scenes/world/arena.tscn")


func _galeriafussion_pressed():
	get_tree().change_scene_to_file("res://scenes/interface/periodic_table/table.tscn")


func _configuraes_pressed():
	Settings.OpenOpitionSettings()


func _sairdo_jogo_pressed():
	#Se quiser pode colocar algum save
	get_tree().quit()


func _itch_pressed():
	OS.shell_open("https://itch.io/profile/atelie-yami")


func _insta_pressed():
	OS.shell_open("https://www.instagram.com/atelie.yami/")


func _twiter_pressed():
	OS.shell_open("https://twitter.com/AtelieYami")
