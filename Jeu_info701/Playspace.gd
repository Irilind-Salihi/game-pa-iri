# Playspace.gd
# Script pour la scène Playspace.tscn (scène principale du jeu de carte)

# Type de noeud : Node2D
extends Node2D

# Variables pour la scène
var nbTurn = 0
var Karma = 0 

# Pré-chargement des fichiers nécessaire de la scène dans des variables
const CardBase = preload("res://Cards/CardBase.tscn")
const PlayerHand = preload("res://Cards/Player_Hand.gd")
const CardSlot = preload("res://Cards/CardSlot.tscn")
onready var CardDatabase = get_node("/root/CardsDatabase")

# Variable de la position de node de la scène
onready var DeckPosition = $Deck/DeckDraw.position
onready var DiscardPosition = $Discard/DiscardPile.rect_position

# Variables utilisés pour la pioche de carte
var CardSelected = []
var newTurn = true
var NumberCardsHand = -1
var NumberCardsInPlay = 0
var currentDeck = "Ressource"
var nouveauDeck = ""

# Attribut des cartes ou du deck
var CardSize = Vector2(125,175)
var Card_Numb = 0
onready var DeckSize = PlayerHand.CardList[currentDeck].size()

# Variable pour l'affichage des cartes de la main (Affiché en suivant la courbe d'un ovale)
onready var CentreCardOval = get_viewport().size * Vector2(0.5, 1.0) + CardSize/2
onready var Hor_rad = get_viewport().size.x*0.5
onready var Ver_rad = get_viewport().size.y*0.4
var angle = 0
var CardSpread = 0.30
var OvalAngleVector = Vector2()

# Variable des endroits déposables de la carte
var CardSlotEmpty = []

# Variable pour l'animation de la carte
var inAnimation = false

# Variable pour le drag and drop
var alreadyGrab = false
var cardAlreadyGrab = null

# Variable des différents états de la carte
enum{
	InHand
	InPlay
	InMouse
	Selected
	MoveDrawnCardToHand
	ReOrganiseHand
	MoveDrawnCardToDiscard
	MoveDrawnCardToDeck
	Discard
}

# Fonction d'initialisation appelée au démarrage du noeud
func _enter_tree():
	CardSize = (get_viewport().size * (Vector2(1.2,0.9))) * 0.18

# Fonction appelée lorsque le noeud à fini de s'initialiser
func _ready():
	# Change la seed de la génération aléatoire avec un nombre basé sur le temps
	randomize()

	# Création de l'emplacement pour poser la carte
	# Ainsi que le réglage de sa dimension pour correspondre au carte, son placement sur la scène
	# Et son ajout au noeud (le noeud = la liste des emplacements de carte).
	var NewSlot = CardSlot.instance()
	NewSlot.rect_size = CardSize
	NewSlot.rect_position = get_viewport().size * Vector2(0.5,0.4) - CardSize/2
	$CardSlots.add_child(NewSlot)

	# On ajoute dans la liste 
	CardSlotEmpty.append(true)

	# On ajoute le background de la scène et on le redimensionne pour qu'il prenne toute la scène
	$Background.position = Vector2(0,0)
	$Background.scale = get_viewport().size/$Background.texture.get_size()

	# On positionne l'élément d'affichage du Karma sur la scène
	$Karma.position = get_viewport().size * Vector2(0.05,0.05)
	updateKarma(0)

	# On appelle la fonction pour piocher les cartes de la main
	drawAllCard()

# Fonction qui met à jour la variable de karma ainsi que l'affichage
func updateKarma(modif):
	Karma += modif
	$Karma/Align/NbKarma.text = str(Karma)

# Fonction pour piocher toutes les cartes du deck si le tour est déjà lancer déchausse toutes les cartes puis en repioche de nouvelles
func drawAllCard():
	if !inAnimation:
		if newTurn:
			inAnimation = true
			var listToDraw = [["Ressource",1],["Ressource",1],["Ressource",1],["Batiment",1],["Batiment",1],["Unite",1]]
			var selectedList = []
			for deckToDraw in listToDraw:
				selectedList.append_array(drawcard(deckToDraw[0],deckToDraw[1]))
				var t = Timer.new()
				t.set_wait_time(0.4)
				t.set_one_shot(true)
				self.add_child(t)
				t.start()
				yield(t, "timeout")
				t.queue_free()
			for cardPicked in selectedList:
				PlayerHand.CardList[cardPicked[0]].append(cardPicked[1])
			newTurn = false
			inAnimation = false
		else:
			print("Termine le tour")
			inAnimation = true
			
			for i in range($CardInPlay.get_children().size()):
				var allCardInPlay = $CardInPlay.get_children().back()
				allCardInPlay.deffausseCard()
				$CardInPlay.remove_child(allCardInPlay)
				$CardsInDiscard.add_child(allCardInPlay)
				var t = Timer.new()
				t.set_wait_time(0.4)
				t.set_one_shot(true)
				self.add_child(t)
				t.start()
				yield(t, "timeout")
				t.queue_free()
			for i in range($Cards.get_children().size()):
				var allCardInHand = $Cards.get_children().back()
				allCardInHand.deffausseCard()
				$Cards.remove_child(allCardInHand)
				$CardsInDiscard.add_child(allCardInHand)
				var t = Timer.new()
				t.set_wait_time(0.4)
				t.set_one_shot(true)
				self.add_child(t)
				t.start()
				yield(t, "timeout")
				t.queue_free()
				
			NumberCardsHand = -1
			NumberCardsInPlay = 0
			inAnimation = false
			nbTurn += 1
			newTurn = true
			drawAllCard()
			
# Fonction pour piocher une carte
func drawcard(deckToDraw,nb):
	var selectedList = []
	for i in range(nb):
		DeckSize = PlayerHand.CardList[deckToDraw].size()
		angle = PI/2 + CardSpread*(float(NumberCardsHand)/2 - NumberCardsHand)
		var new_card = CardBase.instance()
		CardSelected = randi() % DeckSize
		new_card.Cardname = PlayerHand.CardList[deckToDraw][CardSelected]
		selectedList.append([deckToDraw,new_card.Cardname])
		new_card.rect_position = DeckPosition
		new_card.DiscardPile = DiscardPosition
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
		
	return selectedList

# Fonction pour prendre une carte
func drag(Card):
	if Card.CARD_SELECT && Card.state != InPlay:
		print("Dans la main")
		Card.oldstate = Card.state 
		Card.state = InMouse
		Card.setup = true
		Card.CARD_SELECT = false
		
	# On regarde à quel cardSlot on a cliqué
	for i in range($CardSlots.get_child_count()):
		var CardSlotPos = $CardSlots.get_child(i).rect_position
		var CardSlotSize = $CardSlots.get_child(i).rect_size
		var mousepos = get_global_mouse_position()
		# Si on est à la position d'une cardSlot
		if Card.CARD_SELECT && mousepos.x > CardSlotPos.x && mousepos.x < CardSlotPos.x + CardSlotSize.x && mousepos.y > CardSlotPos.y && mousepos.y < CardSlotPos.y + CardSlotSize.y:			
			# On prend la dernière carte (celle du dessus)
			print("Take the card in play")
			if $CardInPlay.get_child_count() > 0 :
				var LastCard = $CardInPlay.get_child($CardInPlay.get_child_count()-1)
				LastCard.oldstate = Card.state 
				LastCard.state = InMouse
				LastCard.setup = true
				LastCard.CARD_SELECT = false
				break

# Fonction pour lâcher la carte
func drop(Card):
	if Card.CARD_SELECT == false:
		# Si on était une carte focus, on regarde si on va être poser sur un cardSlot
		if Card.oldstate == Selected :
			for i in range($CardSlots.get_child_count()):
				if CardSlotEmpty[i]:
					var CardSlotSize = $CardSlots.get_child(i).rect_size
					var CardSlotPos = $CardSlots.get_child(i).rect_position + CardSlotSize/2
					var mousepos = get_global_mouse_position()
					if mousepos.x > CardSlotPos.x && mousepos.x < CardSlotPos.x + CardSlotSize.x && mousepos.y > CardSlotPos.y && mousepos.y < CardSlotPos.y + CardSlotSize.y:
						Card.setup = true
						Card.MovingtoInPlay = true
						Card.targetpos = CardSlotPos - CardSize/2
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
			ReParentCardInHand()

# Fonction appellé par le signal de la carte quand elle est prise et relacher
func cardSelected(Card, grabbed):
	if grabbed:
		if !alreadyGrab:
			print("Grab")
			alreadyGrab = true
			cardAlreadyGrab = Card
			drag(Card)
		else:
			if Card.state != InPlay && cardAlreadyGrab.state != InPlay:
				if Card.Card_Numb > cardAlreadyGrab.Card_Numb:
					drop(cardAlreadyGrab)
					drag(Card)
					cardAlreadyGrab = Card
	else:
		print("Release")
		drop(Card)
		alreadyGrab = false
		cardAlreadyGrab = null

# Fonction qui prend le numéro de la carte et change le parent :
# InHand (la main) -> InPlay (Dans le slot au milieu de l'écran)
# Fait l'inverse de ReParentInHand
func ReParentCardInPlay(CardNo):
	NumberCardsHand -= 1
	NumberCardsInPlay += 1
	Card_Numb = 0
	var Card = $Cards.get_child(CardNo)
	$Cards.remove_child(Card)
	$CardInPlay.add_child(Card)
	OrganiseHand()
	Rule()

# Fonction qui prend la dernière carte (celle du dessus) et change le parent :
# InPlay (Dans le slot au milieu de l'écran) -> InHand (la main)
# Fait l'inverse de ReParentCardInPlay
func ReParentCardInHand():
	NumberCardsInPlay -= 1
	var Card = $CardInPlay.get_child(NumberCardsInPlay)
	NumberCardsHand += 1
	Card_Numb = 0
	Card.setup = true
	Card.state = MoveDrawnCardToHand
	$CardInPlay.remove_child(Card)
	$Cards.add_child(Card)
	OrganiseHand()

# Fonction qui réorganise et replace correctement toutes les cartes de la main
# Elle gère aussi le positionnement et l'inclinaison (par rapport au ovale)
func OrganiseHand():
	for Card in $Cards.get_children():
		angle = PI/2 + CardSpread*(float(NumberCardsHand)/2 - Card_Numb)
		OvalAngleVector = Vector2(Hor_rad * cos(angle), - Ver_rad * sin(angle))
		
		Card.targetpos = CentreCardOval + OvalAngleVector - CardSize
		Card.Cardpos = Card.targetpos 
		Card.startrot = Card.rect_rotation
		Card.targetrot = (90 - rad2deg(angle))/4
		Card.Card_Numb = Card_Numb
		Card_Numb += 1
		if Card.state == InHand:
			Card.setup = true
			Card.state = ReOrganiseHand
		elif Card.state == MoveDrawnCardToHand:
			Card.startpos = Card.targetpos - ((Card.targetpos - Card.rect_position)/(1-Card.t))

# Fonction appelé à chaque fois que l'on pose une carte dans InPlay
# Elle sert à choisir quelles seront les comportement des chaques cartes :
#  - Lorsqu'elles sont posé
#  - Si elles ont le droit d'être posé
#  - Sur quoi elles sont posé 
#  - Etc ...
func Rule():
	var pos = 0
	var allCard = $CardInPlay.get_children();
	for Card in allCard:
		pos += 1
		match Card.CardInfo[0]:
			"Batiment":
				print(allCard[0].CardInfo[4][allCard[0].CardInfo[5].find(allCard[0].Cardname)])
				if pos == 1 && allCard.size() > 1:
					if allCard[pos].CardInfo[0] == "Ressource":
						var res = checkUpgrade(allCard[pos-1],allCard[pos])
						if res[0]:
							if res[1]:
								levelUp(allCard[pos-1])
							var allCardInPlay = $CardInPlay.get_children().back()
							allCardInPlay.deffausseCard()
							$CardInPlay.remove_child(allCardInPlay)
							$CardsInDiscard.add_child(allCardInPlay)	
							NumberCardsInPlay -=1							
						else:
							ReParentCardInHand()
					else:
						ReParentCardInHand()
			"Unite":
				if pos == 1:
					ReParentCardInHand()
					break
				else:
					pass
			"Ressource":
				if pos == 1:
					ReParentCardInHand()
					break
				else:
					pass
			"Evenement":
				pass
			_:
				noRule()

# Fonction qui vérifie si une amélioration de batiment est possible
func checkUpgrade(batiment,ressource):
	if batiment.CardInfo[5].has(ressource.Cardname):
		batiment.CardInfo[4][batiment.CardInfo[5].find(ressource.Cardname)] += ressource.CardInfo[2]
		print(batiment.CardInfo[4][batiment.CardInfo[5].find(ressource.Cardname)])
		var canLevelUp = true
		for neededRes in batiment.CardInfo[5]:
			var Y = batiment.CardDatabase.DATA[neededRes][2]
			var X = batiment.CardInfo[2]
			var amountToLevelUp = Y*Y*X
			if amountToLevelUp  < batiment.CardInfo[4][batiment.CardInfo[5].find(neededRes)]:
				canLevelUp = false
		return [true, canLevelUp]
	else:
		return [false, false]

# Fonction qui augmente le niveau d'un batiment et s'il y a des cartes affichés sur le jeu
# Mets à jour les valeurs de la carte
func levelUp(Batiment):
	match Batiment.CardInfo[1]:
		"Cabane":
			Batiment.CardInfo[2] += 1
			Batiment.setCost(Batiment.CardInfo[2])
			CardDatabase.DATA["Cabane"][2] = Batiment.CardInfo[2]
			Batiment.updateSpecialText()
			CardDatabase.DATA["Bois"][2] = int((round(float((CardDatabase.DATA["Bois"][2]*CardDatabase.DATA["Bois"][2]*Batiment.CardInfo[2])/5)))*5)
		"Mine":
			Batiment.CardInfo[2] += 1
			Batiment.setCost(Batiment.CardInfo[2])
			CardDatabase.DATA["Mine"][2] = Batiment.CardInfo[2]
			Batiment.updateSpecialText()
			CardDatabase.DATA["Fer"][2] = int((round(float((CardDatabase.DATA["Fer"][2]*CardDatabase.DATA["Fer"][2]*Batiment.CardInfo[2])/5)))*5)
		"Banque":
			Batiment.CardInfo[2] += 1
			Batiment.setCost(Batiment.CardInfo[2])
			CardDatabase.DATA["Banque"][2] = Batiment.CardInfo[2]
			Batiment.updateSpecialText()
			CardDatabase.DATA["Or"][2] = int((round(float((CardDatabase.DATA["Or"][2]*CardDatabase.DATA["Or"][2]*Batiment.CardInfo[2])/5)))*5)
		"Caserne":
			Batiment.CardInfo[2] += 1
			Batiment.setCost(Batiment.CardInfo[2])
			Batiment.updateSpecialText()
			Karma += 10
			updateKarma(10)

# Fonction de test pour savoir lorsqu'un cas n'a pas de règle
func noRule():
	print("No Rule")
	pass
