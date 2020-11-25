Object = {}

function Object:New(objectTag)
    return setmetatable({ObjectTag = objectTag}, {__index = self})
end

-- 返回Player的坐标, x, y, z
function Object:Position()
    return lb.ObjectPosition(self.ObjectTag)
end

function Object:DistanceFrom(...)
    local argNumber = select('#', ...)
    if argNumber == 1 then
        return lb.GetDistance3D(self.ObjectTag, dest)
    elseif argNumber == 3 then
        local x, y, z = self:Position()
        return wow.CalculateDistance(x, y, z, ...)
    end
end