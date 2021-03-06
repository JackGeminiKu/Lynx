local PROXIMITY_TOLERANCE = 2
local STUCK_TOLERANCE = 0.1

BT.MoveToPosition = {
    Base = BT.Action
}
local this = BT.MoveToPosition
this.__index = this
setmetatable(this, this.Base)

function BT.MoveToPosition:New(name, position)
    local o = this.base:New(name)
    setmetatable(o, this)
    o.Position = position
    o.waypoints = nil
    o.lastLocation = nil
    return o
end

function BT.MoveToPosition:OnStart()
    local dest = self.Position-- self.bTree.sharedData:GetData('destination').value
    self:LogDebug("目的地: %.3f, %.3f, %.3f", dest.X, dest.Y, dest.Z)

    self:LogDebug("Mesh waypoints")
    self.waypoints = Navigator.GetWaypoints(dest)
    for k, w in pairs(self.waypoints) do
        self:LogDebug(k .. ': ' .. w.X .. ', ' .. w.Y .. ', ' .. w.Z)
    end

    self:LogDebug("New waypoints")
    for k, w in pairs(self.waypoints) do
        local rnd = math.random(-100, 100) / 100
        w.X = w.X + rnd
        w.Y = w.Y + rnd
        w.Z = w.Z + rnd
        self:LogDebug(k .. ': ' .. w.X .. ', ' .. w.Y .. ', ' .. w.Z)
    end
end

function BT.MoveToPosition:OnUpdate()
    -- if not IsNavigationReady() then
    --     return
    -- end

    if self:IsFinished() then
        return BT.ETaskStatus.Success
    end

    local dist = Player:DistanceTo(self:NextWaypoint())
    if dist < PROXIMITY_TOLERANCE then
        self:DeleteLastWaypoint()
        if self:NextWaypoint() ~= nil then
            Navigator.MoveTo(self:NextWaypoint())   -- 移动到下一点
        end
    else
        if self:Stucked() then
            self:LogDebug('Stuck!!!')
            Player:Jump()

            local waypoints = Navigator.GetWaypoints(self:NextWaypoint())
            for i = 1, #waypoints do
                self:LogDebug('Insert points: ', waypoints[i].X, waypoints[i].Y, waypoints[i].Z)
                self.waypoints[#self.waypoints + 1] = waypoints[i]
            end

            Navigator.MoveTo(self:NextWaypoint())    -- 移动到下一点
        end

        self.lastLocation = Player:Position()
    end

    return BT.ETaskStatus.Running
end

function BT.MoveToPosition:IsFinished()
    return #self.waypoints == 0
end

function BT.MoveToPosition:NextWaypoint()
    if #self.waypoints == 0 then
        return nil
    end
    return self.waypoints[#self.waypoints]
end

function BT.MoveToPosition:DeleteLastWaypoint()
    if #self.waypoints ~= 0 then
        self.waypoints[#self.waypoints] = nil
    end
end

function BT.MoveToPosition:Stucked()
    if self.lastLocation == nil then
        return false
    else
        local currentLocation = Player:Position()
        if math.abs(currentLocation.X - self.lastLocation.X) < STUCK_TOLERANCE and
            math.abs(currentLocation.Y - self.lastLocation.Y) < STUCK_TOLERANCE and
            math.abs(currentLocation.Z - self.lastLocation.Z) < STUCK_TOLERANCE then
            return true
        else
            return false
        end
    end
end
