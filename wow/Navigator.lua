Navigator = {}

-- region Nav api
function Navigator.MoveTo(...)
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
    Log.Debug('Current position: ' .. px .. ', ' .. py .. ', ' .. pz)
    Log.Debug('Move to: ' .. x .. ', ' .. y .. ', ' .. z)
    wow.MoveTo(x, y, z)
end

function Navigator.SavePosition()
    local x, y, z = Player:Position()
    Log.Debug(string.format("%s: %d, %d, %d", "Current Position", x, y, z))
end

function Navigator.GetWaypoints(x, y, z)
    local waypoints =  wow.NavMgr_MoveTo(x, y, z)
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
    return wow.Raycast(x1, y1, z1 + 2.5, x2, y2, z2 + 2.5, wow.bit.bor(0x10, 0x100)) ~= nil
end

function Navigator.ComparePoint(point1, point2)
    return point1.x == point2.x and point1.y == point2.y and point1.z == point2.z
end
-- endregion



function Navigator.Stop()
    _waypoints = {}
    wow.StopMove()
    wow.Unlock(MoveForwardStart)
    wow.Unlock(MoveForwardStop)
end

-- 地图导航
local _waypoints = {} 

local function MoveToLocation(location)
    Log.Debug("Initialize waypoints")
    Log.Debug('Target position: ' .. location.x .. ', ' .. location.y .. ', ' .. location.z)

    _waypoints = Navigator.GetWaypoints(location.x, location.y, location.z)
    Log.Debug("Mesh waypoints")
    for k, v in pairs(_waypoints) do
        Log.Debug(k .. ': ' .. v.x .. ', ' .. v.y .. ', ' .. v.z)
    end

    Log.Debug("New waypoints")
    for k, v in pairs(_waypoints) do
        local rnd = math.random(-100, 100) / 100
        v.x = v.x + rnd
        v.y = v.y + rnd
        v.z = v.z + rnd
        Log.Debug(k .. ': ' .. v.x .. ', ' .. v.y .. ', ' .. v.z)
    end
end

local function NextWaypoint()
    if #_waypoints == 0 then
        return nil
    end
    return _waypoints[#_waypoints]
end

local _lastUpdateTime = wow.GetTime() 
local _lastMoveTime = 0
local _lastDistance = 0
local _navInitialized = false

local function IsNavigationReady()
    if lb ~= nil and lb.Navigator ~= nil then
        return true
    end
    if lb == nil then
        return false
    end
    if not _navInitialized then
        _navInitialized = true
        Log.Debug('Loading Navigation...')
        wow.LoadScript('TypescriptNavigator')
    end
    return true
end

local Frame = wow.CreateFrame("Frame")
Frame:SetScript("OnUpdate", function()
    if wow.GetTime() - _lastUpdateTime < 0.1 then
        return
    end
    _lastUpdateTime = wow.GetTime()

    if not IsNavigationReady() then
        return
    end

    if NextWaypoint() == nil then
        return
    end

    if Player:IsInCombat() then
        Navigator.Stop()
        Player:Jump()
    end

    local dist = Player:DistanceFrom(NextWaypoint())
    Log.Debug(dist, wow.GetTime() - _lastMoveTime, math.abs(_lastDistance - dist), #_waypoints)
    -- Log.Debug(dist)
    if dist < _proximityTolerance then
        DeleteWaypoint()
        if NextWaypoint() ~= nil then
            _lastMoveTime = wow.GetTime()
            Navigator.MoveTo(NextWaypoint())
        end
    else
        if wow.GetTime() - _lastMoveTime > 1 and math.abs(_lastDistance - dist) < 0.1 and NextWaypoint() ~= nil then
            Log.Debug('Stuck!!!')
            Player:Jump()

            -- local waypoints = Navigator.GetWaypoints(NextWaypoint().x, NextWaypoint().y, NextWaypoint().z)
            -- for i = 1, #waypoints do
            --     Log.Debug('Insert points: ', waypoints[i].x, waypoints[i].y, waypoints[i].z)
            --     _waypoints[#_waypoints + 1] = waypoints[i]
            -- end

            Navigator.MoveTo(NextWaypoint())
            _lastMoveTime = wow.GetTime()
        end
    end

    _lastDistance = Player:DistanceFrom(NextWaypoint())
end)