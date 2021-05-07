local PROXIMITY_TOLERANCE = 2
local STUCK_TOLERANCE = 0.1

BT.MoveToObject = {
    base = BT.Action
}

local this = BT.MoveToObject
this.__index = this
setmetatable(this, this.base)

function BT.MoveToObject:New(name, object)
    local o = this.base:New(name)
    setmetatable(o, this)
    o.Target = object
    o.lastTime = nil
    o.lastPosition = nil
    o.nextWaypoint = nil
    return o
end

function BT.MoveToObject:OnStart()
    self.lastTime = wow.GetTime()
    self.lastPosition = Player:Position()
    self.nextWaypoint = nil
end

function BT.MoveToObject:OnUpdate()
    -- 跑到目标附近了?
    if self:CloseToTarget(self.Target:Position()) then
        Player.StopMove()
        return BT.ETaskStatus.Success
    end

    -- 卡住了？
    if wow.GetTime() - self.lastTime > 0.5 then
        local stucked = self:Stucked(Player:Position(), self.lastPosition)
        self.lastTime = wow.GetTime()
        self:LogDebug('lastTime = %s', self.lastTime)
        self.lastPosition = Player:Position()
        self:LogDebug('lastPosition = %f, %f, %f', self.lastPosition.X, self.lastPosition.Y, self.lastPosition.Z)
        if stucked then
            local facing = Player:Facing()
            local playerPos = Player:Position()
            self:LogDebug('Stuck!!!')
            self:LogDebug('Player facing = %f', facing)
            self:LogDebug('Player position = %f, %f, %f', playerPos.X, playerPos.Y, playerPos.Z)
            Player.MoveForwardStart()
            Player:Jump()
            return BT.ETaskStatus.Running
        end
    end

    -- 移动到下一个点
    if self.nextWaypoint == nil then
        self.nextWaypoint = self:GetNextWaypoint(self.Target:Position())
        Navigator.MoveTo(self.nextWaypoint)
        return BT.ETaskStatus.Running
    end

    -- 移动到点位了
    local dist = Player:DistanceTo(self.nextWaypoint)
    self:LogDebug('dist to next = ' .. dist)
    if dist < PROXIMITY_TOLERANCE then -- 移动到下一点
        self.nextWaypoint = nil
    end

    return BT.ETaskStatus.Running
end

function BT.MoveToObject:GetNextWaypoint(targetPosition)
    local waypoints = Navigator.GetWaypoints(targetPosition)
    return waypoints[#waypoints - 1]
end

function BT.MoveToObject:Stucked(currentPosition, lastPosition)
    if
        math.abs(currentPosition.X - lastPosition.X) < STUCK_TOLERANCE and
            math.abs(currentPosition.Y - lastPosition.Y) < STUCK_TOLERANCE and
            math.abs(currentPosition.Z - lastPosition.Z) < STUCK_TOLERANCE
     then
        return true
    else
        return false
    end
end

function BT.MoveToObject:CloseToTarget(targetPosition)
    local dist = Player:DistanceTo(targetPosition)
    self:LogDebug('dist to target = ' .. dist)
    return dist < PROXIMITY_TOLERANCE
end
