extends Control

signal close_menu

func close_menu_settings()->void:
	visible=false
	get_tree().paused = false
	close_menu.emit()



func OpenMenuSettings()->void:
	visible=true
	get_tree().paused = true



func Set_ingame():
	$OptionsSettings.InGame=true
