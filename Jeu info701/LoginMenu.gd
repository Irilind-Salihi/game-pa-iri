extends Control

var username
var password
var path = "res://cache.json"
var test = {
	"test" : "sadasdasd"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass



func _on_loginButton_pressed():
	var headers = ["Content-Type: application/json"]
	var body = {username = username,password = "123456"}
	body = JSON.print(body)
	$loginContainer/loginButton/loginRequest.request("http://127.0.0.1:1234/user/login",headers, false, HTTPClient.METHOD_POST, body)



func _on_usernameInput_text_changed(userText):
	username = userText


func _on_passwordInput_text_entered(passwordText):
	password = passwordText

func savefile (json):
	var file = File.new()
	file.open(path,File.WRITE)
	#file.store_string(json)
	
func _on_loginRequest_request_completed(result, response_code, headers, body):

	var json = JSON.parse(body.get_string_from_utf8())
	savefile(body)
	var dict = json.result
	print(dict.get("access_token"))

