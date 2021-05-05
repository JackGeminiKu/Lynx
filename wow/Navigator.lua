Navigator = {}

local function LogDebug(formatstring, ...)
    local message = "<navigator> " .. string.format(formatstring, ...)
    Log.Debug(message)
end

-- region Nav api
function Navigator.MoveTo(...)
    local x, y, z
    if select('#', ...) == 3 then
        x, y, z = ...
    else
        local point = ...
        if point.X ~= nil then
            x = point.X
            y = point.Y
            z = point.Z
        else
            x = point[1]
            y = point[2]
            z = point[3]
        end
    end
    local pos = Player:Position()
    LogDebug('Current position: ' .. pos.X .. ', ' .. pos.Y .. ', ' .. pos.Z)
    LogDebug('Move to: ' .. x .. ', ' .. y .. ', ' .. z)
    wow.MoveTo(x, y, z)
end

function Navigator.SavePosition()
    local x, y, z = Player:Position()
    LogDebug("Current Position: %f, %f, %f", x, y, z)
end

function Navigator.GetWaypoints(position)
    local waypoints = wow.GetWaypoints(position.X, position.Y, position.Z)
    local i, j = 1, #waypoints
    while i < j do
        waypoints[i], waypoints[j] = waypoints[j], waypoints[i]
        i = i + 1
        j = j - 1
    end
    return waypoints
end

function Navigator.HasBarrier(position1, position2)
    local x1, y1, z1 = position1.X, position1.Y, position1.Z
    local x2, y2, z2 = position2.X, position2.Y, position2.Z
    return wow.Raycast(x1, y1, z1 + 2.5, x2, y2, z2 + 2.5, wow.bit.bor(0x10, 0x100)) ~= nil
end

function Navigator.ComparePoint(point1, point2)
    return point1.X == point2.X and point1.Y == point2.Y and point1.Z == point2.Z
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

local function MoveToLocation(position)
    LogDebug("Initialize waypoints")
    LogDebug('Target position: ' .. position.X .. ', ' .. position.Y .. ', ' .. position.Z)

    _waypoints = Navigator.GetWaypoints(position)
    LogDebug("Mesh waypoints")
    for k, v in pairs(_waypoints) do
        LogDebug(k .. ': ' .. v.X .. ', ' .. v.Y .. ', ' .. v.Z)
    end

    LogDebug("New waypoints")
    for k, v in pairs(_waypoints) do
        local rnd = math.random(-100, 100) / 100
        v.X = v.X + rnd
        v.Y = v.Y + rnd
        v.Z = v.Z + rnd
        LogDebug(k .. ': ' .. v.X .. ', ' .. v.Y .. ', ' .. v.Z)
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
        LogDebug('Loading Navigation...')
        lb.LoadScript('TypescriptNavigator')
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

    local dist = Player:DistanceTo(NextWaypoint())
    LogDebug(dist, wow.GetTime() - _lastMoveTime, math.abs(_lastDistance - dist), #_waypoints)
    -- LogDebug(dist)
    if dist < _proximityTolerance then
        DeleteWaypoint()
        if NextWaypoint() ~= nil then
            _lastMoveTime = wow.GetTime()
            Navigator.MoveTo(NextWaypoint())
        end
    else
        if wow.GetTime() - _lastMoveTime > 1 and math.abs(_lastDistance - dist) < 0.1 and NextWaypoint() ~= nil then
            LogDebug('Stuck!!!')
            Player:Jump()

            -- local waypoints = Navigator.GetWaypoints(NextWaypoint())
            -- for i = 1, #waypoints do
            --     LogDebug('Insert points: ', waypoints[i].X, waypoints[i].Y, waypoints[i].Z)
            --     _waypoints[#_waypoints + 1] = waypoints[i]
            -- end

            Navigator.MoveTo(NextWaypoint())
            _lastMoveTime = wow.GetTime()
        end
    end

    _lastDistance = Player:DistanceTo(NextWaypoint())
end)
