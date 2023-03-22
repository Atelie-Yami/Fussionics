extends HTTPRequest

class_name ServerManager

const URLS = {
	"register": "https://62f6-2804-29b8-50a7-4e50-1a91-fa6f-1a3a-f9be.sa.ngrok.io/user/register",
	"auth": "https://62f6-2804-29b8-50a7-4e50-1a91-fa6f-1a3a-f9be.sa.ngrok.io/user/auth",
	"me": "https://62f6-2804-29b8-50a7-4e50-1a91-fa6f-1a3a-f9be.sa.ngrok.io/user/me"
}

signal data_recieved(result: int, response_code: int, headers: PackedStringArray, body: Dictionary)

func _ready():
	request_completed.connect(_on_request_completed)

static func make_request(url: String, headers: Array, method: int, body: Dictionary = {}, callback: Callable = func():):
	var manager = ServerManager.new()
	Gameplay.add_child(manager)
	manager.data_recieved.connect(callback)
#	
	return manager.request(url, headers, method, JSON.stringify(body))

static func make_register(username: String, password: String, callback: Callable):
	var body = {
		"name": username,
		"password": password.sha256_text()
	}
	
	return make_request(URLS.register, ["Content-Type: application/json"], HTTPClient.METHOD_POST, body, callback)

static func make_auth(username: String, password: String, callback: Callable):
	var body = {
		"name": username,
		"password": password.sha256_text()
	}
	
	return make_request(URLS.auth, ["Content-Type: application/json"], HTTPClient.METHOD_POST, body, callback)
	
static func request_user(token: String, callback: Callable):
	var auth = "authorization: Bearer %s" % token 
	print(auth)
	
	return make_request(URLS.me, [auth], HTTPClient.METHOD_GET, {}, callback)

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	var json := JSON.new()
	json.parse(body.get_string_from_utf8())
	emit_signal("data_recieved",result,response_code,headers,json.get_data())
	self.queue_free()
