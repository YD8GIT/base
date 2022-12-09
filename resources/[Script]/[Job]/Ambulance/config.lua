Config                            = {}

Config.DrawDistance               = 100.0

Config.Marker                     = { type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, rotate = false }

Config.ReviveReward               = 1000
Config.AntiCombatLog              = true

Config.Locale                     = 'fr'

local second = 1000
local minute = 60 * second

Config.EarlyRespawnTimer          = 5 * minute
Config.BleedoutTimer              = 10 * minute

Config.EnablePlayerManagement     = true
Config.EnableSocietyOwnedVehicles = false

Config.RemoveWeaponsAfterRPDeath  = false
Config.RemoveCashAfterRPDeath     = false
Config.RemoveItemsAfterRPDeath    = false

Config.EarlyRespawnFine           = false
Config.EarlyRespawnFineAmount     = 10000

Config.RespawnPoint = {coords = vector3(-809.33, -1223.47, 7.34), heading = 228.70}

Config.WhitelistedCops = {

	'ambulance'

}


Ambulance             = {}

Ambulance.jeveuxmarker = true

Ambulance.jeveuxblips = true 

Vehicle = {
    {nom = "~h~→ Dodge", modele = "dodgeEMS"},
	{nom = "~h~→ Ambulance", modele = "ambulance"},

}

VehicleBoss = {
	{nom = "~h~→ Maserati", modele = "ghispo3"},

}

Helico = {
	{nom = "~h~→ Helicoptère EMS", modele = "polmav"},

}

Ambulance.pos = {

	coffre = {

		position = {x = -820.08, y = -1242.77, z = 6.35}

	},
	MAscenseur = {

		position = {x = -794.01, y = -1245.89, z = 7.34}

	},
	DAscenseur = {

		position = {x = -773.96, y = -1207.06, z = 51.15}

	},
	Monter = {

		position = {x = -773.96, y = -1207.06, z = 51.15}

	},
	Heliport = {

		position = {x = -781.73, y = -1201.63, z = 51.07}

	},
	SpawnVehicle = {
		position = {x = -849.8, y = -1224.35, z = 6.61, h = 335.61}
	},
	SupprimerVoiture = {
		position = {x = -841.8, y = -1233.64, z = 6.93}
	},
	Descendre = {

		position = {x = -794.01, y = -1245.89, z = 7.34}

	},
	Vestiaire = {
		position = {x =-824.14, y = -1238.94, z = 6.35}
	},
	Boss = {
		position = {x =-812.07, y = -1237.95, z = 6.34}
	},
	Pharmacie = {
		position = {x =-803.54, y = -1210.54, z = 6.35}
	},
	Garage = {
		position = {x = -847.59, y = -1230.97, z = 6.83}
	},
	SpawnHeli = {
		position = {x = -790.98, y = -1191.93, z = 53.03, h = 50.18}
	},
	SupprimerHeli = {
		position = {x = -790.98, y = -1191.93, z = 53.03}
	},
	RDV = {
		position = {x = -816.42, y = -1237.68, z = 6.35}
	},

}
