require("Base/Action")
BT.Move = {
    Base = BT.Action
}
local this = BT.Move
this.__index = this
setmetatable(this, this.Base)

function BT.Move:New(name)
    local o = this.base:New(name)
    setmetatable(o, this)
    return o
end

function BT.Move:OnUpdate()
    print('Move')
    return BT.ETaskStatus.Success
end
