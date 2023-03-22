extends PanelContainer

signal ok
signal ignore

@onready var Ignore : Button = $VNotific/Mensage/Buttons/Ignore
@onready var Ok : Button = $VNotific/Mensage/Buttons/Ok
@onready var Title_Node : Button = $VNotific/Title
@onready var Text : Label = $VNotific/Mensage/text
@onready var Mensage_Node : VBoxContainer = $VNotific/Mensage

func start(title : String,mensage : String,ok_var : bool = true,ignore_var : bool = true) -> void:
	Title_Node.text = title
	Text.text = mensage
	Ignore.visible = ignore_var
	Ok.visible = ok_var

func _ok_pressed():
	emit_signal("ok")
	queue_free()

func _ignore_pressed():
	emit_signal("ignore")
	queue_free()

func _tittle_pressed():
	Mensage_Node.visible = !Mensage_Node.visible
	Title_Node.icon = null
