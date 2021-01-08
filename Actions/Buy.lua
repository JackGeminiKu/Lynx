require("Base/Action")
BT.Buy = {
    Base = BT.Action
}
local this = BT.Buy
this.__index = this
setmetatable(this, this.Base)

function BT.Buy:New(name)
    local o = this.Base:New(name)
    setmetatable(o, this)
    return o
end

function BT.Buy:OnUpdate()
    print('buy')
    return BT.ETaskStatus.Success
end
