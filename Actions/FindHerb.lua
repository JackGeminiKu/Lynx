BT.FindHerb = {
    base = BT.Action
}
local this = BT.FindHerb
this.__index = this
setmetatable(this, this.base)

function BT.FindHerb:New(name)
    local o = self.base:New(name)
    setmetatable(o, this)
    o.herbGuid = nil
    o.destination = nil
    return o
end

function BT.FindHerb:OnStart()
    self.herbGuid = self.bTree.sharedData:GetData("herbGuid")
    self.herbLocation = self.bTree.sharedData:GetData("destination")
end

function BT.FindHerb:OnUpdate()
    self.herbGuid.val = "herb guid"
    self.destination.val = "herb destination"
    return BT.ETaskStatus.Success
end