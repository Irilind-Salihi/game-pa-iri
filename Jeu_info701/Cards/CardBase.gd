# CardBase.gd
# Script pour la scène CardBase.tscn (c'est le modèle d'une carte)

# Type de noeud : MarginContainer
extends MarginContainer

# Signal envoyé par le noeud lorsque la carte est cliquée ou relâchée
signal selected

# Récupération des informations des cartes
onready var CardDatabase = get_node("/root/CardsDatabase")

# Attribut et information de la carte
var Cardname = 'Bois'
onready var CardInfo = CardDatabase.DATA[Cardname]
onready var CardImg = str("res://Assets/Cards/",CardInfo[0],"/",Cardname,".png")

# Variables pour le déplacement de la carte
var setup = true
var Cardpos = Vector2()
var startpos = Vector2()
var targetpos = Vector2()
var startrot = 0
var targetrot = 0
var t = 0
onready var Orig_scale = rect_scale
var startscale = Vector2()
var targetscale = Vector2()
var firstTime = true

var CARD_SELECT = true

var NumberCardsHand = 0
var Card_Numb = 0

var MovingtoHand = false
var MovingtoInPlay = false

var DiscardPile = Vector2()
var MovingtoDiscard = false

var DeckPile = Vector2()
var MovingtoDeck = false

# Variables pour le temps des animations
var DRAWTIME = 0.5
var ORGANISETIME = 0.2
var INMOUSETIME = 0.1

# Variables des différents états de la carte
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
var state = InHand
var oldstate = INF

# Fonction appelée lorsque le noeud à fini de s'initialiser
func _ready():
	var CardSize = rect_size
	$Border.scale *= CardSize/$Border.texture.get_size()
	$Card.texture = load(CardImg)
	$Card.scale *= CardSize/$Card.texture.get_size()
	$CardBack.scale *= CardSize/$CardBack.texture.get_size()
	$TouchCard.scale *= CardSize/($TouchCard.normal.get_size())
	
	var Cost = str(CardInfo[2])
	var Name = str(CardInfo[1])
	var SpecialText = str(CardInfo[3])
	if CardInfo[0] == "Batiment":
		for i in CardInfo[5]:
			var Y = CardDatabase.DATA[i][2]
			var X = CardInfo[2]
			var amountToLevelUp = Y*X
			SpecialText = SpecialText + " " + str(i) + " : " + str(amountToLevelUp-CardInfo[4][CardInfo[5].find(i)])
		
	$Bars/TopBar/Name/CenterContainer/Name.text = Name
	
	if Cost != "-1":
		setCost(Cost)
	if SpecialText != " ":
		setSpecialText(SpecialText)

# Fonction servant à définir le niveau/valeur de la carte	
func setCost(modif):
	$Bars/TopBar/Cost/CenterContainer/Cost.text = str(modif)

# Fonction servant à mettre à jour le texte central de la carte
func updateSpecialText():
	var SpecialText = str(CardInfo[3])
	if CardInfo[0] == "Batiment":
		for i in CardInfo[5]:
			var Y = CardDatabase.DATA[i][2]
			var X = CardInfo[2]
			var amountToLevelUp = Y*(Y/2)*X
			SpecialText = SpecialText + " " + str(i) + " : " + str(amountToLevelUp-CardInfo[4][CardInfo[5].find(i)])
		
	$Bars/SpecialText/Text/CenterContainer/Type.text = str(SpecialText)

# Fonction servant à définir le texte central de la carte
func setSpecialText(modif):
	$Bars/SpecialText/Text/CenterContainer/Type.text = str(modif)

# Fonction appelée lorsqu'une action est effectuée sur la carte
func _input(event):
	match state:
		Selected, InMouse, InPlay:
			# Si (la carte InPlay et si on click) ou (si on est en état dans la souris ou focus)  
			if (state == InPlay && (event is InputEventScreenTouch && event.is_pressed()))||(state == InMouse || state == Selected):
				emit_signal("selected", self, true)

			# Si on est la carte InPlay on passe dans la souris
			# Lorsqu'on relache le click
			if event is InputEventScreenTouch && !event.is_pressed():
				emit_signal("selected", self, false)

# Fonction appelée à chaque frame 
func _physics_process(delta):
	match state:
		Discard:
			pass
		InHand:
			pass
		InPlay:
			if MovingtoHand:
				if setup:
					Setup()
				if t <= 1:
					rect_position = startpos.linear_interpolate(targetpos, t)
					rect_rotation = startrot * (1-t) + 0*t
					rect_scale = startscale * (1-t) + targetscale*t
					t += delta/float(INMOUSETIME)
				else:
					rect_position = targetpos
					rect_rotation = 0
					rect_scale = targetscale
					MovingtoHand = false
					state = InHand

			if MovingtoInPlay:
				if setup:
					Setup()
				if t <= 1:
					rect_position = startpos.linear_interpolate(targetpos, t)
					rect_rotation = startrot * (1-t) + 0*t
					rect_scale = startscale * (1-t) + targetscale*t
					t += delta/float(INMOUSETIME)
				else:
					rect_position = targetpos
					rect_rotation = 0
					rect_scale = targetscale
					MovingtoInPlay = false
					$'../../'.ReParentCardInPlay(Card_Numb)
		InMouse:
			if setup:
				Setup()
			if t <= 1: 
				rect_position = startpos.linear_interpolate(get_global_mouse_position() - $'../../'.CardSize, t)
				rect_rotation = startrot * (1-t) + 0*t
				rect_scale = startscale * (1-t) + Orig_scale*t
				t += delta/float(INMOUSETIME)
			else:
				rect_position = get_global_mouse_position() - $'../../'.CardSize
				rect_rotation = 0
		Selected:
			pass
		MoveDrawnCardToHand: # Animation de la carte allant vers la main
			if setup:
				Setup()
			if t <= 1:
				rect_position = startpos.linear_interpolate(targetpos, t)
				rect_rotation = startrot * (1-t) + targetrot*t
				if firstTime:
					rect_scale.x = Orig_scale.x * abs(2*t - 1)
				if $CardBack.visible:
					if t >= 0.5:
						$CardBack.visible = false
				t += delta/float(DRAWTIME)
			else:
				if firstTime:
					firstTime = false
				rect_position = targetpos
				rect_rotation = targetrot
				state = InHand	
		ReOrganiseHand: # Etat pour remettre en ordre la position des cartes
			if setup:
				Setup()
			if t <= 1:
				rect_position = startpos.linear_interpolate(targetpos, t)
				rect_rotation = startrot * (1-t) + targetrot*t
				rect_scale = startscale * (1-t) + Orig_scale*t
				t += delta/float(ORGANISETIME)
			else:
				rect_position = targetpos
				rect_rotation = targetrot
				rect_scale = Orig_scale
				state = InHand	
		MoveDrawnCardToDiscard: # Animation de la carte allant vers la défausse
			if MovingtoDiscard:
				if setup:
					Setup()
					var xView = get_viewport().size.x * 0.01
					var yView = get_viewport().size.y * 0.01
					var randomPosX = (randi() % int(xView*2)) - xView
					var randomPosY = (randi() % int(yView*2)) - yView

					targetpos.x = DiscardPile.x + randomPosX
					targetpos.y = DiscardPile.y + randomPosY
					
					var randomAngle = (randf()*30.0) - 15.0
					targetrot = (randomAngle*1.0)
				if t <= 1:
					rect_position = startpos.linear_interpolate(targetpos, t)
					rect_rotation = startrot * (1-t) + targetrot*t
					rect_scale = startscale * (1-t) + Orig_scale*t
					t += delta/float(DRAWTIME)
				else:
					rect_position = targetpos
					rect_rotation = targetrot
					rect_scale = Orig_scale
					MovingtoDiscard = false
					state = Discard
		MoveDrawnCardToDeck: # Animation de la carte allant vers le deck
			if MovingtoDeck:
				if setup:
					Setup()
					targetpos = DeckPile
					targetrot = 0
				if t <= 1:
					rect_position = startpos.linear_interpolate(targetpos, t)
					rect_scale = startscale * (1-t) + Orig_scale*t
					rect_scale.x = Orig_scale.x * abs(2*t - 1)
					rect_rotation = startrot * (1-t) + targetrot*t
					if !$CardBack.visible:
						if t >= 0.5:
							$CardBack.visible = true
					t += delta/float(DRAWTIME)
				else:
					rect_position = targetpos
					rect_rotation = 0
					rect_scale = Orig_scale
					MovingtoDeck = false
					self.queue_free()

# Fonction qui initialise les variables de départ d'une animation avec les valeurs actuelles
func Setup():
	startpos = rect_position
	startrot = rect_rotation
	startscale = rect_scale
	t = 0
	setup = false

# Fonction qui est connecté avec le tactile de la carte lorsqu'il est appuyé
func _on_TouchCard_pressed():
	match state:
		InHand, ReOrganiseHand:
			state = Selected

# Fonction qui est connecté avec le tactile de la carte lorsqu'il est relaché
func _on_TouchCard_released():
	match state:
		Selected:
			state = ReOrganiseHand

# Fonction qui change l'état de la card pour pouvoir être défaussé (faire l'animation)
func deffausseCard():
	setup = true
	MovingtoDiscard = true
	state = MoveDrawnCardToDiscard

# Fonction qui change l'état de la card pour pouvoir retourner dans le deck (faire l'animation)
func returnDeckCard():
	setup = true
	MovingtoDiscard = true
	state = MoveDrawnCardToDiscard

# Fonction de test pour connaître l'état actuel de la carte
func printState():
	match state:
		0:
			print(Cardname, " : InHand")
		1:
			print(Cardname, " : InPlay")
		2:
			print(Cardname, " : InMouse")
		3:
			print(Cardname, " : Selected")
		4:
			print(Cardname, " : MoveDrawnCardToHand")
		5:
			print(Cardname, " : ReOrganiseHand")
		6:
			print(Cardname, " : MoveDrawnCardToDiscard")
		7:
			print(Cardname, " : MoveDrawnCardToDeck")
		_:
			print("error unknow state")
