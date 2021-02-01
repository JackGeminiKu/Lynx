BT.FindHerb = {
    base = BT.Action
}
local this = BT.FindHerb
this.__index = this
setmetatable(this, this.base)

function BT.FindHerb:New(name)
    local o = self.base:New(name)
    setmetatable(o, this)
    return o
end

function BT.FindHerb:OnUpdate()
    return BT.ETaskStatus.Success
end