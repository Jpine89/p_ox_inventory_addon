Magazines = {
	['magazine'] = {
		label = 'Magazine',
		consume = 0,
		weight = 20,
		stack = false, -- each mag is unique
		client = {
			export = 'p_ox_inventory_addon.useMagazine',
		},
		buttons = {
			{
				label = 'Equip & Pack',
				action = function(slot)
					local item = PlayerData.inventory[slot]
					exports.p_ox_inventory_addon:equipMagazine({name = item.name, slot = item.slot, metadata = item.metadata})
				end
			},
			{
				label = 'Unequip Magazine',
				action = function(slot)
					exports.p_ox_inventory_addon:unequipMagazine()
				end
			},
		},
		magazine = true,
	},
}
