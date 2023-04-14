extends Control


@onready var camera = $Camera
@onready var v_scroll_bar = $Buttons/Scroll/VScrollBar
@onready var h_scroll_bar = $Buttons/Scroll/HScrollBar

var in_zoom: bool


func _voltar_pressed():
	get_tree().change_scene_to_file("res://scenes/interface/main_menu/main.tscn")


func _h_scroll_bar_scrolling():
	camera.position.x = h_scroll_bar.value

func _physics_process(delta):
	in_zoom = camera.zoom.x > 1.15
	h_scroll_bar.visible = in_zoom
	v_scroll_bar.visible = in_zoom
	
	if camera.zoom.x > 1.15:
		h_scroll_bar.max_value = camera.limit_right * (camera.zoom.x - camera.zoom.x / 2)
		v_scroll_bar.max_value = camera.limit_bottom * (camera.zoom.y - camera.zoom.y / 2)


func _v_scroll_bar_scrolling():
	camera.position.y = v_scroll_bar.value
