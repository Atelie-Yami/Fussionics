extends Control

@onready var List : VBoxContainer = $List_Panel/Separator/List
@onready var New_notific_icon : TextureRect = $Show_Notific/new_notific

var new_notific : PackedScene = preload("res://scenes/interface/main_menu/notific.tscn")

func _ready():
	
	create_notific(
		"Seja bem-vindo ao Fussionics!",
		"Jogue bastante! Apesar de não está jogavel, dá pra jogar.",
		false,false)

func create_notific(title : String,mensage : String,ok : bool = true,ignore : bool = true) -> void:
	
	var notific_button = new_notific.instantiate()
	List.add_child(notific_button)
	notific_button.start(title,mensage,ok,ignore)
	
	New_notific_icon.visible = true

func _show_notific_pressed():
	New_notific_icon.visible = false

func _bug_report_pressed():
	create_notific(
		"Reporte bugs!",
		"Reporte os bugs e ganhe nada!",
		false,false)
