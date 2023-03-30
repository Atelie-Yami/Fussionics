extends Control

@onready var List : VBoxContainer = $List_Panel/Separator/List
@onready var New_notific_icon : TextureRect = $Show_Notific/new_notific
@onready var Main_Player : Control = $".."

var new_notific : PackedScene = preload("res://scenes/interface/main_menu/Notification.tscn")

func create_notific(title : String,mensage : String = "",ok : bool = true,ignore : bool = true):
	
	var notific_button = new_notific.instantiate()
	List.add_child(notific_button)
#	notific_button.start(title,mensage,ok,ignore)
	
	New_notific_icon.visible = true
	
	return notific_button

func _show_notific_pressed() -> void:
	New_notific_icon.visible = false

func _bug_report_pressed() -> void: #Apenas pra testes.
	create_notific(
		"Reporte bugs!",
		"Reporte os bugs e ganhe nada!",
		true,false)

func confirm_request(user) -> void:
	Main_Player.friends.append(user)
	Main_Player.update_friend()
	Main_Player.pop_up("PEDIDO DE AMIZADE ACEITO.")
