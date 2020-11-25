Unit = Object:New()

function Unit:IsMoving()
    return wow.GetUnitSpeed(self.ObjectTag) > 0
end

function Unit:Level()
    return UnitLevel(self.ObjectTag)
end

function Unit:IsHunter()
    return wow.UnitClass(self.ObjectTag) == "Hunter"
end

function Unit:IsMage()
    return wow.UnitClass(self.ObjectTag) == "Mage"
end

function Unit:IsCasting()
    return lb.UnitCastingInfo(self.ObjectTag) ~= 0
end

function Unit:IsDeadOrGhost()
    return UnitIsDeadOrGhost(self.ObjectTag)
end

function Unit:IsDrinking()
    return wow.HasAura(self.ObjectTag, "Drink")
end

function Unit:IsEating()
    return wow.HasAura(self.ObjectTag, "Food")
end

function Unit:IsInCombat()
    return wow.UnitAffectingCombat(self.ObjectTag)
end

function Unit:IsDead()
    return UnitIsDead(self.ObjectTag)
end

-- 百分比
function Unit:Health()
    return 100 * UnitHealth(self.ObjectTag) / UnitHealthMax(self.ObjectTag)
end

-- 百分比
function Unit:Power()
    return 100 * UnitPower(self.ObjectTag) / UnitPowerMax(self.ObjectTag)
end

function Unit:HasAura(aura)
    wow.HasAura(self.ObjectTag, aura)
end
