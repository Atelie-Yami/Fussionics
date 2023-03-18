extends Control

signal error_verific

#Textura do visualizador.
var view_tex := [
	"res://assets/img/buttons/login/padlock/unlock.png",
	"res://assets/img/buttons/login/padlock/lock.png"
]

#A quantidade de caracteres precisos.
var needed_char = {
	password = 6,
	email = 13,
}


#Erros sobre as informações.
func erro(node : LineEdit,lenght : int) -> void:
	if node.text.length() < lenght:
		node.self_modulate = Color(1, 0.54117649793625, 0.78039216995239)
		node.tooltip_text = str("Falta ",lenght-node.text.length()," caracteres")
	else:
		node.self_modulate = Color(1,1,1,1)
		node.tooltip_text = str("Certo")
	
	emit_signal("error_verific")


#Verifica se a confirmação é igual a informação
func verific_confirmed(info,confirmed) -> void:
	if confirmed.text != info.text:
		confirmed.self_modulate = Color(1, 0.54117649793625, 0.78039216995239)
		confirmed.tooltip_text = str("Está diferente")
	else:
		confirmed.tooltip_text = str("Correto")
	
	emit_signal("error_verific")
