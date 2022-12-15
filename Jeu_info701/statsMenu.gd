extends Control




# Called when the node enters the scene tree for the first time.
func _ready():

	var viewportWidth = get_viewport().size.x
	var viewportHeight = get_viewport().size.y
	var scale = viewportWidth / $statsBackground.texture.get_size().x
	$statsBackground.set_scale(Vector2(scale, scale))
	
	$searchHboxContainer.anchor_left = 0.35
	$searchHboxContainer.anchor_top = 0.05
	
	$searchHboxContainer/submit.text = "chercher"
	
	$statsVboxContainer.anchor_left = 0.35
	$statsVboxContainer.anchor_top = 0.35
	
	settext()
	

func settext():
	$statsVboxContainer/usernameLabel.text = "Joueur : "
	$statsVboxContainer/nbTurnLabel.text= "nombre de tour : 0"
	$statsVboxContainer/sawmillLabel.text= "Niveau Scierie : 0"
	$statsVboxContainer/mineLabel.text= "Niveau Mine : 0"
	$statsVboxContainer/barrackLabel.text= "Niveau Caserne : 0"
	$statsVboxContainer/bankLabel.text= "Niveau bankLabel : 0"
	$statsVboxContainer/karmaLabel.text= "Karma : 0"

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
