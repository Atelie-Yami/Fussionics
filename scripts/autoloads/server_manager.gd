extends Node

const URLS = {
	"register": "https://62f6-2804-29b8-50a7-4e50-1a91-fa6f-1a3a-f9be.sa.ngrok.io/user/register",
	"auth": "https://62f6-2804-29b8-50a7-4e50-1a91-fa6f-1a3a-f9be.sa.ngrok.io/user/auth",
	"me": "https://62f6-2804-29b8-50a7-4e50-1a91-fa6f-1a3a-f9be.sa.ngrok.io/user/me"
}

signal data_recieved(result: int, response_code: int, headers: PackedStringArray, body)


func make_request(url: String, headers: Array, method: int, body: Dictionary = {}, callback: Callable = func():) -> Error:
	var manager = HTTPRequest.new()
	manager.request_completed.connect(_on_request_completed)
	add_child(manager)
	data_recieved.connect(callback)
	
	var error := manager.request(url, headers, method, JSON.stringify(body))
	await data_recieved
	manager.queue_free()
	return error

func make_register(username: String, password: String, callback: Callable) -> Error:
	var body = {
		"name": username,
		"password": password.sha256_text()
	}
	
	return await make_request(URLS.register, ["Content-Type: application/json"], HTTPClient.METHOD_POST, body, callback)

func make_auth(username: String, password: String, callback: Callable) -> Error:
	var body = {
		"name": username,
		"password": password.sha256_text()
	}
	
	return await make_request(URLS.auth, ["Content-Type: application/json"], HTTPClient.METHOD_POST, body, callback)
	
func request_user(token: String, callback: Callable) -> Error:
	var auth = "authorization: Bearer %s" % token 
	print(auth)
	
	return await make_request(URLS.me, [auth], HTTPClient.METHOD_GET, {}, callback)

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray = [], body: PackedByteArray = []):
	var json := JSON.new()
	json.parse(body.get_string_from_utf8())
	data_recieved.emit(result, response_code, headers, json.get_data())
 
