extends Node
# Unitinfo = [Type, Attack, Retaliation, Health, Cost, Name, Melee or Ranged, Special Text]
# Eventinfo = [Type, Cost, Effect]
var DATA = {
	"Batiment" : 
		["Menu", "Batiment", -1, " ", -1, []],
	"Evenement" :
		["Menu", "Evenement", -1, " ", -1, []],
	"Ressource" :
		["Menu", "Ressource", -1, " ", -1, []],
	"Retour" :
		["Menu", "Retour", -1, " ", -1, []],
	"Unite" :
		["Menu", "Unite", -1, " ", -1, []],
	"Cabane" :
		["Batiment", "Cabane", 1, "Prix : ", [0], ["Bois"]],
	"Mine" :
		["Batiment", "Mine", 1, "Prix : ", [0], ["Fer"]],
	"Banque" :
		["Batiment", "Banque", 1, "Prix : ", [0], ["Or"]],
	"Caserne" :
		["Batiment", "Caserne", 1, "Prix : ", [0,0], ["Bois","Or"]],
	"Bois" : 
		["Ressource", "Bois", 50, " ", -1, []],
	"Bronze" :
		["Ressource", "Bronze", 30, " ", -1, []],
	"Fer" :
		["Ressource", "Fer", 20, " ", -1, []],
	"Marbre" :
		["Ressource", "Marbre", 10, " ", -1, []],
	"Or" :
		["Ressource", "Or", 10, " ", -1, []],
	"Pierre" : 
		["Ressource", "Pierre", 40, " ", -1, []],
	"Mercenary" :
		["Unite", "Mercenary", -1, " ", -1, []],
	"Spearman" :
		["Unite", "Spearman", -1, " ", -1, []],
	"Mentor" :
		["Unite", "Mentor", -1, " ", -1, []],
	"Trebuchet" :
		["Evenement", "Trebuchet", -1, "Event : ", -1, []],
	}
