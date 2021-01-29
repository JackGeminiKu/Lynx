BT.SelectMerchant = {
    base = BT.Action
}

local this = BT.SelectMerchant
this.__index = this
setmetatable(this, this.base)

function BT.SelectMerchant:New(name)
    local o = self.base:New(name)
    setmetatable(o, this)
    o.destination = nil
    o.target = nil
    return o
end

function BT.SelectMerchant:OnStart()
    self.destination = self.btree.sharedData:GetData('destination')
    self.target = self.btree.sharedData:GetData('target')
end

function BT.SelectMerchant:OnUpdate()
    self.destination = 'x, y, z'
    self.target = 'xxx'
    return BTree.ETaskStatus.Success
end
