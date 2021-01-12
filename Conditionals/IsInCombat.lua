BT.IsInCombat = {
    base = BT.Conditional
}
local this = BT.IsInCombat

this.__index = this
setmetatable(this, this.base)

function BT.IsInCombat:New(name, inCombat)
    local o = this.base:New(name)
    o.inCombat = inCombat
    setmetatable(o, this)
    return o
end

function BT.IsInCombat:OnUpdate()
    if Player:IsInCombat() == self.inCombat then
        return BT.ETaskStatus.Success
    else
        return BT.ETaskStatus.Failure
    end
end