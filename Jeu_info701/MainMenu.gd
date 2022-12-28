extends Control
var token
var test = "test"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func loadAccess():
	var file = File.new()
	if file.file_exists("res://accesstoken.json"):
		print("y a r")
		file.open("res://accesstoken.json", File.READ)
		var content = file.get_as_text()
		token = parse_json(content)
		file.close()
		return true
	else:
		print(" on a un truc roger")
		return false
	


# Called when the node enters the scene tree for the first time.
func _ready():
	#force start the music at the app launch
	$AudioStreamPlayer.play()
	
	#Set the three button size
	$startTouchScreen.position.x =get_viewport().size.x * 0.13
	$startTouchScreen.position.y =get_viewport().size.y * 0.25
	$startTouchScreen.scale = Vector2(500,100) / $startTouchScreen.normal.get_size()
	
	$statsTouchScreen.position.x =get_viewport().size.x * 0.13
	$statsTouchScreen.position.y =get_viewport().size.y * 0.50
	$statsTouchScreen.scale = Vector2(500,100) / $statsTouchScreen.normal.get_size()
	
	$loginTouchScreen.position.x =get_viewport().size.x * 0.13
	$loginTouchScreen.position.y =get_viewport().size.y * 0.75
	$loginTouchScreen.scale = Vector2(500,100) / $loginTouchScreen.normal.get_size()
	
	#If my token exist on my app, then check if the token is valid
	if(loadAccess()):
		var headers = ["Content-Type: application/json","Authorization: Bearer "+token["access_token"]]
		var body = {}
		body = JSON.print(body)
		$checkLogin.request("http://51.68.226.111:1234/user/check",headers, false, HTTPClient.METHOD_POST, body)
		
	
	

#Function to change to playspace scene
func _on_startTouchScreen_pressed():
	get_tree().change_scene("res://Playspace.tscn")


#Function to change to statsMenu scene
func _on_statsTouchScreen_pressed():
	get_tree().change_scene("res://statsMenu.tscn")

#Function to change to karmaMenu scene
func _on_loginTouchScreen_pressed():
	get_tree().change_scene("res://karmaMenu.tscn")


#Function to check if the registered bearer token is valid
func _on_checkLogin_request_completed(result, response_code, headers, body):
	var dir = Directory.new()
	var json = JSON.parse(body.get_string_from_utf8())
	var dict = json.result
	print(dict)
	if dict.get("success"):
		get_node("CheckButton").pressed = true
	else:
		get_node("CheckButton").pressed = false
		dir.remove("res://accesstoken.json")


func _on_back_pressed():
	get_tree().change_scene("res://my_awesome_scene.tscn")
