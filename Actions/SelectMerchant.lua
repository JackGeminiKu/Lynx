BT.SelectMerchant = {
    base = BT.Action
}

local this = BT.SelectMerchant
this.__index = this
setmetatable(this, this.base)

function BT.SelectMerchant:New(name)
    local o = this.base:New(name)
    setmetatable(o, this)
    o.destination = nil
    o.target = nil
    return o
end

function BT.SelectMerchant:OnStart()
    self.destination = self.bTree.sharedData:GetData('destination')
    self.target = self.bTree.sharedData:GetData('target')
end

function BT.SelectMerchant:OnUpdate()
    local x = -10659.661132812
    local y = 1000.5242919922
    local z = 32.876110076904
    Log.WriteLine(string.format("Set destination: %d, %d, %d", x, y, z))
    self.destination.val = {x = x, y = y, z = z}
    self.target.val = 'Creature-0-3045-0-55-843-000015775A'
    return BT.ETaskStatus.Success
end
