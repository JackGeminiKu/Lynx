BT.Interact = {
    this = BT.base
}

local this = BT.Interact
this.__index = this
setmetatable(this, this.base)

function BT.Interact:New(name)
    local o = this.base:New(name)
    setmetatable(o, this)
    return o
end

function BT.Interact:OnUpdate(name)
    wow.InteractUnit("target")
    return BT.ETaskStatus.Success
end