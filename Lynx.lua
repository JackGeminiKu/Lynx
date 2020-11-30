SLASH_LYNX_TEST1 = '/lynx-test'
SLASH_LYNX_TEST_MS1 = '/lynx-test-ms'

_waypoints = nil 
_nextIndex = nil

SlashCmdList['LYNX_TEST_MS'] = function()
    if lb.Navigator == nil then
        lb.LoadScript('TypescriptNavigator')
        return
    end

    Log.WriteLine("\n\nInitialize waypoints")
    x, y , z = 2305.9111328125, 265.16384887695, 38.669979095459
    Log.WriteLine('Target position: ' .. x .. ', ' .. y .. ', ' .. z)

    _waypoints = Navigator.GetWaypoints(x, y, z)
    for k, v in pairs(_waypoints) do
        Log.WriteLine(k .. ': ' .. v.x .. ', ' .. v.y .. ', ' .. v.z)
    end
    _nextIndex = nil
end

SlashCmdList['LYNX_TEST'] = function()
    if lb.Navigator == nil then
        lb.LoadScript('TypescriptNavigator')
        return
    end

    Log.WriteLine("\n\nInitialize waypoints")
    x, y, z = 2252.7019042969, 251.92225646973, 41.114749908447
    Log.WriteLine('Target position: ' .. x .. ', ' .. y .. ', ' .. z)

    _waypoints = Navigator.GetWaypoints(x, y, z)
    for k, v in pairs(_waypoints) do
        Log.WriteLine(k .. ': ' .. v.x .. ', ' .. v.y .. ', ' .. v.z)
    end
    _nextIndex = nil
end

function NextWaypoint()
    return _waypoints[_nextIndex]
end

_updateCount = 0
_lastUpdateTime = 0
_startMoveTime = 0
local Frame = wow.CreateFrame("Frame")
Frame:SetScript("OnUpdate", function()
    if wow.GetTime() - _lastUpdateTime < 0.001 then
        return
    end
    _lastUpdateTime = wow.GetTime()

    if _waypoints == nil then
        return
    end

    -- local x, y, z = Player:Position()
    -- local x2, y2, z2 = lb.NavMgr_GetRandomPointInCircle(x, y, z, 9, 10)
    -- if _points == nil then
    --     _points = {}
    --     _points[1] = {x = x2, y = y2, z = z2}
    -- else
    --     local found = false
    --     for k, v in pairs(_points) do
    --         if Navigator.ComparePoint({x = x2, y = y2, z = z2}, v) then
    --             found = true
    --             break
    --         end
    --     end
    --     if not found then
    --         _points[#_points + 1] = {x = x2, y = y2, z = z2}
    --     end
    -- end

    if _nextIndex == nil then
        _nextIndex = 1
        Navigator.MoveTo(NextWaypoint())
        _startMoveTime = wow.GetTime()
        return
    else
        local dist = Player:DistanceFrom(NextWaypoint())
        Log.WriteLine('dist = ' .. dist)
        -- Log.WriteLine('dist = ' .. dist .. ', ' .. _nextIndex .. ' / '.. #_waypoints)
        if dist < math.random(0, 1) then
            if _nextIndex < #_waypoints then
                _nextIndex = _nextIndex + 1
                _startMoveTime = wow.GetTime()
                -- Navigator.MoveTo(NextWaypoint())
                Navigator.MoveTo(NextWaypoint())
            else
                -- Log.WriteLine(wow.GetTime() .. ": finished!") 
            end
        else
            if wow.GetTime() - _startMoveTime > 3 and _nextIndex ~= #_waypoints then
                _startMoveTime = wow.GetTime()
                -- Log.WriteLine('re-move')
                Navigator.MoveTo(NextWaypoint())
            end
            -- Log.WriteLine(wow.GetTime() .. ': moving')
        end
    end
end)

_lastDrawTime = wow.GetTime()
LibDraw = LibStub("LibDraw-1.0")
-- LibDraw.Sync(function()
--     if wow.GetTime() - _lastDrawTime < 0.25 then
--         return
--     end
--     _lastDrawTime = wow.GetTime()
--     if _points == nil then
--         return  
--     end 

--     for k, v in pairs(_points) do
--         LibDraw.Circle(v.x, v.y, v.z, 0.3)
--     end


--     -- if _waypoints == nil then

--     -- end

--     -- if dz == nil or dy == nil or dz == nil then
--     --     return
--     -- end

--     -- -- lb.Navigator.MoveTo(dx, dy, dz, 1, 2)
--     -- local waypoints = Navigator.GetWaypoints(dx, dy, dz)
--     -- print(wow.GetTime() .. ': ' .. lb.NavMgr_GetPathIndex() .. ' / ' .. #waypoints)
--     -- -- print(wow.GetTime(), lb.NavMgr_GetPathIndex() .. ' / ' .. #waypoints)

--     -- for i = 1, #waypoints - 1 do
--     --     local point = waypoints[i]
--     --     nextPoint = waypoints[i + 1]
--     --     LibDraw.Circle(point.x, point.y, point.z, 0.3)
--     --     LibDraw.Line(point.x, point.y, point.z, nextPoint.x, nextPoint.y, nextPoint.z)
--     -- end
--     -- LibDraw.Circle(nextPoint.x, nextPoint.y, nextPoint.z, 0.3)
-- end)

LibDraw.Enable(0)
