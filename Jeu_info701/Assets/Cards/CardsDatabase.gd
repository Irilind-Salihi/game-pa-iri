
# Unitinfo = [Type, Attack, Retaliation, Health, Cost, Name, Melee or Ranged, Special Text]
# Eventinfo = [Type, Cost, Effect]
enum {Batiment, Evenement, Ressource, Retour, Unite, Cabane, Mine, Banque, Caserne, Bois, Bronze, Fer, Marbre, Or, Pierre, Mercenary, Spearman, Mentor, Trebuchet}

const DATA = {
	Batiment : 
		["Menu", "Batiment", -1, " "],
	Evenement :
		["Menu", "Evenement", -1, " "],
	Ressource :
		["Menu", "Ressource", -1, " "],
	Retour :
		["Menu", "Retour", -1, " "],
	Unite :
		["Menu", "Unite", -1, " "],
	Cabane :
		["Batiment", "Cabane", 1, "Prix : "],
	Mine :
		["Batiment", "Mine", 1, "Prix : "],
	Banque :
		["Batiment", "Banque", 1, "Prix : "],
	Caserne :
		["Batiment", "Caserne", 1, "Prix : "],
	Bois : 
		["Ressource", "Bois", 20, " "],
	Bronze :
		["Ressource", "Bronze", 20, " "],
	Fer :
		["Ressource", "Fer", 20, " "],
	Marbre :
		["Ressource", "Marbre", 20, " "],
	Or :
		["Ressource", "Or", 20, " "],
	Pierre : 
		["Ressource", "Pierre", 20, " "],
	Mercenary :
		["Unite", "Mercenary", -1, " "],
	Spearman :
		["Unite", "Spearman", -1, " "],
	Mentor :
		["Unite", "Mentor", -1, " "],
	Trebuchet :
		["Evenement", "Trebuchet", -1, "Event : "],
	}
