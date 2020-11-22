LibDraw = LibStub("LibDraw-1.0")

SLASH_LYNX_TEST1 = '/lynx-test'

_waypoints = nil 
_index = 1

SlashCmdList['lynx-test'] = function()
    if _waypoints == nil then
        _waypoints = lb.NavMgr_MoveTo(wow.GetObjectPosition("target"))
        _index = 1
    else

    end
end

_nextPoint = nil

Frame = wow.CreateFrame("Frame")
Frame.SetScript("OnUpdate", function()

end)

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
