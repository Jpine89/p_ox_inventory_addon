return {
	Magazines = {
		['magazine'] = {
			label = 'Magazine',
			consume = 0,
			weight = 20,
			stack = false, -- each mag is unique
			client = {
				image = 'at_clip_extended.png',
				export = 'p_ox_inventory_addon.useMagazine',
			},
			magazine = true,
		},
	},
	Ammunation = {
	name = 'Ammunation',
	blip = {
		id = 110, colour = 69, scale = 0.8
	}, inventory = {
		{ name = 'ammo-9', price = 5, },
		{ name = 'WEAPON_KNIFE', price = 200 },
		{ name = 'WEAPON_BAT', price = 100 },
		{ name = 'WEAPON_PISTOL', price = 1000, metadata = { registered = true }, license = 'weapon' },
		{ --Example magazine with a shop
			name = 'magazine',
			price = 50,
			metadata = {
				label 		= '9mm Magazine',
				model 		= 'w_pi_combatpistol_mag1',
				magType 	= 'magazine-9',
				ammoType 	= 'ammo-9',
				magSize 	= 12,
				ammo 		= 0
			},
			name = 'magazine',
			price = 50,
			metadata = {
				label 		= 'Gevärsmagasin 2',
				model 		= 'w_pi_combatpistol_mag1',
				magType 	= 'magazine-rifle2',
				ammoType 	= 'ammo-9',
				magSize 	= 30,
				ammo 		= 0
			}
		},
	}, locations = {
		vec3(-662.180, -934.961, 21.829),
		vec3(810.25, -2157.60, 29.62),
		vec3(1693.44, 3760.16, 34.71),
		vec3(-330.24, 6083.88, 31.45),
		vec3(252.63, -50.00, 69.94),
		vec3(22.56, -1109.89, 29.80),
		vec3(2567.69, 294.38, 108.73),
		vec3(-1117.58, 2698.61, 18.55),
		vec3(842.44, -1033.42, 28.19)
	}, targets = {
		{ loc = vec3(-660.92, -934.10, 21.94), length = 0.6, width = 0.5, heading = 180.0, minZ = 21.8, maxZ = 22.2, distance = 2.0 },
		{ loc = vec3(808.86, -2158.50, 29.73), length = 0.6, width = 0.5, heading = 360.0, minZ = 29.6, maxZ = 30.0, distance = 2.0 },
		{ loc = vec3(1693.57, 3761.60, 34.82), length = 0.6, width = 0.5, heading = 227.39, minZ = 34.7, maxZ = 35.1, distance = 2.0 },
		{ loc = vec3(-330.29, 6085.54, 31.57), length = 0.6, width = 0.5, heading = 225.0, minZ = 31.4, maxZ = 31.8, distance = 2.0 },
		{ loc = vec3(252.85, -51.62, 70.0), length = 0.6, width = 0.5, heading = 70.0, minZ = 69.9, maxZ = 70.3, distance = 2.0 },
		{ loc = vec3(23.68, -1106.46, 29.91), length = 0.6, width = 0.5, heading = 160.0, minZ = 29.8, maxZ = 30.2, distance = 2.0 },
		{ loc = vec3(2566.59, 293.13, 108.85), length = 0.6, width = 0.5, heading = 360.0, minZ = 108.7, maxZ = 109.1, distance = 2.0 },
		{ loc = vec3(-1117.61, 2700.26, 18.67), length = 0.6, width = 0.5, heading = 221.82, minZ = 18.5, maxZ = 18.9, distance = 2.0 },
		{ loc = vec3(841.05, -1034.76, 28.31), length = 0.6, width = 0.5, heading = 360.0, minZ = 28.2, maxZ = 28.6, distance = 2.0 }
	}
	},
	Weapon ={
		['WEAPON_PISTOL'] = {
			label = 'Pistol',
			weight = 1130,
			durability = 0.1,
			ammoname = 'magazine-9',
		},
	}
}