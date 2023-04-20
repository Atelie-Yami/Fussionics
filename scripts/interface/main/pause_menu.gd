extends Control
class_name PauseMenu



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

@export var OptionsMenu:VBoxContainer

@export var InGame=false


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


func _close_options_settings_pressed():
	visible=false
	if InGame:
		OptionsMenu.visible=true




