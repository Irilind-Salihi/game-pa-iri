extends MarginContainer

signal selected

# Declare member variables here. Examples:
onready var CardDatabase = preload("res://Assets/Cards/CardsDatabase.gd")
var Cardname = 'Bois'
onready var CardInfo = CardDatabase.DATA[CardDatabase.get(Cardname)]
onready var CardImg = str("res://Assets/Cards/",CardInfo[0],"/",Cardname,".png")
var startpos = Vector2()
var targetpos = Vector2()
var startrot = 0
var targetrot = 0
var t = 0
var DRAWTIME = 0.5
var ORGANISETIME = 0.2
onready var Orig_scale = rect_scale
var firstTime = true

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

# Called when the node enters the scene tree for the first time.
func _ready():
#	print(CardDatabase.get('Bois'))
	var CardSize = rect_size
	$Border.scale *= CardSize/$Border.texture.get_size()
	$Card.texture = load(CardImg)
	$Card.scale *= CardSize/$Card.texture.get_size()
	$CardBack.scale *= CardSize/$CardBack.texture.get_size()
	$TouchCard.scale *= CardSize/($TouchCard.normal.get_size())
	
	var Attack = str(CardInfo[1])
	var Retaliation = str(CardInfo[2])
	var Health = str(CardInfo[3])
	var Cost = str(CardInfo[4])
	var Name = str(CardInfo[5])
	var SpecialText = str(CardInfo[6])
	$Bars/TopBar/Name/CenterContainer/Name.text = Name
	$Bars/TopBar/Cost/CenterContainer/Cost.text = Cost
	$Bars/SpecialText/Text/CenterContainer/Type.text = SpecialText
	$Bars/BottomBar/Health/CenterContainer/Health.text = Health
	$Bars/BottomBar/Attack/CenterContainer/AandR.text = str(Attack,'/',Retaliation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
var setup = true
var startscale = Vector2()
var Cardpos = Vector2()
var ZoomInSize = 2
var ZOOMINTIME = 0.2
var ReorganiseNeighbours = true
var NumberCardsHand = 0
var Card_Numb = 0
var NeighbourCard
var Move_Neightbour_Card_Check = false

var oldstate = INF
var CARD_SELECT = true
var INMOUSETIME = 0.1
var MovingtoHand = false
var MovingtoInPlay = false
var targetscale = Vector2()

var DiscardPile = Vector2()
var MovingtoDiscard = false

var DeckPile = Vector2()
var MovingtoDeck = false

func _input(event):
#	var event_postion = get_canvas_transform().xform_inv(event.position)
	match state:
		Selected, InMouse, InPlay:
			# Si (la carte InPlay et si on click) ou (si on est en état dans la souris ou focus)  
			if (state == InPlay && (event is InputEventScreenTouch && event.is_pressed()))||(state == InMouse || state == Selected):
				emit_signal("selected", self, true)

			# Si on est la carte InPlay on passe dans la souris
			# Lorsqu'on relache le click
			if event is InputEventScreenTouch && !event.is_pressed():
				emit_signal("selected", self, false)
					
#					Brouillon d'endroit pour rediriger la carte 
#						setup = true
#						MovingtoInPlay = true
#						targetpos = Cardpos
#						targetscale = CardSlotSize/rect_size
#						state = InPlay
#						CARD_SELECT = true
					
#						setup = true
#						MovingtoDiscard = true
#						targetpos = Cardpos
#						state = ReOrganiseHand
#						state = MoveDrawnCardToDiscard
#						CARD_SELECT = true


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
				if t <= 1: # Always be a 1
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
				if t <= 1: # Always be a 1
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
			if t <= 1: # Always be a 1
				rect_position = startpos.linear_interpolate(get_global_mouse_position() - $'../../'.CardSize, t)
				rect_rotation = startrot * (1-t) + 0*t
				rect_scale = startscale * (1-t) + Orig_scale*t
				t += delta/float(INMOUSETIME)
			else:
				rect_position = get_global_mouse_position() - $'../../'.CardSize
				rect_rotation = 0
		Selected:
			pass
#			if setup:
#				Setup()
#			if t <= 1: # Always be a 1
#				rect_position = startpos.linear_interpolate(targetpos, t)
#				rect_rotation = startrot * (1-t) + 0*t
#				rect_scale = startscale * (1-t) + Orig_scale*2*t
#				t += delta/float(ZOOMINTIME)
#				if ReorganiseNeighbours:
#					ReorganiseNeighbours = false
#					NumberCardsHand = $'../../'.NumberCardsHand - 1 # offset for zeroth item
#					if Card_Numb - 1 >= 0:
#						Move_Neighbour_Card(Card_Numb - 1,true,1) # true is left!
#					if Card_Numb - 2 >= 0:
#						Move_Neighbour_Card(Card_Numb - 2,true,0.25)
#					if Card_Numb + 1 <= NumberCardsHand:
#						Move_Neighbour_Card(Card_Numb + 1,false,1)
#					if Card_Numb + 2 <= NumberCardsHand:
#						Move_Neighbour_Card(Card_Numb + 2,false,0.25)
#			else:
#				rect_position = targetpos
#				rect_rotation = 0
#				rect_scale = Orig_scale*ZoomInSize
		MoveDrawnCardToHand: # animate from the deck to my hand
			if setup:
				Setup()
			if t <= 1: # Always be a 1
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
				
		ReOrganiseHand:
			if setup:
				Setup()
			if t <= 1: # Always be a 1
				if Move_Neightbour_Card_Check:
					Move_Neightbour_Card_Check = false
				rect_position = startpos.linear_interpolate(targetpos, t)
				rect_rotation = startrot * (1-t) + targetrot*t
				rect_scale = startscale * (1-t) + Orig_scale*t
				t += delta/float(ORGANISETIME)
				if ReorganiseNeighbours == false:
					ReorganiseNeighbours = true
					if Card_Numb - 1 >= 0:
						Reset_Card(Card_Numb - 1) # true is left!
					if Card_Numb - 2 >= 0:
						Reset_Card(Card_Numb - 2)
					if Card_Numb + 1 <= NumberCardsHand:
						Reset_Card(Card_Numb + 1)
					if Card_Numb + 2 <= NumberCardsHand:
						Reset_Card(Card_Numb + 2)
			else:
				rect_position = targetpos
				rect_rotation = targetrot
				rect_scale = Orig_scale
				state = InHand
				
		MoveDrawnCardToDiscard:
			if MovingtoDiscard:
				if setup:
					Setup()
					var randomPosX = (randi() % 25) - 12
					var randomPosY = (randi() % 10) - 5

					targetpos.x = DiscardPile.x + randomPosX
					targetpos.y = DiscardPile.y + randomPosY
					
					var randomAngle = (randf()*30) - 15
					targetrot = startrot * (randomAngle*1.0)
				if t <= 1: # Always be a 1
					rect_position = startpos.linear_interpolate(targetpos, t)
					rect_scale = startscale * (1-t) + Orig_scale*t
					t += delta/float(DRAWTIME)
				else:
					rect_position = targetpos
					rect_scale = Orig_scale
					MovingtoDiscard = false
					state = Discard
		MoveDrawnCardToDeck:
			if MovingtoDeck:
				if setup:
					Setup()
					targetpos = DeckPile
					targetrot = 0
				if t <= 1: # Always be a 1
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

func Move_Neighbour_Card(Card_Number,Left,Spreadfactor):
	NeighbourCard = $'../'.get_child(Card_Number)
	if Left:
		NeighbourCard.targetpos = NeighbourCard.Cardpos - Spreadfactor*Vector2(65,0)
	else:
		NeighbourCard.targetpos = NeighbourCard.Cardpos + Spreadfactor*Vector2(65,0)
	NeighbourCard.setup = true
	NeighbourCard.state = ReOrganiseHand
	NeighbourCard.Move_Neightbour_Card_Check = true

func Reset_Card(Card_Number):
#    if NeighbourCard.Move_Neightbour_Card_Check:
#        NeighbourCard.Move_Neightbour_Card_Check = false
	if NeighbourCard.Move_Neightbour_Card_Check == false:
		NeighbourCard = $'../'.get_child(Card_Number)
		if NeighbourCard.state != Selected:
			NeighbourCard.state = ReOrganiseHand
			NeighbourCard.targetpos = NeighbourCard.Cardpos
			NeighbourCard.setup = true

func Setup():
	startpos = rect_position
	startrot = rect_rotation
	startscale = rect_scale
	t = 0
	setup = false

#func _on_Focus_mouse_entered():
#	printState()
#	match state:
#		InHand, ReOrganiseHand:
#			setup = true
#			targetpos = Cardpos
#			targetpos.y = get_viewport().size.y - $'../../'.CardSize.y*ZoomInSize
#			state = Selected
#	pass

#func _on_Focus_mouse_exited():
#	match state:
#		Selected:
#			setup = true
#			targetpos = Cardpos
#			state = ReOrganiseHand
#	pass


func _on_TouchCard_pressed():
#	print("down "+Cardname+ " - old state : "+ str(state))
	match state:
		InHand, ReOrganiseHand:
			state = Selected

func _on_TouchCard_released():
#	print("up "+Cardname)
	match state:
		Selected:
			state = ReOrganiseHand

func deffausseCard():
	setup = true
	MovingtoDiscard = true
	state = MoveDrawnCardToDiscard

func returnDeckCard():
	setup = true
	MovingtoDiscard = true
	state = MoveDrawnCardToDiscard

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

# To do (plus haut = plus important) : 
#	- Voir la compatibilité téléphone et report les bugs + faire la doc d'installe pour le prof
#	- Focus compatible sur téléphone (Placer la carte dans la partie basse de l'écran et elle apparait en immense) Puis disparait quand on sort ou relache la carte
#	- 

#
#func _on_Victime_button_down():
#	print("down "+Cardname+ " - old state : "+ str(state))
#
#
#func _on_Victime_button_up():
#	print("up "+Cardname)
