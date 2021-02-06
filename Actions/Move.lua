local PROXIMITY_TOLERANCE = 2
local STUCK_TOLERANCE = 0.1

BT.Move = {
    Base = BT.Action
}
local this = BT.Move
this.__index = this
setmetatable(this, this.Base)

function BT.Move:New(name)
    local o = this.base:New(name)
    setmetatable(o, this)
    o.waypoints = nil 
    o.lastLocation = nil
    return o
end

function BT.Move:OnStart()
    local dest = self.bTree.sharedData:GetData('destination').value
    Log.Debug(string.format('Get destination: %d, %d, %d', dest.x, dest.y, dest.z))

    self.waypoints = Navigator.GetWaypoints(dest.x, dest.y, dest.z)
    Log.Debug("Mesh waypoints")
    for k, w in pairs(self.waypoints) do
        Log.Debug(k .. ': ' .. w.x .. ', ' .. w.y .. ', ' .. w.z)
    end

    Log.Debug("New waypoints")
    for k, w in pairs(self.waypoints) do
        local rnd = math.random(-100, 100) / 100
        w.x = w.x + rnd
        w.y = w.y + rnd
        w.z = w.z + rnd
        Log.Debug(k .. ': ' .. w.x .. ', ' .. w.y .. ', ' .. w.z)
    end
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
        self:DeleteLastWaypoint()
        if self:NextWaypoint() ~= nil then
            Navigator.MoveTo(self:NextWaypoint())
        end
    else
        if self:IsStucked() then
            Log.Debug('Stuck!!!')
            Player:Jump()

            local waypoints = Navigator.GetWaypoints(self:NextWaypoint().x, self:NextWaypoint().y, self:NextWaypoint().z)
            for i = 1, #waypoints do
                Log.Debug('Insert points: ', waypoints[i].x, waypoints[i].y, waypoints[i].z)
                self.waypoints[#self.waypoints + 1] = waypoints[i]
            end

            Navigator.MoveTo(self:NextWaypoint())
        end

        self.lastLocation = Player:Location()
    end

    return BT.ETaskStatus.Running
end

function BT.Move:IsFinished()
    return #self.waypoints == 0
end

function BT.Move:NextWaypoint()
    if #self.waypoints == 0 then
        return nil
    end
    return self.waypoints[#self.waypoints]
end

function BT.Move:DeleteLastWaypoint()
    if #self.waypoints ~= 0 then
        self.waypoints[#self.waypoints] = nil
    end
end

function BT.Move:IsStucked()
    if self.lastLocation == nil then
        return false
    else
        local currentLocation = Player:Location()
        if math.abs(currentLocation.x - self.lastLocation.x) < STUCK_TOLERANCE and
            math.abs(currentLocation.y - self.lastLocation.y) < STUCK_TOLERANCE and
            math.abs(currentLocation.z - self.lastLocation.z) < STUCK_TOLERANCE then
            return true
        else
            return false
        end
    end
end
