extends Control

var username
var password
var path = "res://accesstoken.json"
var test = {
	"test" : "sadasdasd"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	



func _on_usernameInput_text_changed(userText):
	username = userText


func _on_passwordInput_text_entered(passwordText):
	password = passwordText

func savefile (json):
	var file = File.new()
	file.open(path,File.WRITE)
	file.store_string(to_json(json))
	
func _on_loginRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var dict = json.result
	var storedJson ={"access_token": dict.get("access_token"),"username": dict.get("username")}

	if(dict.get("success")):
		print("ça existe")
	else:
		print("ça existe pas")

	#savefile(storedJson)
	
	print(dict.get("access_token"))
	#$Label.text = dict.get("access_token")
	#get_tree().change_scene("res://MainMenu.tscn")


func _on_connexionTouchScreen_pressed():
	var headers = ["Content-Type: application/json"]
	var body = {username = $usernameInput.text,password = $passwordInput.text}
	body = JSON.print(body)
	$connexionTouchScreen/loginRequest.request("http://51.68.226.111:1234/user/login",headers, false, HTTPClient.METHOD_POST, body)
