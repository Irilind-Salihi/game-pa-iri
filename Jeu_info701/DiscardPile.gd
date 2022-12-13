extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	var TailleCard = $'../../'.CardSize/rect_size
	rect_position.x = (get_viewport().size.x * 0.70) - ((TailleCard.x)/2.0)
	rect_position.y = (get_viewport().size.y * 0.80) - ((TailleCard.y)/2.0)
	rect_scale *= TailleCard
	disabled = true
