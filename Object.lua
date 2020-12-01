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

function Object:Distance()
    return wow.GetDiatance3D(self.ObjectTag, 'player')
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

function Object:HasAura(auraName)
    return wow.HasAura(self.ObjectTag,auraName)
end

function Object:HasDebuff(debuffName)
    return wow.HasDebuff(debuffName, self.ObjectTag)
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
