Navigator = {}

Navigator.Initialize = function()
   lb.LoadScript('TypescriptNavigator')
end

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
    Log.WriteLine('Current position: ' .. px .. ', ' .. py .. ', ' .. pz)
    Log.WriteLine('Move to: ' .. x .. ', ' .. y .. ', ' .. z)
    -- lb.Navigator.MoveTo(x, y, z, 1, 0)
    lb.MoveTo(x, y, z)
end

Navigator.Stop = function()
    lb.Navigator.Stop()
end

Navigator.GetWaypoints = function(x, y, z)
    local waypoints =  lb.NavMgr_MoveTo(x, y, z)
    local i, j = 1, #waypoints
    while i < j do
        waypoints[i], waypoints[j] = waypoints[j], waypoints[i]
        i = i + 1
        j = j - 1
    end
    return waypoints
end

function Navigator.HasBarrier(location1, location2)
    local x1, y1, z1 = location1.x, location1.y, location1.z
    local x2, y2, z2 = location2.x, location2.y, location2.z
    return lb.Raycast(x1, y1, z1 + 2.5, x2, y2, z2 + 2.5, wow.bit.bor(0x10, 0x100)) ~= nil
end

Navigator.ComparePoint = function(point1, point2)
    return point1.x == point2.x and point1.y == point2.y and point1.z == point2.z
end

Navigator.SavePosition = function()
    local x, y, z = Player:Position()
    Log.Write('Current Position: ')
    Log.WriteLine(x, y, z)
end