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
    Navigator.MoveTo(-9466.423828125, 0.061252001672983, 56.951366424561)
    return BT.ETaskStatus.Success
end
