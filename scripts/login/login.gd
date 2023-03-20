
extends VBoxContainer

@onready var main : Control = $"../../.."

@onready var Email : LineEdit = $email_pass/Email
@onready var Password : LineEdit = $email_pass/Password
@onready var Password_View : TextureButton = $email_pass/Password/view
@onready var Enter_Button : Button = $enter_button

#Visualizar a senha.
func _view_pressed() -> void:
	Password.secret = !Password.secret
	Password_View.texture_normal = load(main.view_tex[int(Password.secret)])

#Verifica e avisa o que tem de errado nos caracteres do email.
func _email_text_changed(new_text):
	main.erro(Email,main.needed_char.email)

func _password_text_changed(new_text):
	main.erro(Password,main.needed_char.password)

#Verifica se existe caracteres o suficiente para prosseguir.
func _login_error_verific():
	Enter_Button.disabled = !(Email.text.length() > 13 and Password.text.length() > 6)

#Após apertar o botão para prosseguir.
func _enter_button_pressed():
	pass
#	ServerManager.make_auth(Email.text, Password.text)
