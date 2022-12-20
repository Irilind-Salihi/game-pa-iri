extends Control
var dynamic_font = DynamicFont.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	dynamic_font.font_data = load("res://Assets/font/Panton-Trial-Bold.ttf")
	dynamic_font.size = 100
	
	
	$goodPeopleRequest.request("http://51.68.226.111:1234/gameRecord/goodKarma")
	$badPeopleRequest.request("http://51.68.226.111:1234/gameRecord/badKarma")

	
func _on_retour_pressed():
	print("test")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_goodPeopleRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var dict = json.result
	
	var goodVbox = VBoxContainer.new()
	
	var titre = Label.new()
	titre.text = "Le Best :"
	titre.add_font_override("font", dynamic_font)
	titre.add_color_override("font_color", Color.olivedrab)
	
	var label = Label.new()
	label.text = dict[0].username
	label.add_font_override("font", dynamic_font)
	label.add_color_override("font_color", Color.olivedrab)


	
	goodVbox.add_child(titre)
	goodVbox.add_child(label)
	
	goodVbox.anchor_left = 0.15
	goodVbox.anchor_top = 0.40
	
	add_child(goodVbox)
	

func _on_badPeopleRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var dict = json.result
	
	var badVbox = VBoxContainer.new()
	
	var titre = Label.new()
	titre.text = "Le pire :"
	titre.add_font_override("font", dynamic_font)
	titre.add_color_override("font_color", Color.red)
	
	var label = Label.new()
	label.text = dict[0].username
	label.add_font_override("font", dynamic_font)
	label.add_color_override("font_color", Color.red)

	badVbox.add_child(titre)
	badVbox.add_child(label)
	
	badVbox.anchor_left = 0.55
	badVbox.anchor_top = 0.40
	
	add_child(badVbox)




func _on_back_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
