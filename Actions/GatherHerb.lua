BT.GatherHerb = {
    base = BT.Action
}

local this = BT.GatherHerb
this.__index = this
setmetatable(this, this.base)

function BT.GatherHerb:New(name)
    local o = self.base:New(name)
    setmetatable(o, this)
    return o
end

function BT.GatherHerb:OnUpdate()
    lb.UnitTagHandler(InteractUnit, guid)
    return BT.ETaskStatus.Success
end