extends HTTPRequest


func _ready():
	request_completed.connect(_on_request_completed)
	
	var error = request("https://httpbin.org/get")
	if error != OK:
		push_error("An error occurred in the HTTP request.")




func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	var json := JSON.new()
	json.parse(body.get_string_from_utf8())
	print(json.get_data())
