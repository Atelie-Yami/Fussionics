extends Control

@onready var Notification_Node : Control = $Notification
@onready var Id_Line : LineEdit = $"Pop-up/Solicit/Control/Vbox/Id"
@onready var Pop : AcceptDialog = $"Pop-up/Pop_Common"
@onready var Friend_List : VBoxContainer = $Tab/Menu/Friends_Main/Options/List
@onready var Name_Label : Label = $Tab/Menu/h/Tab/Name

var body : Dictionary = {
	username = "name",
	id = 1,
}

var friends : Array = []

var mensage : Dictionary = {
	welcome = "Seja bem-vindo ao Fussionics!",
	welcome_desc = "Jogue bastante! Apesar de não está jogavel, dá pra jogar.",
	
	id_error = "ID DE USUARIO NÃO EXISTE.",
	id_found = "PEDIDO ENVIADO.",
	id_already_exists = "VOCÊ JÁ TEM ESTE AMIGO ADICIONADO.",
}

# Pessoas registradas.
var people : Array = [
	{nick = "rafael",id=2},
	{nick = "baby",id=3},
]


func _ready() -> void:
	loading_info()

func loading_info():
	Name_Label.text = str(body.username," #",body.id)
	
	Notification_Node.create_notific(
		mensage.welcome,
		mensage.welcome_desc,
		false,false,
	)

func verific_provenance(id):
	
	for user in people:
		if int(id) == user.id:
			if verific_already_exists(int(id)):
				return
			send_request(user)
			return
		
	pop_up(mensage.id_error)

func receive_request(user) -> void:
	var noti = Notification_Node.create_notific(str("Pedido recebido de ",user.nick,"."),
	"Deseja aceitar?")
	noti.ok.connect(Notification_Node.confirm_request.bind(user))

func send_request(user) -> void:
	friends.append(user)
	update_friend()
	pop_up(mensage.id_found)
	
	#Mensage
	Notification_Node.create_notific(str("Pedido enviado para ",user.nick,"."),
		"Seu amigo recebera a notificação de pedido de amizade, espere até lá.",
		false
	)

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


