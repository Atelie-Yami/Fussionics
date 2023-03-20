extends Control

signal error_verific
signal join_game
signal login_confirm
signal register_confirm

@onready var error_text : Label = $login_painel/lines_box/sep_up/error
@onready var login_panel = $login_painel/lines_box/login
@onready var register_panel = $login_painel/lines_box/register
@onready var enter_panel = $login_painel/lines_box/enter_direction
@onready var warning = $login_painel/lines_box/sep_up/warning

#Textura do visualizador.
var view_tex := [
	"res://assets/img/buttons/login/padlock/unlock.png",
	"res://assets/img/buttons/login/padlock/lock.png"
]

#A quantidade de caracteres precisos.
var needed_char = {
	password = 6,
	email = 13,
	username = 4
}

#Body da conta
var body :Dictionary = {
	verific_username = "bielas",
	verific_password = "helloworld"
}

#Verificação de email e senha após apertar enter (Login)
func game_login(username : String,password : String) -> void: 
	if username == body.verific_username and password == body.verific_password:
		login_panel.hide()
		enter_panel.show()
	else:
		warning.popup()

#Verificação de email e senha após apertar enter (Registro)
func game_register(username : String,password : String) -> void: 
	body.verific_username = username
	body.verific_password = password
	
	login_panel.show()
	register_panel.hide()


#Erros sobre as informações.
func erro(line : LineEdit,lenght : int) -> void:
	
	# a quantidade
	if line.text.length() < lenght:
		line.self_modulate = Color.DARK_RED
		line.tooltip_text = str("Falta ",lenght-line.text.length()," caracteres")
	else:
		line.self_modulate = Color.WHITE
		line.tooltip_text = str("Certo")
	
	emit_signal("error_verific")


#Verifica se a confirmação é igual a informação
func verific_confirmed(info,confirmed) -> void:
	if confirmed.text != info.text:
		confirmed.self_modulate = Color.DARK_RED
		confirmed.tooltip_text = str("Está diferente")
	else:
		confirmed.tooltip_text = str("Correto")
	
	emit_signal("error_verific")


func _warning_confirmed():
	login_panel.username.text = ""
	login_panel.password.text = ""
	register_panel.username.text = ""
	register_panel.password.text = ""
	register_panel.password_Confirmed.text = ""
