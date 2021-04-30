local PROXIMITY_TOLERANCE = 2
local STUCK_TOLERANCE = 0.1

BT.MoveToTarget = {
    base = BT.Action
}

local this = BT.MoveToTarget
this.__index = this
setmetatable(this, this.base)

function BT.MoveToTarget:New(name)
    local o = this.base:New(name)
    setmetatable(o, this)
    o.target = nil
    o.lastLocation = nil
    return o
end

function BT.MoveToTarget:OnStart()
    self.target = self.bTree.sharedData:GetData('target')
end

function BT.MoveToTarget:OnUpdate()
    -- 跑到目标附近了?
    if CloseToTarget(self.target) then
        return BT.ETaskStatus.Success
    end

    local dist = Player:DistanceTo(self:GetNextWaypoint())
    if dist < PROXIMITY_TOLERANCE then -- 移动到下一点
        Navigator.MoveTo(self:GetNextWaypoint())
    else
        if self:Stucked() then
            self:LogDebug('Stuck!!!')
            Player:Jump()
        end

        self.lastLocation = Player:Position()
    end

    return BT.ETaskStatus.Running
end

function BT.MoveToTarget:GetNextWaypoint()
    local waypoints = Navigator.GetWaypoints(self.target:Position())
    return waypoints[#waypoints]
end

function BT.MoveToPosition:Stucked()
    if self.lastLocation == nil then
        return false
    else
        local currentLocation = Player:Position()
        if
            math.abs(currentLocation.x - self.lastLocation.x) < STUCK_TOLERANCE and
                math.abs(currentLocation.y - self.lastLocation.y) < STUCK_TOLERANCE and
                math.abs(currentLocation.z - self.lastLocation.z) < STUCK_TOLERANCE
         then
            return true
        else
            return false
        end
    end
end

function CloseToTarget(target)
    return Player:DistantceTo(target:Position()) < PROXIMITY_TOLERANCE
end
