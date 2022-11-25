extends MarginContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.scale *= rect_size/$Sprite.texture.get_size()
