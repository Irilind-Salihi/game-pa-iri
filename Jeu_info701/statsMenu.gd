extends Control
var dynamic_font = DynamicFont.new()



# Called when the node enters the scene tree for the first time.
func _ready():
	dynamic_font.font_data = load("res://Assets/font/Panton-Trial-Bold.ttf")
	dynamic_font.size = 100
	
	
	
	$searchHboxContainer/submit.text = "chercher"
	
	$statsVboxContainer.anchor_left = 0.25
	$statsVboxContainer.anchor_top = 0.35
	
	settext()
	
	
	
	
func settext():
	$statsVboxContainer/usernameLabel.text = "Joueur : "
	$statsVboxContainer/usernameLabel.add_font_override("font", dynamic_font)
	$statsVboxContainer/usernameLabel.add_color_override("font_color", Color.white)
	$statsVboxContainer/nbTurnLabel.text= "nombre de tour : 0"
	$statsVboxContainer/nbTurnLabel.add_font_override("font", dynamic_font)
	$statsVboxContainer/nbTurnLabel.add_color_override("font_color", Color.white)
	$statsVboxContainer/sawmillLabel.text= "Niveau Scierie : 0"
	$statsVboxContainer/sawmillLabel.add_font_override("font", dynamic_font)
	$statsVboxContainer/sawmillLabel.add_color_override("font_color", Color.white)
	$statsVboxContainer/mineLabel.text= "Niveau Mine : 0"
	$statsVboxContainer/mineLabel.add_font_override("font", dynamic_font)
	$statsVboxContainer/mineLabel.add_color_override("font_color", Color.white)
	$statsVboxContainer/barrackLabel.text= "Niveau Caserne : 0"
	$statsVboxContainer/barrackLabel.add_font_override("font", dynamic_font)
	$statsVboxContainer/barrackLabel.add_color_override("font_color", Color.white)
	$statsVboxContainer/bankLabel.text= "Niveau bankLabel : 0"
	$statsVboxContainer/bankLabel.add_font_override("font", dynamic_font)
	$statsVboxContainer/bankLabel.add_color_override("font_color", Color.white)
	$statsVboxContainer/karmaLabel.text= "Karma : 0"
	$statsVboxContainer/karmaLabel.add_font_override("font", dynamic_font)
	$statsVboxContainer/karmaLabel.add_color_override("font_color", Color.white)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_searchStats_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var dict = json.result
	if(dict != null):
		$statsVboxContainer/usernameLabel.text = "Joueur : "+dict.get("username")
		$statsVboxContainer/nbTurnLabel.text= "nombre de tour : "+String(dict.get("nbTurn"))
		$statsVboxContainer/sawmillLabel.text= "Niveau Scierie : "+String(dict.get("sawmill"))
		$statsVboxContainer/mineLabel.text= "Niveau Mine : "+String(+dict.get("mine"))
		$statsVboxContainer/barrackLabel.text= "Niveau Caserne : "+String(dict.get("barracks"))
		$statsVboxContainer/bankLabel.text= "Niveau bankLabel : "+String(dict.get("bank"))
		$statsVboxContainer/karmaLabel.text= "Karma : "+ String(dict.get("karma"))
		



func _on_submit_pressed():
	var headers = ["Content-Type: application/json"]
	var body = {
  "username":$searchHboxContainer/search.text
	}
	print(body)
	$searchStatsRequest.request("http://51.68.226.111:1234/gameRecord/search",headers, false, HTTPClient.METHOD_POST, to_json(body))


func _on_back_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
