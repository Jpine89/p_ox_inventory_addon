local function updateMagazine(source, action, value, slot, specialAmmo)
	local inventory = exports.ox_inventory:GetInventory(source)
	if not inventory then return end

    if action == 'load' then
        local weapon = exports.ox_inventory:GetCurrentWeapon(source)
        if not weapon and not weapon.metadata then return false end
        local magazine = exports.ox_inventory:GetSlot(source, slot)
        local ammo = magazine.metadata.label
        local currentWepAmmo = weapon.metadata.ammo or 0
        local newMagazineMetadata = {
            label    = magazine.metadata.label,
            magType  = magazine.metadata.magType,
            ammoType = magazine.metadata.ammoType,
            magSize  = magazine.metadata.magSize,
            model    = magazine.metadata.model,
            ammo     = currentWepAmmo,
            durability = math.max(1, math.floor((currentWepAmmo / magazine.metadata.magSize) * 100))
        }
                                                         
        local itemKey = magazine.name
        local magType = magazine and magazine.metadata and magazine.metadata.magType
        local metadata = magType and { magType = magType } or nil

        if not exports.ox_inventory:RemoveItem(source, itemKey, 1, metadata, slot, false, false) then return end

        if currentWepAmmo > 0 or weapon.metadata.hasMagazine then
            exports.ox_inventory:AddItem(source, itemKey, 1, newMagazineMetadata)
        end

        weapon.metadata.ammo = value
        weapon.metadata.hasMagazine = true
        weapon.metadata.magazineType = ammo
        --weapon.weight = Inventory.SlotWeight(item, weapon)
        exports.ox_inventory:SetMetadata(source, weapon.slot, weapon.metadata)
    elseif action == 'loadMagazine' then
        local magazine = exports.ox_inventory:GetSlot(source, slot)
        magazine.metadata.ammo = value
        magazine.metadata.durability = math.max(1, math.floor((value / magazine.metadata.magSize) * 100))
        exports.ox_inventory:SetMetadata(source, slot, magazine.metadata)
    end

    return true
end

lib.callback.register('p_ox_inventory_addon:updateMagazine', updateMagazine)

RegisterNetEvent('p_ox_inventory_addon:updateMagazine', function(action, value, slot, specialAmmo)
	updateMagazine(source, action, value, slot, specialAmmo)
end)


exports.ox_inventory:registerHook('swapItems', function(payload)
    print('Swapping items:', json.encode(payload or {}))
end)

exports.ox_inventory:registerHook('createItem', function(payload)
    if payload.item.magazine then
        payload.metadata.id = tostring(math.random(100000,999999)) .. tostring(GetGameTimer())
    end

    return payload.metadata
end)