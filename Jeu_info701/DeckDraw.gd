extends TextureButton

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Decksize = INF

# Called when the node enters the scene tree for the first time.
func _ready():
	var TailleCard = $'../../'.CardSize/rect_size
	rect_position.x = (get_viewport().size.x * 0.70) - ((TailleCard.x)/2.0)
	rect_position.y = (get_viewport().size.y * 0.05) - ((TailleCard.y)/2.0)
	rect_scale *= TailleCard

func updateAffichage(decksize):
	disabled = decksize == 0

func _gui_input(event):
	Decksize = $'../../'.DeckSize
	if Input.is_action_just_released("leftclick") && event.is_action_released("leftclick"):
		if Decksize > 0:
			$'../../'.drawAllCard()
