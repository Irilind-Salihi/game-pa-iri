extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const CardSize = Vector2(125,175)
const CardBase = preload("res://CardBase.tscn")
const PlayerHand = preload("res://Assets/Player_Hand/Player_Hand.gd")
var CardSelected = []
onready var DeckSize = PlayerHand.CardList.size()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _init(event):
	if Input.is_action_jsut_released("leftclick"):
		# Draw Card
		var new_card = CardBase.instance()
		CardSelected = randi() % DeckSize
		new_card.Cardname = PlayerHand.CardList[CardSelected]
		new_card.rect_position = get_global_mouse_position()
		new_card.rect_scale *= CardSize/new_card.rect_size
		$Cards.add_child(new_card)
		PlayerHand.CardList.erase(PlayerHand.card)
		DeckSize -= 1
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
