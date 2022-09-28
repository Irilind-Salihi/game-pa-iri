extends MarginContainer


onready var CardsData = preload("res://Assets/Card/CardsData.gd")
var CardName = 'Morbier'
onready	var CardInfo = CardsData.DATA2[CardsData.get("Fourme")]
onready var CardImg =  str("res://Assets/Card/CardImage/",CardName,".png/")

# Called when the node enters the scene tree for the first time.
func _ready():
	print(CardInfo)
	var CardSize = rect_size
	$Border.scale *= CardSize/$Border.texture.get_size()
	$Card.texture = load(CardImg)
	$Card.scale *= CardSize/$Card.texture.get_size()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass"res://Assets/Card/CardBorder/background.png"
