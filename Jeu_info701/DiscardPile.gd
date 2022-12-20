# DisplayCard.gd
# Script pour le noeud DisplayCard (Emplacement de la défausse des cartes)

# Type de noeud : TouchScreenButton (Button pour la compatibilité tactile avec le mobile)
extends TextureButton

# Fonction appelée lorsque le noeud à fini de s'initialiser
func _ready():
	# On récpère la taille de la carte
	var TailleCard = $'../../'.CardSize/rect_size

	# On positionne le noeud en bas à droite de l'écran
	rect_position.x = (get_viewport().size.x * 0.70) - ((TailleCard.x)/2.0)
	rect_position.y = (get_viewport().size.y * 0.80) - ((TailleCard.y)/2.0)

	# On redimensionne le noeud pour qu'il ait la même taille que la carte
	rect_scale *= TailleCard

	# On désactive le noeud pour qu'il ne soit pas cliquable
	disabled = true
