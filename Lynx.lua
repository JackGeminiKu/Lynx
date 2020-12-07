SLASH_LYNX_TEST_START1 = '/lynx-test-start'
SLASH_LYNX_TEST_END1 = '/lynx-test-end'
SLASH_LYNX_TEST_AAA1 = '/lynx-test-aaa'

_waypoints = {} 

SlashCmdList['LYNX_TEST_AAA'] = function()
    if lb.Navigator == nil then
        lb.LoadScript('TypescriptNavigator')
        return
    end
    local x, y, z = Target:Position()
    Log.WriteLine(x, y, z)
end

SlashCmdList['LYNX_TEST_START'] = function()
    if lb.Navigator == nil then
        lb.LoadScript('TypescriptNavigator')
        return
    end

    Log.WriteLine("\n\nInitialize waypoints")
    x, y, z = -9313.1806640625, 288.41790771484, 70.538162231445
    Log.WriteLine('Target position: ' .. x .. ', ' .. y .. ', ' .. z)

    _waypoints = Navigator.GetWaypoints(x, y, z)
    Log.WriteLine("Mesh waypoints")
    for k, v in pairs(_waypoints) do
        Log.WriteLine(k .. ': ' .. v.x .. ', ' .. v.y .. ', ' .. v.z)
    end

    Log.WriteLine("New waypoints")
    for k, v in pairs(_waypoints) do
        local rnd = math.random(-100, 100) / 100
        v.x = v.x + rnd
        v.y = v.y + rnd
        v.z = v.z + rnd
        Log.WriteLine(k .. ': ' .. v.x .. ', ' .. v.y .. ', ' .. v.z)
    end
end

SlashCmdList['LYNX_TEST_END'] = function()
    if lb.Navigator == nil then
        lb.LoadScript('TypescriptNavigator')
        return
    end

    Log.WriteLine("\n\nInitialize waypoints")
    x, y , z = -9264.478515625, 352.29013061523, 76.694160461426
    Log.WriteLine('Target position: ' .. x .. ', ' .. y .. ', ' .. z)

    _waypoints = Navigator.GetWaypoints(x, y, z)
    Log.WriteLine("Mesh waypoints")
    for k, v in pairs(_waypoints) do
        Log.WriteLine(k .. ': ' .. v.x .. ', ' .. v.y .. ', ' .. v.z)
    end

    Log.WriteLine("New waypoints")
    for k, v in pairs(_waypoints) do
        local rnd = math.random(-100, 100) / 100
        v.x = v.x + rnd
        v.y = v.y + rnd
        v.z = v.z + rnd
        Log.WriteLine(k .. ': ' .. v.x .. ', ' .. v.y .. ', ' .. v.z)
    end
end

function NextWaypoint()
    if #_waypoints == 0 then
        return nil
    end
    return _waypoints[#_waypoints]
end

function DeleteWaypoint()
    if #_waypoints ~= 0 then
        _waypoints[#_waypoints] = nil
    end
end

_lastUpdateTime = 0
_lastMoveTime = 0
_proximityTolerance = 2
local Frame = wow.CreateFrame("Frame")

Frame:SetScript("OnUpdate", function()
    if wow.GetTime() - _lastUpdateTime < 0.1 then
        return
    end

    if NextWaypoint() == nil then
        return
    end

    local dist = Player:DistanceFrom(NextWaypoint())
    if dist < _proximityTolerance then
        DeleteWaypoint()
        if NextWaypoint() ~= nil then
            _lastMoveTime = wow.GetTime()
            Navigator.MoveTo(NextWaypoint())
        end
    else
        if wow.GetTime() - _lastMoveTime > 1 and not Player:IsMoving() and NextWaypoint() ~= nil then
            Log.WriteLine('Stuck!!!')
            local waypoints = Navigator.GetWaypoints(NextWaypoint().x, NextWaypoint().y, NextWaypoint().z)
            for i = 1, #waypoints do
                Log.WriteLine('Insert points: ', waypoints[i].x, waypoints[i].y, waypoints[i].z)
                _waypoints[#_waypoints + 1] = waypoints[i]
            end

            Player:Jump()
            Navigator.MoveTo(NextWaypoint())
            _lastMoveTime = wow.GetTime()
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
