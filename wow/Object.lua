Object = {}

function Object:New(objectTag)
    return setmetatable({ObjectTag = objectTag}, {__index = self})
end

function Object:Id()
    return wow.ObjectId(self.ObjectTag)
end

function Object:Name()
    return wow.GetObjectName(self.ObjectTag)
end

function Object:Guid()
    return wow.UnitGuid(self.ObjectTag)
end

function Object:Level()
    return wow.GetUnitLevel(self.ObjectTag)
end

-- 返回Object的地址 
function Object:Position()
    local x, y, z = wow.GetObjectPosition(self.ObjectTag)
    return {X = x, Y = y, Z = z}
end

function Object:Type()
    return wow.UnitCreatureType(self.ObjectTag)
end

-- 百分比
function Object:Health()
    return 100 * wow.UnitHealth(self.ObjectTag) / wow.UnitHealthMax(self.ObjectTag)
end

-- 百分比
function Object:Power()
    return 100 * wow.UnitPower(self.ObjectTag) / wow.UnitPowerMax(self.ObjectTag)
end

function Object:Speed()
    return wow.GetUnitSpeed(self.ObjectTag)
end

function Object:Facing()
    return wow.GetFacing(self.ObjectTag)
end

-- 获取目标和玩家的距离
function Object:Distance()
    return wow.GetDistanceBetweenObjects(self.ObjectTag, 'player')
end

-- 已作废, 请见使用Object:Distance()
function Object:DistanceTo(...)
    local argNumber = select('#', ...)
    if argNumber == 1 then
        local endObject = ...
        if endObject.X == nil then
            return wow.GetDistanceBetweenObjects(self.ObjectTag, endObject)    -- "target"
        else
            local p = self:Position()
            return wow.CalculateDistance(p.X, p.Y, p.Z, endObject.X, endObject.Y, endObject.Z)    -- {x, y, z}
        end
    elseif argNumber == 3 then
        local x, y, z = self:Position()
        return wow.CalculateDistance(x, y, z, ...)    -- x, y, z
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

function Object:IsHerbalism()
    return wow.GameObjectHasLockType(self.ObjectTag, lb.ElockTypes.IsHerbalism)
end

function Object:IsTargeting(target)
    if target == nil then
        return false
    end
    local objectTarget = wow.GetTarget(self.ObjectTag)
    if objectTarget == nil then
        return false
    end
    return wow.UnitGuid(objectTarget) == wow.UnitGuid(target)
end

function Object:IsInAggroRange(tol)
    tol = tol or 10
    if self:IsEnemy() and not self:IsDead() then
        local aggroRad = (self:Level() - Player:Level()) + 20 + tol -- suppost +20 imma to be safe +5
        return self:Distance() < aggroRad
    end
    return false
end

function Object:IsPet()
    local guid = wow.UnitGuid(self.ObjectTag)
    return string.find(guid, 'pet')
end

function Object:HasAura(auraName)
    return wow.HasAura(self.ObjectTag, auraName)
end

function Object:HasDebuff(debuffName)
    return wow.HasDebuff(debuffName, self.ObjectTag)
end

function Object:GetDebuff(index)
    return wow.UnitDebuff(self.ObjectTag, index)
end

function Object:HasTarget()
    return wow.UnitExists('target')
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

function Object:Count(range)
    local objects = wow.GetObjects(range)
    return #objects
end

function Object:Get(index, range)
    local objects = wow.GetObjects(range)
    if index > #objects then
        return nil
    end
    return Object:New(objects[index])
    -- return objects[index]
end

function Object:GetObjects(range)
    local guids = wow.GetObjects(range)
    local objects = {}
    for i = 1, #guids do
        objects[#objects + 1] = Object:New(guids[i])
    end
    return objects
end

function Object:GetHerbalism(range)
    local guids = wow.GetObjects(range, lb.ELockTypes.Herbalism)
    local herbalism = {}
    for i = 1, #guids do
        herbalism[#herbalism + 1] = Object:New(guids[i])
    end
    return herbalism
end

-- _lastDrawTime = wow.GetTime()

-- LibDraw = LibStub("LibDraw-1.0")
-- LibDraw.Sync(function()
--     if wow.GetTime() - _lastDrawTime < 0.01 then
--         return
--     end
--     _lastDrawTime = wow.GetTime()
--     if lb == nil then
--         return  
--     end 

--     for i = 1, Object:Count(100) do
--         local object = Object:Get(i, 100)
--         local x, y, z = object:Position()
--         LibDraw.Circle(x, y, z, 0.3)
--     end

--     -- for k, v in pairs(_points) do
--     --     LibDraw.Circle(v.X, v.Y, v.Z, 0.3)
--     -- end


--     -- if _waypoints == nil then

--     -- end

--     -- if dz == nil or dy == nil or dz == nil then
--     --     return
--     -- end

--     -- -- lb.Navigator.MoveTo(dx, dy, dz, 1, 2)
--     -- local waypoints = Navigator.GetWaypoints({x = dx, y = dy, z = dz})
--     -- print(wow.GetTime() .. ': ' .. lb.NavMgr_GetPathIndex() .. ' / ' .. #waypoints)
--     -- -- print(wow.GetTime(), lb.NavMgr_GetPathIndex() .. ' / ' .. #waypoints)

--     -- for i = 1, #waypoints - 1 do
--     --     local point = waypoints[i]
--     --     nextPoint = waypoints[i + 1]
--     --     LibDraw.Circle(point.X, point.Y, point.Z, 0.3)
--     --     LibDraw.Line(point.X, point.Y, point.Z, nextPoint.X, nextPoint.Y, nextPoint.Z)
--     -- end
--     -- LibDraw.Circle(nextPoint.X, nextPoint.Y, nextPoint.Z, 0.3)
-- end)

-- LibDraw.Enable(0)