extends HTTPRequest

class_name ServerManager

var URLS = {
	"register": "https://62f6-2804-29b8-50a7-4e50-1a91-fa6f-1a3a-f9be.sa.ngrok.io/user/register",
	"auth": "https://62f6-2804-29b8-50a7-4e50-1a91-fa6f-1a3a-f9be.sa.ngrok.io/user/auth",
	"me": "https://62f6-2804-29b8-50a7-4e50-1a91-fa6f-1a3a-f9be.sa.ngrok.io/user/me"
}

var response: Dictionary

signal data_recieved(result: int, response_code: int, headers: PackedStringArray, body: Dictionary)
func _ready():
	request_completed.connect(_on_request_completed)

func make_register(username: String, password: String):
	var body = {
		"name": username,
		"password": password.sha256_text()
	}
	
	return request(URLS.register, ["Content-Type: application/json"], HTTPClient.METHOD_POST, JSON.stringify(body))

func make_auth(username: String, password: String):
	var body = {
		"name": username,
		"password": password.sha256_text()
	}
	
	return request(URLS.auth, ["Content-Type: application/json"], HTTPClient.METHOD_POST, JSON.stringify(body))


func request_me(token: String):
	var auth = "authorization: Bearer %s" % token 
	print(auth)
	return request(URLS.me, [auth], HTTPClient.METHOD_GET)

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	var json := JSON.new()
	json.parse(body.get_string_from_utf8())
	emit_signal("data_recieved",result,response_code,headers,json.get_data())
