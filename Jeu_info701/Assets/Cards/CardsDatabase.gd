
# Unitinfo = [Type, Attack, Retaliation, Health, Cost, Name, Melee or Ranged, Special Text]
# Eventinfo = [Type, Cost, Effect]
enum {Batiment, Evenement, Ressource, Retour, Unite, Cabane, Mine, Bois, Bronze, Fer, Marbre, Or, Pierre, Mercenary, Spearman, Mentor, Trebuchet}

const DATA = {
	Batiment : 
		["Menu", 1, 1, 2, 1, "Batiment", "Melee"],
	Evenement :
		["Menu", 2, 1, 3, 2, "Evenement", "Ranged,\nImmune to\nRetaliation"],
	Ressource :
		["Menu", 2, 2, 3, 3, "Ressource", "Melee,\nGive all friendly\n+1 Attack and \nRetaliation"],
	Retour :
		["Menu", 4, 0, 2, 3, "Retour", "Melee,\nImmune to\nRetaliation"],
	Unite :
		["Menu", 1, 3, 6, 3, "Unite", "Melee,\nProtector - stops the unit\nbehind it\nbeing attacked"],
	Cabane :
		["Batiment", 1, 3, 6, 3, "Cabane", "Melee,\nProtector - stops the unit\nbehind it\nbeing attacked"],
	Mine :
		["Batiment", 1, 3, 6, 3, "Mine", "Melee,\nProtector - stops the unit\nbehind it\nbeing attacked"],
	Bois : 
		["Ressource", 1, 1, 2, 1, "Bois", "Melee"],
	Bronze :
		["Ressource", 2, 1, 3, 2, "Bronze", "Ranged,\nImmune to\nRetaliation"],
	Fer :
		["Ressource", 2, 2, 3, 3, "Fer", "Melee,\nGive all friendly\n+1 Attack and \nRetaliation"],
	Marbre :
		["Ressource", 4, 0, 2, 3, "Marbre", "Melee,\nImmune to\nRetaliation"],
	Or :
		["Ressource", 1, 3, 6, 3, "Or", "Melee,\nProtector - stops the unit\nbehind it\nbeing attacked"],
	Pierre : 
		["Ressource", 2, 3, 6, 4, "Pierre", "Melee"],
	Mercenary :
		["Unite", 2, 2, 0, 2, "Mercenary", "Melee,\nAlways Retaliates\nReturn to Supply when damaged\nor at start of next turn\nAfter played, increase\ncost by 1"],
	Spearman :
		["Unite", 2, 2, 5, 3, "Spearman", "Melee or Ranged"],
	Mentor :
		["Unite", 3, 0, 1, 2, "Mentor", "Melee,\nWhen played give\nfriendly unit +2 Attack\nand Retaliation"],
	Trebuchet :
		["Evenement", 4, "Deal 6 damage\nto a unit"],
	}
