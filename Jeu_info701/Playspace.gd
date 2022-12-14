extends Node2D

var CardSize = Vector2(125,175)
const CardBase = preload("res://Cards/CardBase.tscn")
const PlayerHand = preload("res://Cards/Player_Hand.gd")
const CardSlot = preload("res://Cards/CardSlot.tscn")
var CardSelected = []
var currentDeck = "Ressource"
var nouveauDeck = ""
onready var DeckSize = PlayerHand.CardList[currentDeck].size()
var CardOffset = Vector2()
onready var CentreCardOval = get_viewport().size * Vector2(0.5, 1.25)
onready var Hor_rad = get_viewport().size.x*0.45
onready var Ver_rad = get_viewport().size.y*0.4
var angle = 0
var Card_Numb = 0
var NumberCardsHand = -1
var NumberCardsInPlay = 0
var CardSpread = 0.25
var OvalAngleVector = Vector2()
var newTurn = true

enum{
	InHand
	InPlay
	InMouse
	Selected
	MoveDrawnCardToHand
	ReOrganiseHand
	MoveDrawnCardToDiscard
	MoveDrawnCardToDeck
}

# Called when the node enters the scene tree for the first time.
var CardSlotEmpty = []
func _enter_tree():
	CardSize = (get_viewport().size * (Vector2(1.2,0.9))) * 0.18
	
func _ready():
	randomize()
	var NewSlot = CardSlot.instance()
	NewSlot.rect_size = CardSize
	NewSlot.rect_position = get_viewport().size * 0.5 - CardSize/2
	$CardSlots.add_child(NewSlot)
	CardSlotEmpty.append(true)
	$Background.position = Vector2(0,0)
	$Background.scale = get_viewport().size/$Background.texture.get_size()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
onready var DeckPosition = $Deck/DeckDraw.position
onready var DiscardPosition = $Discard.position

func drawAllCard():
#	DeckSize = PlayerHand.CardList[currentDeck].size()
	if newTurn:
		var listToDraw = ["Ressource","Ressource","Batiment","Batiment", "Unite", "Unite"]
		for deckToDraw in listToDraw:
			DeckSize = drawcard(deckToDraw)
			var t = Timer.new()
			t.set_wait_time(0.4)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			t.queue_free()
		newTurn = false
	else:
		print("Termine le tour")
			
	
#	for CardToConnect in $Cards.get_children():
#		for CardNeedToConnect in $Cards.get_children():
#			if CardToConnect != CardNeedToConnect:
##				CardNeedToConnect.connect("selected")
#				pass

func drawcard(deckToDraw):
	DeckSize = PlayerHand.CardList[deckToDraw].size()
	angle = PI/2 + CardSpread*(float(NumberCardsHand)/2 - NumberCardsHand)
	var new_card = CardBase.instance()
	CardSelected = randi() % DeckSize
	new_card.Cardname = PlayerHand.CardList[deckToDraw][CardSelected]
	new_card.rect_position = DeckPosition - CardSize/2
	new_card.DiscardPile = DiscardPosition - CardSize/2
	new_card.DeckPile = DeckPosition 
	new_card.rect_scale *= CardSize/new_card.rect_size
	new_card.state = MoveDrawnCardToHand
	new_card.connect("selected", self , "cardSelected")
	Card_Numb = 0
	
	$Cards.add_child(new_card)
	PlayerHand.CardList[deckToDraw].erase(PlayerHand.CardList[deckToDraw][CardSelected])
	angle += 0.25
	DeckSize -= 1
	NumberCardsHand += 1
	OrganiseHand()
	return DeckSize

var alreadyGrab = false
var cardAlreadyGrab = null

func drag(Card):
	if Card.CARD_SELECT && Card.state != InPlay:
		Card.oldstate = Card.state 
		Card.state = InMouse
		Card.setup = true
		Card.CARD_SELECT = false
		
	# On regarde à quel cardSlot on a cliqué
	for i in range($CardSlots.get_child_count()):
		var CardSlotPos = $CardSlots.get_child(i).rect_position
		var CardSlotSize = $CardSlots.get_child(i).rect_size
		var mousepos = get_global_mouse_position()
#					print(mousepos)
		# Si on est à la position d'une cardSlot
		if Card.CARD_SELECT && mousepos.x > CardSlotPos.x && mousepos.x < CardSlotPos.x + CardSlotSize.x && mousepos.y > CardSlotPos.y && mousepos.y < CardSlotPos.y + CardSlotSize.y:
			var CardInPlay = $'../../CardInPlay'
			# On prend la dernière carte (celle du dessus)
			if CardInPlay.get_child_count() > 0 :
				var LastCard = CardInPlay.get_child(CardInPlay.get_child_count()-1)
				LastCard.oldstate = Card.state 
				LastCard.state = InMouse
				LastCard.setup = true
				LastCard.CARD_SELECT = false
				break

func drop(Card):
	if Card.CARD_SELECT == false:
		# Si on était une carte focus, on regarde si on va être poser sur un cardSlot
		if Card.oldstate == Selected :
			for i in range($CardSlots.get_child_count()):
				if CardSlotEmpty[i]:
					var CardSlotPos = $CardSlots.get_child(i).rect_position
					var CardSlotSize = $CardSlots.get_child(i).rect_size
					var mousepos = get_global_mouse_position()
					if mousepos.x > CardSlotPos.x && mousepos.x < CardSlotPos.x + CardSlotSize.x && mousepos.y > CardSlotPos.y && mousepos.y < CardSlotPos.y + CardSlotSize.y:
						Card.setup = true
						Card.MovingtoInPlay = true
						Card.targetpos = CardSlotPos 
						Card.targetscale = CardSlotSize/Card.rect_size
						Card.state = InPlay
						Card.CARD_SELECT = true
						break
			# Si on a pas été posé on retourne à sa place
			if Card.state != InPlay:
				Card.setup = true
				Card.targetpos = Card.Cardpos
				Card.state = ReOrganiseHand
				Card.CARD_SELECT = true
		# Si on était pas une carte focus, on retourne dans le deck
		else:
			Card.setup = true
			Card.state = ReOrganiseHand
			Card.CARD_SELECT = true

func cardSelected(Card, grabbed):
	if grabbed:
		print("Grab")
		if !alreadyGrab:
			alreadyGrab = true
			cardAlreadyGrab = Card
			drag(Card)
		else:
			if Card.Card_Numb > cardAlreadyGrab.Card_Numb:
				drop(cardAlreadyGrab)
				drag(Card)
				cardAlreadyGrab = Card
	else:
		print("Release")
		drop(Card)
		alreadyGrab = false
		cardAlreadyGrab = null

func ReParentCardInPlay(CardNo):
	print("Reparent in play")
	NumberCardsHand -= 1
	NumberCardsInPlay += 1
	Card_Numb = 0
	var Card = $Cards.get_child(CardNo)
	$Cards.remove_child(Card)
	$CardInPlay.add_child(Card)
#	print("Ajout")
#	print($Cards.get_children())
#	print($CardInPlay.get_children())
	OrganiseHand()
	Rule()
	print(NumberCardsInPlay)

func ReParentCardInHand():
	print("Reparent in hand")
	print(NumberCardsInPlay)
	NumberCardsInPlay -= 1
	var Card = $CardInPlay.get_child(NumberCardsInPlay)
	print("Card deck : ",Card.CardInfo[0])
	print("Current deck : ",currentDeck)
	if (Card.CardInfo[0] == currentDeck):
		NumberCardsHand += 1
		Card_Numb = 0
		Card.setup = true
		Card.state = MoveDrawnCardToHand
		$CardInPlay.remove_child(Card)
		$Cards.add_child(Card)
		OrganiseHand()
	else:
		PlayerHand.CardList[Card.CardInfo[0]].append(Card.Cardname)
		Card.setup = true
		Card.MovingtoDeck = true
		Card.state = MoveDrawnCardToDeck
		

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

func Rule():
	var allCard = $CardInPlay.get_children();
	for Card in allCard:
		match currentDeck:
			"Menu":
				match Card.Cardname:
					"Batiment":
						changementMenuToSousMenu("Batiment")
						break
					"Evenement":
						changementMenuToSousMenu("Evenement")
						break
					"Ressource":
						changementMenuToSousMenu("Ressource")
						break
					"Unite":
						changementMenuToSousMenu("Unite")
						break
			"Batiment":
				match Card.Cardname:
					"Retour":
						changementMenuToSousMenu("Menu")
						break
					_:
						noRule()
			"Unite":
				match Card.Cardname:
					"Retour":
						changementMenuToSousMenu("Menu")
						break
					_:
						noRule()
			"Evenement":
				match Card.Cardname:
					"Retour":
						changementMenuToSousMenu("Menu")
						break
					_:
						noRule()
			"Ressource":
				match Card.Cardname:
					"Retour":
						changementMenuToSousMenu("Menu")
						break
					_:
						noRule()
			_:
				noRule()
						
func changementMenuToSousMenu(newDeck):
	print("Change de Deck")
	var GetTimeCard = CardBase.instance()
	var WAITINGTIME = GetTimeCard.DRAWTIME * (NumberCardsHand+1)*2
	print(WAITINGTIME)
	
	var list = $Cards.get_children()
	for DiscCard in $Cards.get_children():
		$Cards.remove_child(DiscCard)
		$CardsInDiscard.add_child(DiscCard)
	
	for e in range(list.size()):
		var CardInHand = list.pop_front()
		PlayerHand.CardList[currentDeck].append(CardInHand.Cardname)
		CardInHand.deffausseCard()
		var t = Timer.new()
		t.set_wait_time(GetTimeCard.DRAWTIME/(NumberCardsHand*1.0))
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
	
	var Card = $CardInPlay.get_children().back()
	$CardInPlay.remove_child(Card)
	$CardsInDiscard.add_child(Card)
	PlayerHand.CardList[currentDeck].append(Card.Cardname)
	NumberCardsInPlay -= 1
	NumberCardsHand += 1
	Card.deffausseCard()

		
#	print($CardsInDiscard.get_children())
	
	nouveauDeck = newDeck
	print("Lancement du minuteur.")
	
	var t = Timer.new()
	t.set_wait_time(GetTimeCard.DRAWTIME)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	GetTimeCard.queue_free()
	
	Card_Numb = 0
	NumberCardsHand = -1
	DeckSize = 0
	currentDeck = nouveauDeck
	drawAllCard()

func noRule():
	print("No Rule")
	pass
