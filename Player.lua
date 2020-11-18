player = {}

player.IsDeadOrGhost = function()
    return UnitIsDeadOrGhost("player")
end

player.IsSwimming = function()
    return IsSwimming()
end

player.IsMounted = function()
    return IsMounted()
end

player.IsEating = function()
    return wow.HasAura("player", "Food")
end

player.IsDrinking = function()
    return wow.HasAura("player", "Drink")
end

player.IsInCombat = function()
    return wow.UnitAffectingCombat("player")
end

player.IsMage = function()
    return wow.UnitClass("player") == "Mage"
end

player.GetHealthPercent = function()
    return 100 * UnitHealth("player") / UnitHealthMax("player")
end

player.GetPowerPercent = function()
    return 100 * UnitPower("player") / UnitPowerMax("player")
end

player.HasAura = function(aura)
    wow.HasAura("player", aura)
end
