Player = Unit:New('player') 

Player.MoveTo = function(...)
    if select('#', ...) == 3 then
        local x, y, z = ...
        lb.MoveTo(x, y, z)
    else
        local point = ...
        if point.x == nil then
            lb.MoveTo(point[1], point[2], point[3])
        else
            lb.MoveTo(point.x, point.y, point.z)
        end
    end
end

Player.Jump = function()
    wow.SendKey(' ')
end

Player.GetFreeSlots = function()
    local freeSlots = 0
    for i = 1, 5 do
        local numberOfFreeSlots, BagType = wow.GetContainerNumFreeSlots(i - 1);
        if BagType == 0 then -- https://wowwiki.fandom.com/wiki/ItemFamily
            freeSlots = freeSlots + wow.GetContainerNumFreeSlots(i - 1)
        end
    end
    return freeSlots
end

Player.GetItemCount = function(itemName)
    return GetItemCount(itemName)
end

Player.CastSpell = function(spellName, onSelf)
    onSelf = onSelf or true
    lb.Unlock(CastSpellByName, spellName, onSelf)
end

Player.HasInInventory = function(item)
    for bag = 0, 4 do
        for slot = 0, wow.GetContainerNumSlots(bag) do
            local link = wow.GetContainerItemLink(bag, slot)
            if link then
                local sName, _, _, _, _, _, _, _ = wow.GetItemInfo(link)
                if sName == item then
                    return true
                end
            end
        end
    end
    return false
end

Player.IsOnCD = function(spellName)
    local start, duration, enabled = wow.GetSpellCooldown(spellName);
    if enabled == 0 then
        return true
    elseif (start > 0 and duration > 0) then
        return true
    else
        return false
    end
end

Player.IsCastable = function(spellName)
    local usable, nomana = wow.IsUsableSpell(spellName)
    if usable == false or nomana then
        return false
    end
    return not Player.IsOnCD(spellName)
end

Player.IsSwimming = function()
    return IsSwimming()
end

Player.IsMounted = function()
    return IsMounted()
end

Player.CorpseRecoveryDelay = function()
    return GetCorpseRecoveryDelay()
end