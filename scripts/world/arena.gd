class_name Arena extends Node2D


signal end_game(winner: int)

var server = TCPServer.new()

func _ready():
	server.listen(4545, "*")
	
	ServerManager.request_completed.connect(_on_request)
	ServerManager.request("https://alekyo4-congenial-space-adventure-qxwrp55gj7jh494-8081.preview.app.github.dev/?port=4545")


func _on_request(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	var json := JSON.new()
	json.parse(body.get_string_from_utf8())
	print(json.get_data())


func _process(_delta):
	var client: StreamPeerTCP = server.take_connection()
	
	if client:
		var status: int = client.get_status()
		
		if status == StreamPeerTCP.STATUS_CONNECTED:
			print("Usuário - ", client.get_connected_host(), " - bonito entrou: ", client.get_connected_port())
			
			client.put_string("Funfo garaio")
