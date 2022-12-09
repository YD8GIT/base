Config = {}

Config.Locale = 'en'

--Config.serverLogo = 'https://i.imgur.com/AcgDL9f.png'

Config.font = {
	name 	= 'Montserrat',
	url 	= 'https://fonts.googleapis.com/css?family=Montserrat:300,400,700,900&display=swap'
}


Config.voice = {

	levels = {
		default = 5.0,
		shout = 10.0,
		whisper = 2.0,
		current = 0
	},
	
	keys = {
		distance 	= 'F2',
	}
}


Config.vehicle = {
	speedUnit = 'KMH',
	maxSpeed = 400,

	keys = {
		seatbelt 	= 'K',
		cruiser		= 'CAPS',
		signalLeft	= 'LEFT',
		signalRight	= 'RIGHT',
		signalBoth	= 'DOWN',
	}
}

Config.ui = {
	showServerLogo		= False,

	showJob		 		= true,

	showWalletMoney 	= true,
	showBankMoney 		= false,
	showBlackMoney 		= true,
	showSocietyMoney	= false,

	showLocation 		= true,
	showVoice	 		= true,

	showHealth			= true,
	showArmor	 		= true,
	showStamina	 		= false,
	showHunger 			= true,
	showThirst	 		= true,

	showMinimap			= true,

	showWeapons			= true,	
}