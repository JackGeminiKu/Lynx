BT.IsAttacked = {
    base = BT.Conditional
}
local this = BT.IsAttacked

this.__index = this
setmetatable(this, this.base)

function BT.IsAttacked:New(name, inCombat)
    local o = this.base:New(name)
    o.inCombat = inCombat
    setmetatable(o, this)
    return o
end

function BT.IsAttacked:OnUpdate()
    if Player:IsInCombat() and Player:HasTarget() then
        return BT.ETaskStatus.Success
    else
        return BT.ETaskStatus.Failure
    end
end