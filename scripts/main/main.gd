extends Control

@onready var Id_Line : LineEdit = $"Pop-up/Solicit/Control/Vbox/Id"
@onready var Pop : AcceptDialog = $"Pop-up/Pop_Common"
@onready var Friend_List : VBoxContainer = $Tab/Menu/Friends_Main/Options/List

var mensage : Dictionary = {
	id_error = "ID DE USUARIO NÃO EXISTE.",
	id_found = "PEDIDO ENVIADO.",
	id_already_exists = "VOCÊ JÁ TEM ESTE AMIGO ADICIONADO.",
}

var friends : Array = []

var people : Array = [
	{nick = "anti-tchola",id=1},
	{nick = "mcpipoka",id=2},
]

func verific_provenance(id):
	
	for user in people:
		
		if int(id) == user.id:
			if verific_already_exists(int(id)):
				return
			friends.append(user)
			update_friend()
			pop_up(mensage.id_found)
			return
	
	pop_up(mensage.id_error)

func verific_already_exists(id):
	for fri in friends:
		if id == fri.id:
			pop_up(mensage.id_already_exists)
			return true

func update_friend():
	for children in Friend_List.get_children():
		children.queue_free()
	
	for user in friends:
		config_button(user.nick,user.id)

func config_button(nick,id):
	var friend_button : Button = Button.new()
	Friend_List.add_child(friend_button)
	friend_button.expand_icon = true
	friend_button.icon = load("res://assets/img/icon.svg")
	friend_button.text = str(nick," #",id)

func pop_up(mens):
	Pop.error_text.text = str(mens)
	Pop.popup_centered()

func _send_pressed():
	verific_provenance(Id_Line.text)
