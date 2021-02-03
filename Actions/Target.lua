BT.Target = {
    base = BT.Action
}

local this = BT.Target
this.__index = this
setmetatable(this, this.base)

function BT.Target:New(name)
    local o = self.base:New(name)
    setmetatable(o, this)
    o.target = nil
    return o
end

function BT.Target:OnStart()
    self.target = self.bTree.sharedData:GetData('target').value
end

function BT.Target:OnUpdate()
    Player.Target(self.target)
    if Player:IsTargeting(self.target) then
        return BT.ETaskStatus.Success
    else
        return BT.ETaskStatus.Failure
    end
end
