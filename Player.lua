player = {}

player.Level = function()
    return UnitLevel("player")
end

player.GetPosition = function()
    return lb.ObjectPosition("player")
end

player.GetFreeSlots = function()
    local freeSlots = 0
    for i = 1, 5 do
        local numberOfFreeSlots, BagType = wow.GetContainerNumFreeSlots(i - 1);
        if BagType == 0 then -- https://wowwiki.fandom.com/wiki/ItemFamily
            freeSlots = freeSlots + wow.GetContainerNumFreeSlots(i - 1)
        end
    end
    return freeSlots
end

player.GetItemCount = function(itemName)
    return GetItemCount(itemName)
end

player.CastSpell = function(spellName, onSelf)
    onSelf = onSelf or true
    lb.Unlock(CastSpellByName, spellName, onSelf)
end

player.HasInInventory = function(item)
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

player.IsHunter = function()
    return wow.UnitClass("player") == "Hunter"
end

player.IsMage = function()
    return wow.UnitClass("player") == "Mage"
end

player.IsOnCD = function(spellName)
    local start, duration, enabled = wow.GetSpellCooldown(spellName);
    if enabled == 0 then
        return true
    elseif (start > 0 and duration > 0) then
        return true
    else
        return false
    end
end

player.IsCastable = function(spellName)
    local usable, nomana = wow.IsUsableSpell(spellName)
    if usable == false or nomana then
        return false
    end
    return not player.IsOnCD(spellName)
end

player.IsCasting = function()
    return lb.UnitCastingInfo("palyer") ~= 0
end

player.IsDeadOrGhost = function()
    return UnitIsDeadOrGhost("player")
end

player.IsDrinking = function()
    return wow.HasAura("player", "Drink")
end

player.IsEating = function()
    return wow.HasAura("player", "Food")
end

player.IsSwimming = function()
    return IsSwimming()
end

player.IsMounted = function()
    return IsMounted()
end

player.IsInCombat = function()
    return wow.UnitAffectingCombat("player")
end

player.IsMage = function()
    return wow.UnitClass("player") == "Mage"
end

player.IsDead = function()
    return UnitIsDead("player")
end

player.GetHealthPercent = function()
    return 100 * UnitHealth("player") / UnitHealthMax("player")
end

player.GetPowerPercent = function()
    return 100 * UnitPower("player") / UnitPowerMax("player")
end

player.DistanceFrom = function(dest)
    return lb.GetDistance3D("player", dest)
end

player.CorpseRecoveryDelay = function()
    return GetCorpseRecoveryDelay()
end

player.HasAura = function(aura)
    wow.HasAura("player", aura)
end
