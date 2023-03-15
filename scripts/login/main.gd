extends Control

#Textura do visualizador.
var view_tex := [
	"res://assets/img/buttons/login/eyes/eye_open.png",
	"res://assets/img/buttons/login/eyes/eye_closed.png"
]

#A quantidade de caracteres precisos.
var needed_char = {
	password = 6,
	email = 13,
}

#HUD.
@onready var password_line : LineEdit = $login_painel/lines_box/login/email_pass/Password
@onready var email_line : LineEdit= $login_painel/lines_box/login/email_pass/Email
@onready var view_password : Button = $login_painel/lines_box/login/email_pass/Password/view
@onready var enter_button : Button= $login_painel/lines_box/login/enter_button

@onready var timer_verific : Timer = $verific_info

#Visualizar a senha.
func _view_pressed() -> void:
	password_line.secret = !password_line.secret
	view_password.icon = load(view_tex[int(password_line.secret)])

#Verifica se existe a quantidade ideal para se logar.
func verific() -> void:
	enter_button.disabled = !(email_line.text.length() > 13 and password_line.text.length() > 6)
	timer_verific.start()

#Atualização a verificação de procedencia.
func _email_text_changed(new_text : String) -> void:
	verific()
func _password_text_changed(new_text : String) -> void:
	verific()

func _enter_pressed():
	print("hello world!")

#Erros sobre as informações.
func erro(node : LineEdit,lenght : int) -> void:
	if node.text.length() < lenght:
		node.self_modulate = Color(1, 0.54117649793625, 0.78039216995239)
		node.tooltip_text = str("Falta ",lenght-node.text.length()," caracteres.")
	else: 
		node.self_modulate = Color(1, 1, 1)
		node.tooltip_text = str("Está correto.")

#Timer, verifica se falta algo para se logar.
func _verific_info_timeout():
	erro(email_line,needed_char.email)
	erro(password_line,needed_char.password)
