local Config = require 'magazine.config'
local currentMag = {
        prop = 0,
        item = nil,
        slot = -1,
        metadata = {},
}
local isReloading = false

local function assertMetadata(metadata)
    if metadata and type(metadata) ~= 'table' then
        metadata = metadata and { type = metadata or nil }
    end

    return metadata
end

function ReturnFirstOrderedItem(itemName, metadata, strict)
    local inventory = exports.ox_inventory:GetPlayerItems()
    
    local item = exports.ox_inventory:Items(itemName)
    if item then
        return exports.ox_inventory:GetSlotIdWithItem(itemName, {}, strict)
    else
        item = exports.ox_inventory:Items('Magazine')
        if not item then return end

        local matchedItems = {}
        metadata = assertMetadata(metadata)
        local tablematch = strict and lib.table.matches or lib.table.contains
        
        for _, slotData in pairs(inventory) do
            if slotData and slotData.name == item.name and slotData.metadata.ammo > 0 and slotData.metadata.magType == itemName and (not metadata or tablematch(slotData.metadata, metadata)) then
                table.insert(matchedItems, slotData)
            end
        end
        
        if #matchedItems == 0 then return end

        table.sort(matchedItems, function(a, b)
            return (a.metadata.ammo or 0) > (b.metadata.ammo or 0)
        end)

        return matchedItems[1].slot
    end
end
exports('ReturnFirstOrderedItem', ReturnFirstOrderedItem)

function StartDisablePunchLoop()
    CreateThread(function()
        while currentMag.prop ~= 0 do
            DisableControlAction(0, 140, true) -- Hack to prevent punching while reloading
            Wait(0)
        end
    end)
end

local function attachMagazine(data, context)
    currentMag = {
        prop = 0,
        item = context,
        slot = context.slot,
        metadata = context.metadata or {},
    }
    -- Model = 'w_pi_combatpistol_mag1',
    -- BoneID = 18905,
    -- Offset = vector3(0.109000, 0.086000, -0.023000),
    -- Rot = vector3(63.749866, 180.301071, -184.201492),
    local modelHash = joaat(type(context.metadata.model) == 'string' and context.metadata.model or 'w_pi_combatpistol_mag1')
    local boneIndex = 18905  -- Bone index for right hand (57005) (Use 18905 for left hand)

    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(10)
    end

    currentMag.prop = CreateObject(modelHash, 0.0, 0.0, 0.0, true, true, false)
    local pos = { x = 0.109000, y = 0.086, z = -0.023 }
    local rot = { x = 63.749866, y = 180.301071, z = -184.201492 }

    AttachEntityToEntity(
        currentMag.prop, cache.ped, GetPedBoneIndex(cache.ped, boneIndex),
        pos.x, pos.y, pos.z,
        rot.x, rot.y, rot.z,
        true, true, false, true, 1, true)

    SetModelAsNoLongerNeeded(modelHash)
    StartDisablePunchLoop()
    TriggerEvent('ox_inventory:itemNotify', { context, 'ui_equipped' })
end

local function detachMagazine()
    if currentMag.prop ~= 0 and DoesEntityExist(currentMag.prop) then
        DetachEntity(currentMag.prop, true, true)
        DeleteEntity(currentMag.prop)
        TriggerEvent('ox_inventory:itemNotify', { currentMag.item, 'ui_holstered' })
        currentMag = {
            prop = 0,
            item = nil,
            slot = nil,
            metadata = {},
        }
    end
end

local function packMagazine(data)
	exports.ox_inventory:useItem({
        name = currentMag.item.name,
        slot = currentMag.item.slot,
        metadata = currentMag.item.metadata,
    }, function(resp)
        if not resp then return end
        isReloading = true
        local bulletsAddedToMag = 0
        Citizen.CreateThread(function()
            while isReloading do
                local animDict = "cover@weapon@reloads@pistol@pistol"
                local animName = "reload_low_left_long"
                if not isReloading then break end

                if resp.metadata.ammo >= resp.metadata.magSize then
                    --print('Magazine is full or no more ammo to load.')
                    isReloading = false
                    break
                end

                if lib.progressCircle({
                    duration = Config.MagazineReloadTime,
                    position = 'bottom',
                    label = 'pack_magazine',
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        move = true,
                        car = true,
                        combat = true,
                        mouse = false,
                    },
                    anim = {
                        clip = animName,
                        dict= animDict,
                        flag = 16
                    }
                })
                then
                    bulletsAddedToMag = bulletsAddedToMag + 1
                    resp.metadata.durability = math.max(1, math.floor((resp.metadata.ammo + bulletsAddedToMag) / resp.metadata.magSize * 100))
                else
                    isReloading = false
                end
            end
            local success = lib.callback.await('p_ox_inventory_addon:updateMagazine', 2000, 'loadMagazine', bulletsAddedToMag, resp.slot, nil)
            if not success then
                lib.notify({ id = 'pack_failed', type = 'error', description = 'Failed to pack magazine - server timeout' })
            end
            isReloading = false
        end)
    end)
end

local function useMagazine(data, context)
    local playerPed = cache.ped
    local weapon = exports.ox_inventory:getCurrentWeapon()

    -- Why we can't disarm the weapon, when using the magazine.
    -- This function gets called from ox_inventory useSlot function.
    -- When useSlot gets called, it looks at the item being used and checks for exports. 
    -- In this case the magazine item has an export and it calls here. 
    -- Problem is when you reload a gun, it calls the item in useSlot..
    -- If you see where I'm going.. basically in both wanting to pack a magazine, and reloading a gun.
    -- Both actions in useSlot reference here. Thus we have no real way of determining, if you are
    -- reloading your weapon.. or wanting to equip the magazine.
    -- Thus we treat all Magazine actions when weapon is equipped as reloading the gun.

    -- May look into maybe.. finding a solution to this but it's a complex one already.
    if weapon then
        if weapon.ammo ~= context.metadata.magType then lib.notify({ id = 'no_magazine', type = 'error', description = 'no_magazine_found' }) return end
        if context.metadata.ammo < 1 then lib.notify({ id = 'no_magazine', type = 'error', description = 'no_magazine_found' }) return end
        if isReloading then return end
        isReloading = true
        exports.ox_inventory:useItem(data, function(resp)
            if (not resp) then isReloading = false return end
            local success = lib.callback.await('p_ox_inventory_addon:updateMagazine', 2000, 'load', resp.metadata.ammo, context.slot, weapon.metadata or nil)

            if not success then
                lib.notify({ id = 'no_magazine', type = 'error', description = 'Failed to reload - server timeout' })
                isReloading = false
                return
            end
            local clipSize = GetMaxAmmoInClip(playerPed, weapon.hash, true)
            local roundsToSet = resp.metadata.ammo or 0
            if clipSize and roundsToSet > clipSize then
                roundsToSet = clipSize
            end
            SetAmmoInClip(playerPed, weapon.hash, 0)
            SetPedAmmo(playerPed, weapon.hash, roundsToSet)
            MakePedReload(playerPed)

            weapon.metadata.ammo = resp.metadata.ammo
            weapon.metadata.hasMagazine = true
            isReloading = false
        end)
    elseif data.magazine then
        local magId = context.metadata and context.metadata.id
        local currentId = currentMag.metadata and currentMag.metadata.id
        if magId and currentId and magId == currentId then
            if currentMag.prop ~= 0 and DoesEntityExist(currentMag.prop) then
                detachMagazine()
            end
        else
            if currentMag.prop ~= 0 and DoesEntityExist(currentMag.prop) then
                detachMagazine()
            end
            attachMagazine(data, context)
        end
    end

end
exports('useMagazine', useMagazine)

AddEventHandler('ox_inventory:currentWeapon', function(currentWeapon)
    if currentWeapon and currentWeapon.name then
        detachMagazine()
    end
end)

lib.addKeybind({
    name = 'reloadweapon_addon',
    description = 'reload_weapon_addon',
    defaultKey = 'r',
    onPressed = function(self)
        if currentMag.prop ~= 0 and DoesEntityExist(currentMag.prop) then
            local slotId = exports.ox_inventory:GetSlotIdWithItem(currentMag.metadata.ammoType, {}, false)
            if slotId then
                packMagazine(currentMag)
            else
                lib.notify({ id = 'no_ammo', type = 'error', description = 'no_ammo_found' })
            end
            
            return
        end

        local currentWeapon = exports.ox_inventory:getCurrentWeapon(true)
        if not currentWeapon then return end
        if currentWeapon.ammo then
            if currentWeapon.metadata.durability > 0 then
                local slotId = ReturnFirstOrderedItem(currentWeapon.ammo, { magType = currentWeapon.metadata.magType }, false)

                if slotId then
                    exports.ox_inventory:useSlot(slotId)
                else
                    lib.notify({ id = 'no_magazine', type = 'error', description = 'no_magazine_found' })
                end
            else
                lib.notify({ id = 'no_durability', type = 'error', description = 'no_durability' })
            end
            return
        end
    end
})

AddEventHandler('onResourceStop', function(resource)
    detachMagazine()
end)

