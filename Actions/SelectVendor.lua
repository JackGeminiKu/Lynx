BT.SelectVendor = {
    base = Action
}
local this = BT.SelectVendor

this.__index = this
setmetatable(this, this.base)

function BT.SelectVendor:New(name)
    local o = self.base:New(name)
    setmetatable(o, this) 
    o.location = {}
    return o
end

function BT.SelectVendor:OnStart()
    self.location = self.btree.sharedData:GetData("location")
end

function BT.SelectVendor:OnUpdate()
    self.location = {x=1, y = 2, z = 3}
    return BT.ETaskStatus.Success
end