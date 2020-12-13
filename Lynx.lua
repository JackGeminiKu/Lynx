SLASH_LYNX_TEST_AAA1 = '/lynx-test-aaa'

SlashCmdList['LYNX_TEST_AAA'] = function()

end

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
