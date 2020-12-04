Object = {}

function Object:New(objectTag)
    return setmetatable({ObjectTag = objectTag}, {__index = self})
end

function Object:Id()
    return wow.ObjectId(self.ObjectTag)
end

function Object:Name()
    return wow.ObjectName(self.ObjectTag)
end

function Object:GUID()
    return wow.UnitGUID(self.ObjectTag)
end

function Object:Level()
    return wow.GetUnitLevel(self.ObjectTag)
end

function Object:Position()
    return wow.ObjectPosition(self.ObjectTag)
end

-- 百分比
function Object:Health()
    return 100 * wow.UnitHealth(self.ObjectTag) / wow.UnitHealthMax(self.ObjectTag)
end

-- 百分比
function Object:Power()
    return 100 * wow.UnitPower(self.ObjectTag) / wow.UnitPowerMax(self.ObjectTag)
end

function Object:Distance()
    return wow.GetDiatance3D(self.ObjectTag, 'player')
end

-- 已作废, 请见使用Object:Distance()
function Object:DistanceFrom(...)
    local argNumber = select('#', ...)
    if argNumber == 1 then -- Player, Target ...
        local endObject = ...
        if endObject.x == nil then
            return wow.GetDistance3D(self.ObjectTag, endObject)
        else
            local sx, sy, sz = self:Position()
            return wow.CalculateDistance(sx, sy, sz, endObject.x, endObject.y, endObject.z)
        end
    elseif argNumber == 3 then -- x, y, z
        local x, y, z = self:Position()
        return wow.CalculateDistance(x, y, z, ...)
    end
end

function Object:IsEnemy()
    return wow.UnitIsEnemy(self.ObjectTag)
end

function Object:IsPlayer()
    return wow.UnitIsPlayer(self.ObjectTag)
end

function Object:IsInCombat()
    return wow.UnitAffectingCombat(self.ObjectTag)
end

function Object:IsDead()
    return wow.UnitIsDead(self.ObjectTag)
end

function Object:IsCorpse()
    return wow.UnitIsCorpse(self.ObjectTag)
end

function Object:IsTargeting(target)
    if target == nil then
        return false
    end
    local objectTarget = wow.UnitTarget(self.ObjectTag)
    if objectTarget == nil then
        return false
    end
    return wow.UnitGUID(objectTarget) == wow.UnitGUID(target)
end

function  Object:IsInAggroRange(tol)
    tol = tol or 10 
    if self:IsEnemy() and not self:IsDead() then
        local aggroRad = (self:Level() - Player:Level()) + 20 + tol -- suppost +20 imma to be safe +5
        return  self:Distance() < aggroRad
    end
    return false
end

function Object:IsPet()
    local guid = wow.UnitGUID(self.ObjectTag)
    return string.find(guid, 'pet')
end

function Object:HasAura(auraName)
    return wow.HasAura(self.ObjectTag,auraName)
end

function Object:HasDebuff(debuffName)
    return wow.HasDebuff(debuffName, self.ObjectTag)
end

function Object:HasTarget()
    return wow.UnitTarget(self.ObjectTag)
end

function Object:CanAttack()
    return wow.UnitCanAttack("player", self.ObjectTag)
end

function Object:CanBeLooted()
    return wow.UnitCanBeLooted(self.ObjectTag)
end

function Object:CanBeSkinned()
    return UnitCanBeSkinned(self.ObjectTag)
end

function Object:Count()
    local objects = wow.GetObjects()
    return #objects
end

function Object:Get(index)
    local objects = wow.GetObjects()
    if index > #objects then
        return nil
    end
    return Object:New(objects[index])
    -- return objects[index]
end
