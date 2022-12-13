extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func loadAccess():
	var file = File.new()
	if file.file_exists("res://accesstoken.json"):
		print("y a r")
	else:
		print(" on a un truc roger")
	#file.open("res://accesstoken.json", File.READ)
	#var content = file.get_as_text()
	file.close()


	return "test"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$startTouchScreen.position.x =get_viewport().size.x * 0.18
	$startTouchScreen.position.y =get_viewport().size.y * 0.25
	$startTouchScreen.scale = Vector2(500,100) / $startTouchScreen.normal.get_size()
	
	$statsTouchScreen.position.x =get_viewport().size.x * 0.18
	$statsTouchScreen.position.y =get_viewport().size.y * 0.50
	$statsTouchScreen.scale = Vector2(500,100) / $statsTouchScreen.normal.get_size()
	
	$loginTouchScreen.position.x =get_viewport().size.x * 0.18
	$loginTouchScreen.position.y =get_viewport().size.y * 0.75
	$loginTouchScreen.scale = Vector2(500,100) / $loginTouchScreen.normal.get_size()
	
	
	
	loadAccess()

	var headers = ["Content-Type: application/json","Authorization: Bearer "+"token"]
	var body = {username = "admin"}
	body = JSON.print(body)

	$checkLogin.request("http://127.0.0.1:1234/user/check",headers, false, HTTPClient.METHOD_POST, body)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_startTouchScreen_pressed():
	get_tree().change_scene("res://Playspace.tscn")



func _on_statsTouchScreen_pressed():
	pass # Replace with function body.


func _on_loginTouchScreen_pressed():
	get_tree().change_scene("res://LoginMenu.tscn")

