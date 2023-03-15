extends HTTPRequest



#func _ready():
#	request_completed.connect(_on_request_completed)
#	request("https://alekyo4-congenial-space-adventure-qxwrp55gj7jh494-8081.preview.app.github.dev/?port=4545")
#
#	var link: String
#	var headers: PackedStringArray
#	var body: String
#
#	var error = request(link, headers, HTTPClient.METHOD_POST, body)
#
#	if error != OK:
#		push_error("An error occurred in the HTTP request.")





func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	var json := JSON.new()
	json.parse(body.get_string_from_utf8())
	print(json.get_data())
