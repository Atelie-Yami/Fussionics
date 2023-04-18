extends Control
class_name PauseMenu

signal close_menu

#Video
@export var DisplayModeButton:OptionButton
@export var MaxFpsValueLabel:Label
@export var MaxFpsSlider:HSlider


#VideoEnd
#Audio
@export var MasterVolumeValueLabel:Label
@export var MasterVolumeSlider:HSlider
@export var MusicVolumeValueLabel:Label
@export var MusicVolumeSlider:HSlider
@export var SFXVolumeValueLabel:Label
@export var SFXVolumeSlider:HSlider

#AudioEnd
#OptionMenu Var
@export var OptionsSettings:Control
@export var OptionsMenu:VBoxContainer

#OptionMenu Var End
@export var InGame=true


func _ready():
	DisplayModeButton.add_item("Windowed")
	DisplayModeButton.add_item("Fullscreen")
	DisplayModeButton.select(1)


#Video Settings
func ChangeModeScreen(value)->void:
	if value=="Windowed":
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func ChangeVsync(value:bool)->void:
	if value:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func ChangeMaxFps(value)->void:
	Engine.max_fps=value


func _display_mode_button_item_selected(index):
	ChangeModeScreen(
		"Fullscreen" if index==1 else "Windowed"
	)


func _vsync_button_toggled(button_pressed):
	ChangeVsync(button_pressed)


func _max_fps_slider_value_changed(value):
	ChangeMaxFps(value)
	MaxFpsValueLabel.text= str(value) if value < MaxFpsSlider.max_value else "Max"


#Video Settings END
#Audio Settings
func ChangeBusVolume(id,value)->void:
	AudioServer.set_bus_volume_db(id,value)


func _master_volume_slider_value_changed(value):
	ChangeBusVolume(0,value)
	MasterVolumeValueLabel.text= str(value) if value < MasterVolumeSlider.max_value else "Max"


func _music_volume_slider_value_changed(value):
	ChangeBusVolume(1,value)
	MusicVolumeValueLabel.text= str(value) if value < MusicVolumeSlider.max_value else "Max"


func _sfx_volume_slider_value_changed(value):
	ChangeBusVolume(2,value)
	SFXVolumeValueLabel.text= str(value) if value < SFXVolumeSlider.max_value else "Max"


#Audio Settings End
#OptionsMenu
func OpenOpitionSettings()->void:
	OptionsSettings.visible=true
#	var tween=create_tween()
#	tween.tween_property(OptionsSettings,"scale",Vector2(1,1),0.2).from(Vector2(0.1,0.1))


func OpenMenuSettings()->void:
	OptionsMenu.visible=true
	get_tree().paused = true
#	var tween=create_tween()
#	tween.tween_property(OptionsMenu,"scale",Vector2(1,1),0.2).from(Vector2(0.1,0.1))


func close_menu_settings()->void:
	OptionsSettings.visible = false
	OptionsMenu.visible = false
	get_tree().paused = false
	close_menu.emit()


func _settings_pressed():
	OptionsMenu.visible = false
	OpenOpitionSettings()


func _close_options_settings_pressed():
	OptionsSettings.visible=false
	if InGame:
		OpenMenuSettings()


func _voltar_pressed():
	close_menu_settings()


func _menu_inicial_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/interface/main_menu/main.tscn")


func _reiniciar_pressed():
	#Tem que ter condição para saber se esta online
	pass


func _sair_do_jogo_pressed():
	#Se quiser pode colocar algum save
	get_tree().quit()

#OptionsMenu End
