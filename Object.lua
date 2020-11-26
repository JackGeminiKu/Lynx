Object = {}

function Object:New(objectTag)
    return setmetatable({ObjectTag = objectTag}, {__index = self})
end

function Object:Position()
    return wow.ObjectPosition(self.ObjectTag)
end

function Object:DistanceFrom(...)
    local argNumber = select('#', ...)
    if argNumber == 1 then -- Player, Target ...
        return wow.GetDistance3D(self.ObjectTag, dest)
    elseif argNumber == 3 then -- x, y, z
        local x, y, z = self:Position()
        return wow.CalculateDistance(x, y, z, ...)
    end
end

function Object:Name()
    return wow.ObjectName(self.ObjectTag)
end

function Object:Count()
    local objects = wow.GetObjects()
    return #objects
end

function Object:Get(index)
    local objects = wow.GetObjects()
    return Object:New(objects[index])
    -- return objects[index]
end
