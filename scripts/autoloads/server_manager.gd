extends HTTPRequest

class_name ServerManager

var URLS = {
	"register": "https://62f6-2804-29b8-50a7-4e50-1a91-fa6f-1a3a-f9be.sa.ngrok.io/user/register",
	"auth": "https://62f6-2804-29b8-50a7-4e50-1a91-fa6f-1a3a-f9be.sa.ngrok.io/user/auth"
}

var response: Dictionary


#func _ready():
#	request_completed.connect(_on_request_completed)

func make_register(username: String, email: String, password: String):
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

#func _on_register_response(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
#	var json := JSON.new()
#	json.parse(body.get_string_from_utf8())
#	response = {
#		result: result, 
#		response_code: response_code, 
#		body: json.get_data() 
#	}
