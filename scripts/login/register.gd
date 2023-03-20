extends VBoxContainer

@onready var main : Control = $"../../.."

@onready var Email : LineEdit = $email_pass/Email
@onready var Email_Confirmed : LineEdit = $email_pass/Email_Confirmed
@onready var Password : LineEdit = $email_pass/Password
@onready var Password_Confirmed : LineEdit = $email_pass/Password_Confirmed
@onready var Password_View : TextureButton = $email_pass/Password_Confirmed/view
@onready var Enter_Button : Button = $enter_button

#Visualizar a senha.
func _view_pressed() -> void:
	Password_Confirmed.secret = !Password_Confirmed.secret
	Password_View.texture_normal = load(main.view_tex[int(Password_Confirmed.secret)])

#Verifica e avisa o que tem de errado nos caracteres do email.
func _email_text_changed(new_text):
	main.erro(Email,main.needed_char.email)
func _password_text_changed(new_text):
	main.erro(Password,main.needed_char.password)
func _password_confirmed_text_changed(new_text):
	main.verific_confirmed(Password,Password_Confirmed)
func _email_confirmed_text_changed(new_text):
	main.verific_confirmed(Email,Email_Confirmed)


#Verifica se existe caracteres o suficiente para prosseguir.
func _login_error_verific():
	Enter_Button.disabled = !(Email.text.length() > 13 and Password.text.length() > 6)
	if Email_Confirmed.text == Email.text:
		Email_Confirmed.self_modulate = Color(1,1,1)
	if Password_Confirmed.text == Password.text:
		Password_Confirmed.self_modulate = Color(1,1,1)



func _enter_button_pressed():
	var manager = ServerManager.new()
	add_child(manager)
	var error = manager.make_register(Email.text, Email.text, Password.text)
	
	var response = func(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
		print(response_code)
		manager.queue_free()

	manager.request_completed.connect(response)
 
