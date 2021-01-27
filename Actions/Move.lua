local PROXIMITY_TOLERANCE = 2

BT.Move = {
    Base = BT.Action
}
local this = BT.Move
this.__index = this
setmetatable(this, this.Base)

function BT.Move:New(name)
    local o = this.base:New(name)
    setmetatable(o, this)
    o.location = {}
    o.waypoints = {}
    o.lastMoveTime = 0
    o.lastMoveDistance = 1000
    return o
end

function BT.Move:OnStart()
    local x, y, z = self.btree.sharedData:GetData('destination')
    Log.WriteLine(string.format('Get destination: %d, %d, %d', x, y, z))

    self.waypoints = Navigator.GetWaypoints(x, y, z)
    Log.WriteLine("Mesh waypoints")
    for k, w in pairs(self.waypoints) do
        Log.WriteLine(k .. ': ' .. w.x .. ', ' .. w.y .. ', ' .. w.z)
    end

    Log.WriteLine("New waypoints")
    for k, w in pairs(_waypoints) do
        local rnd = math.random(-100, 100) / 100
        w.x = w.x + rnd
        w.y = w.y + rnd
        w.z = w.z + rnd
        Log.WriteLine(k .. ': ' .. w.x .. ', ' .. w.y .. ', ' .. w.z)
    end
end

function BT.Move:IsFinished()
    return self:NextWaypoint() == nil
end

function BT.Move:NextWaypoint()
    if #self.waypoints == 0 then
        return nil
    end
    return self.waypoints[#self.waypoints]
end

function BT.Move:DeleteCurrentWaypoint()
    if #self.waypoints ~= 0 then
        self.waypoints[#self.waypoints] = nil
    end
end

function BT.Move:MoveTo(x, y, z)
    self.lastMoveTime = wow.GetTime()
    self.lastMoveDistance = Player:DistanceFrom(self:NextWaypoint())
    Navigator.MoveTo(x, y, z)
end

function BT.Move:OnUpdate()
    -- if not IsNavigationReady() then
    --     return
    -- end

    if self:IsFinished() then
        return BT.ETaskStatus.Success
    end

    local dist = Player:DistanceFrom(self:NextWaypoint())
    if dist < PROXIMITY_TOLERANCE then
        self:DeleteWaypoint()
        if self:NextWaypoint() ~= nil then
            self.lastMoveTime = wow.GetTime()
            self.lastMoveDistance = Player:DistanceFrom(self:NextWaypoint())
            Navigator.MoveTo(self:NextWaypoint())
        end
    else
        if wow.GetTime() - self.lastMoveTime > 1 and math.abs(self.lastMoveDistance - dist) < 0.1 then
            Log.WriteLine('Stuck!!!')
            Player:Jump()

            -- local waypoints = Navigator.GetWaypoints(NextWaypoint().x, NextWaypoint().y, NextWaypoint().z)
            -- for i = 1, #waypoints do
            --     Log.WriteLine('Insert points: ', waypoints[i].x, waypoints[i].y, waypoints[i].z)
            --     _waypoints[#_waypoints + 1] = waypoints[i]
            -- end

            self.lastMoveTime = wow.GetTime()
            self.lastMoveDistance = Player:DistanceFrom(self:NextWaypoint())
            Navigator.MoveTo(self:NextWaypoint())
        end
    end

    return BT.ETaskStatus.Running
end
