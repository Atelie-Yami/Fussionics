extends VBoxContainer

@onready var main : Control = $"../../.."

@onready var username : LineEdit = $email_pass/Username
@onready var password : LineEdit = $email_pass/Password
@onready var password_Confirmed : LineEdit = $email_pass/Password_Confirmed
@onready var password_View : TextureButton = $email_pass/Password_Confirmed/view
@onready var Enter_Button : Button = $enter_button

#Visualizar a senha.
func _view_pressed() -> void:
	password_Confirmed.secret = !password_Confirmed.secret
	password_View.texture_normal = load(main.view_tex[int(password_Confirmed.secret)])

func _username_text_changed(new_text):
	main.erro(username,main.needed_char.username)
	_login_error_verific()
func _password_text_changed(new_text):
	main.erro(password,main.needed_char.password)
	_login_error_verific()
func _password_confirmed_text_changed(new_text):
	main.verific_confirmed(password,password_Confirmed)


func _login_error_verific():
	if visible == true:
		verify_provenance()

#verifica todas as procedencias
func verify_provenance():
	Enter_Button.disabled = true
	main.error_text.text = "Falta caracteres para o nome."
	if username.text.length() >= main.needed_char.username: 
		main.error_text.text = "Alcançou o limite de caracteres."
		if username.text.length() <= main.needed_char.max_username:
			main.error_text.text = "Falta caracteres para a senha."
			if password.text.length() >= main.needed_char.password:
				main.error_text.text = "A confirmação e a senha estão incorretas."
				if password_Confirmed.text == password.text:
					password_Confirmed.self_modulate = Color(1,1,1)
					Enter_Button.disabled = false
					main.error_text.text = "Correto."


#O botao de confirmar do registro
func _enter_button_pressed():
	main.game_register(username.text,password.text)
	main.emit_signal("register_confirm")
