Navigator = {}

Navigator.MoveTo = function(...)
    local x, y, z
    if select('#', ...) == 3 then
        x, y, z = ...
    else
        local point = ...
        if point.x ~= nil then
            x = point.x
            y = point.y
            z = point.z
        else
            x = point[1]
            y = point[2]
            z = point[3]
        end
    end
    local px, py, pz = Player:Position()
    Log.WriteLine('Current position: ' .. x .. ', ' .. y .. ', ' .. z)
    Log.WriteLine('Move to: ' .. x .. ', ' .. y .. ', ' .. z)
    -- lb.Navigator.MoveTo(x, y, z, 1, 2)
    lb.MoveTo(x, y, z)
end

Navigator.Stop = function()
    lb.Navigator.Stop()
end

Navigator.GetWaypoints = function(x, y, z)
    return lb.NavMgr_MoveTo(x, y, z)
end

Navigator.ComparePoint = function(point1, point2)
    return point1.x == point2.x and point1.y == point2.y and point1.z == point2.z
end