extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const CardSize = Vector2(125,175)
const CardBase = preload("res://Cards/CardBase.tscn")
const PlayerHand = preload("res://Cards/Player_Hand.gd")
const CardSlot = preload("res://Cards/CardSlot.tscn")
var CardSelected = []
onready var DeckSize = PlayerHand.CardList.size()
var CardOffset = Vector2()
onready var CentreCardOval = get_viewport().size * Vector2(0.5, 1.25)
onready var Hor_rad = get_viewport().size.x*0.45
onready var Ver_rad = get_viewport().size.y*0.4
var angle = 0
var Card_Numb = 0
var NumberCardsHand = -1
var CardSpread = 0.25
var OvalAngleVector = Vector2()
enum{
	InHand
	InPlay
	InMouse
	FocusInHand
	MoveDrawnCardToHand
	ReOrganiseHand
	MoveDrawnCardToDiscard
}
# Called when the node enters the scene tree for the first time.
var CardSlotEmpty = []
func _ready():
	randomize()
	var NewSlot = CardSlot.instance()
	NewSlot.rect_position = get_viewport().size * 0.4
	NewSlot.rect_size = CardSize
	$CardSlots.add_child(NewSlot)
	CardSlotEmpty.append(true)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
onready var DeckPosition = $Deck.position
onready var DiscardPosition = $Discard.position

func drawcard():
	angle = PI/2 + CardSpread*(float(NumberCardsHand)/2 - NumberCardsHand)
	var new_card = CardBase.instance()
	CardSelected = randi() % DeckSize
	new_card.Cardname = PlayerHand.CardList[CardSelected]
	new_card.rect_position = DeckPosition - CardSize/2
	new_card.DiscardPile = DiscardPosition - CardSize/2
	new_card.rect_scale *= CardSize/new_card.rect_size
	new_card.state = MoveDrawnCardToHand
	Card_Numb = 0
	
	$Cards.add_child(new_card)
	PlayerHand.CardList.erase(PlayerHand.CardList[CardSelected])
	angle += 0.25
	DeckSize -= 1
	NumberCardsHand += 1
	OrganiseHand()
	return DeckSize

func ReParentCardInPlay(CardNo):
	NumberCardsHand -= 1
	Card_Numb = 0
	var Card = $Cards.get_child(CardNo)
	$Cards.remove_child(Card)
	$CardInPlay.add_child(Card)
	OrganiseHand()

func ReParentCardInHand(CardNo):
	NumberCardsHand += 1
	Card_Numb = 0
	var Card = $CardInPlay.get_child(CardNo)
	$CardInPlay.remove_child(Card)
	$Cards.add_child(Card)
	OrganiseHand()

func OrganiseHand():
	for Card in $Cards.get_children(): # reorganise hand
		angle = PI/2 + CardSpread*(float(NumberCardsHand)/2 - Card_Numb)
		OvalAngleVector = Vector2(Hor_rad * cos(angle), - Ver_rad * sin(angle))
		
		Card.targetpos = CentreCardOval + OvalAngleVector - CardSize
		Card.Cardpos = Card.targetpos # card default pos
		Card.startrot = Card.rect_rotation
		Card.targetrot = (90 - rad2deg(angle))/4
		Card.Card_Numb = Card_Numb
		Card_Numb += 1
		if Card.state == InHand:
			Card.setup = true
			Card.state = ReOrganiseHand
		elif Card.state == MoveDrawnCardToHand:
			Card.startpos = Card.targetpos - ((Card.targetpos - Card.rect_position)/(1-Card.t))
