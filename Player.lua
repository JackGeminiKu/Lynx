Player = Unit:New('player') 

function Player:Count()
    -- TBD
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
    return wow.GetItemCount(itemName)
end

Player.CastSpell = function(spellName, onSelf)
    wow.CastSpell(spellName, onSelf)
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
    return wow.IsSwimming()
end

Player.IsMounted = function()
    return wow.IsMounted()
end

Player.CorpseRecoveryDelay = function()
    return wow.GetCorpseRecoveryDelay()
end

Player.Interact = function(object)
    return wow.ObjectInteract(object.ObjectTag)
end