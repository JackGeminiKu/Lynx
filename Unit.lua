Unit = {}

function Unit:New(unitTag)
    return setmetatable({UnitTag = unitTag}, {__index = self})
end

function Unit:IsMoving()
    return wow.GetUnitSpeed(self.UnitTag) > 0
end

function Unit:Level()
    return UnitLevel(self.UnitTag)
end

-- 返回Player的坐标, x, y, z
function Unit:Position()
    return lb.ObjectPosition(self.UnitTag)
end

function Unit:PositionZ()
    local x, y, z = lb.ObjectPosition(self.UnitTag)
    return z
end

function Unit:DistanceFrom(...)
    local argNumber = select('#', ...)
    if argNumber == 1 then
        return lb.GetDistance3D(self.UnitTag, dest)
    elseif argNumber == 3 then
        local x, y, z = self:Position()
        return wow.CalculateDistance(x, y, z, ...)
    end
end

function Unit:IsHunter()
    return wow.UnitClass(self.UnitTag) == "Hunter"
end

function Unit:IsMage()
    return wow.UnitClass(self.UnitTag) == "Mage"
end

function Unit:IsCasting()
    return lb.UnitCastingInfo(self.UnitTag) ~= 0
end

function Unit:IsDeadOrGhost()
    return UnitIsDeadOrGhost(self.UnitTag)
end

function Unit:IsDrinking()
    return wow.HasAura(self.UnitTag, "Drink")
end

function Unit:IsEating()
    return wow.HasAura(self.UnitTag, "Food")
end

function Unit:IsInCombat()
    return wow.UnitAffectingCombat(self.UnitTag)
end

function Unit:IsDead()
    return UnitIsDead(self.UnitTag)
end

-- 百分比
function Unit:Health()
    return 100 * UnitHealth(self.UnitTag) / UnitHealthMax(self.UnitTag)
end

-- 百分比
function Unit:Power()
    return 100 * UnitPower(self.UnitTag) / UnitPowerMax(self.UnitTag)
end

function Unit:HasAura(aura)
    wow.HasAura(self.UnitTag, aura)
end
