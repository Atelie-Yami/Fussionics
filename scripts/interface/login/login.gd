
extends VBoxContainer

@onready var main : Control = $"../../.."

@onready var username : LineEdit = $email_pass/Username
@onready var password : LineEdit = $email_pass/Password
@onready var password_View : TextureButton = $email_pass/Password/view
@onready var Enter_Button : Button = $enter_button

@onready var info = [username,password]

#Visualizar a senha.
func _view_pressed() -> void:
	password.secret = !password.secret
	password_View.texture_normal = load(main.view_tex[int(password.secret)])

#Verifica e avisa o que tem de errado nos caracteres do username.
func _username_text_changed(new_text):
	main.erro(username,main.needed_char.username)

func _password_text_changed(new_text):
	main.erro(password,main.needed_char.password)

#Verifica se existe caracteres o suficiente para prosseguir.
func _login_error_verific():
	if visible == true:
		verify_provenance()

#Verificação de procedencia
func verify_provenance():
	Enter_Button.disabled = true
	main.error_text.text = "Falta caracteres para o nome."
	if username.text.length() >= main.needed_char.username:
		main.error_text.text = "Falta caracteres para a senha."
		if password.text.length() >= main.needed_char.password:
			Enter_Button.disabled = false
			main.error_text.text = "Correto."

#Após apertar o botão para prosseguir do login.
func _enter_button_pressed():
	main.game_login(username.text,password.text)
	main.error_text.text = ""
	main.emit_signal("login_confirm")
