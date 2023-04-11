extends Control

@onready var Camera:CameraArena = get_node("CameraArena")
@onready var hScroll:HScrollBar = get_node("Buttons/Scroll/HScrollBar")
@onready var vScroll:VScrollBar = get_node("Buttons/Scroll/VScrollBar")



func _voltar_pressed():
	get_tree().change_scene_to_file("res://scenes/interface/main_menu/main.tscn")


func _h_scroll_bar_scrolling():
	Camera.position.x=hScroll.value

func _physics_process(delta):
	if Camera.zoom.x>1.15:
		hScroll.visible=true
		vScroll.visible=true
		hScroll.max_value=Camera.limit_right*(Camera.zoom.x-Camera.zoom.x/2)
		vScroll.max_value=Camera.limit_bottom*(Camera.zoom.y-Camera.zoom.y/2)
	else:
		hScroll.visible=false
		vScroll.visible=false


func _v_scroll_bar_scrolling():
	Camera.position.y=vScroll.value
