# DeckDraw.gd
# Script pour le bouton de pioche de carte

# Type de noeud : TouchScreenButton (Button pour la compatibilité tactile avec le mobile)
extends TouchScreenButton

# Taille du deck
var Decksize = INF

# Fonction appelée lorsque le noeud à fini de s'initialiser
func _ready():
	# On récupère la taille de la carte
	var TailleCard = $'../../'.CardSize
	
	# On positionne le bouton en haut à droite de l'écran (de manière plus ou moins responsive)
	position.x = (get_viewport().size.x * 0.85) - ((TailleCard.x)/2.0)
	position.y = (get_viewport().size.y * 0.10) - ((TailleCard.y)/2.0)
	
	# On redimensionne le bouton en fonction de la taille de la carte
	scale = (TailleCard / normal.get_size())

# Fonction appelée quand le bouton est pressé
func _on_DeckDraw_pressed():
	# Pioche la main du joueur ou on fini le tour
	$'../../'.drawAllCard()

