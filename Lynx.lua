SLASH_LYNX_TEST1 = '/lynx-test'

_waypoints = nil 
_nextIndex = nil

SlashCmdList['LYNX_TEST'] = function()
    if lb.Navigator == nil then
        lb.LoadScript('TypescriptNavigator')
        return
    end
    wow.Log("Initialize waypoints")
    local x, y, z = Player:Position()
    wow.Log('Player position: ' .. x .. ', ' .. y .. ', ' .. z)
    _waypoints = lb.NavMgr_MoveTo(wow.GetObjectPosition("target"))
    for k, v in pairs(_waypoints) do
        wow.Log(k .. ': ' .. v.x .. ', ' .. v.y .. ', ' .. v.z)
    end
    _nextIndex = nil
end

function NextWaypoint()
    return _waypoints[_nextIndex]
end

local _updateCount = 0
Frame = wow.CreateFrame("Frame")
Frame:SetScript("OnUpdate", function()
    _updateCount = _updateCount + 1
    if _updateCount % 10 ~= 0 then
        return
    end
    if _waypoints == nil then
        return
    end

    if _nextIndex == nil then
        _nextIndex = 1
        Player.MoveTo(_waypoints[1])
        return
    else
        local dist = Player:DistanceFrom(NextWaypoint().x, NextWaypoint().y, NextWaypoint().z)
        print('dist = ' .. dist,  _nextIndex .. ' / '.. #_waypoints)
        if dist < 0.01 then
            if _nextIndex < #_waypoints then
                _nextIndex = _nextIndex + 1
                Player.MoveTo(NextWaypoint())
                -- player.MoveTo(NextWaypoint())
            else
                print(wow.GetTime() .. ": finished!") 
            end
        else
            print(wow.GetTime() .. ': moving')
        end
    end
end)

LibDraw = LibStub("LibDraw-1.0")
LibDraw.Sync(function()
    if _waypoints == nil then

    end

    if dz == nil or dy == nil or dz == nil then
        return
    end

    -- lb.Navigator.MoveTo(dx, dy, dz, 1, 2)
    local waypoints = lb.NavMgr_MoveTo(dx, dy, dz)
    print(wow.GetTime() .. ': ' .. lb.NavMgr_GetPathIndex() .. ' / ' .. #waypoints)
    -- print(wow.GetTime(), lb.NavMgr_GetPathIndex() .. ' / ' .. #waypoints)

    for i = 1, #waypoints - 1 do
        local point = waypoints[i]
        nextPoint = waypoints[i + 1]
        LibDraw.Circle(point.x, point.y, point.z, 0.3)
        LibDraw.Line(point.x, point.y, point.z, nextPoint.x, nextPoint.y, nextPoint.z)
    end
    LibDraw.Circle(nextPoint.x, nextPoint.y, nextPoint.z, 0.3)
end)

LibDraw.Enable(0)
