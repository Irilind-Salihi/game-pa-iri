extends TouchScreenButton

var Decksize = INF

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true
	print($'../../')
	var TailleCard = $'../../'.CardSize
	
	position.x = (get_viewport().size.x * 0.85) - ((TailleCard.x)/2.0)
	position.y = (get_viewport().size.y * 0.10) - ((TailleCard.y)/2.0)
	
	scale = (TailleCard / normal.get_size())

func _on_DeckDraw_pressed():
	print("Click Deck !")
	Decksize = $'../../'.DeckSize
	if Decksize > 0:
		$'../../'.drawAllCard()

