extends VBoxContainer





@export var OptionsSettings:Control


#Func


func OpenOpitionSettings()->void:
	OptionsSettings.visible=true


#End Funcs 


#Buttons


func _back_pressed():
	get_parent().close_menu_settings()


func _restart_pressed():
	#You must have a condition to know if you are online
	pass


func _settings_pressed():
	visible = false
	OpenOpitionSettings()



func _main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/interface/main_menu/main.tscn")



func _exit_pressed():
	#If you want you can put some save
	get_tree().quit()


##Buttons End




