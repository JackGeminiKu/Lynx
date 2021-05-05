BT.FindSeller = {
    base = BT.Task
}

local this = BT.FindSeller
this.__index = this
setmetatable(this, this.base)

function BT.FindSeller:New(name)
    local o = this.base:New(name)
    setmetatable(o, this)
    return o
end

function BT.FindSeller:OnStart()
end

function BT.FindSeller:OnUpdate()
    local campName = string.format('%s_%s', wow.GetZoneName(), wow.GetSubZoneName())
    local merchants = Camp[campName].Merchants
    for name, merchant in pairs(merchants) do
        if merchant.CanSell then
            wow.RunMacroText("/target " .. name)
            return BT.ETaskStatus.Success
        end
    end
    return BT.ETaskStatus.Failure
end
