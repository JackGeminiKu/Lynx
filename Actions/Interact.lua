BT.Interact = {
    base = BT.Action
}

local this = BT.Interact
this.__index = this
setmetatable(this, this.base)

function BT.Interact:New(name)
    local o = self.base:New(name)
    setmetatable(o, this)
    o.target = nil
    return o
end

function BT.Interact:OnStart()
    self.target = self.bTree.sharedData:GetData('target').value
end

function BT.Interact:OnUpdate()
    Player.Interact(self.target)
    return BT.ETaskStatus.Success
end