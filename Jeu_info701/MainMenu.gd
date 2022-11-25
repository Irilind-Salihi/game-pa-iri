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
	loadAccess()

	var headers = ["Content-Type: application/json","Authorization: Bearer "+token]
	var body = {username = "admin"}
	body = JSON.print(body)

	$VBoxContainer/checkLogin.request("http://127.0.0.1:1234/user/check",headers, false, HTTPClient.METHOD_POST, body)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Start_pressed():
	print("test") # Replace with function body.
	


func _on_checkLogin_request_completed(result, response_code, headers, body):
	var dir = Directory.new()
	var json = JSON.parse(body.get_string_from_utf8())
	var dict = json.result
	print(dict)
	if dict.get("success"):
		get_node("CheckButton").pressed = true
	else:
		get_node("CheckButton").pressed = false
		print("ttest")
		#dir.remove("res://accesstoken.json")
		

		


func _on_loginButton_pressed():
	get_tree().change_scene("res://LoginMenu.tscn")
