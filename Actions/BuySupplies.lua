BT.BuySupplies = {
    Base = BT.Action
}
local this = BT.BuySupplies
this.__index = this
setmetatable(this, this.Base)

function BT.BuySupplies:New(name)
    local o = this.Base:New(name)
    o.nextTime = wow.GetTime()
    o.supplyList = {}
    setmetatable(o, this)
    return o
end

function BT.BuySupplies:OnUpdate()
    if #self.supplyList == 0 then
        self.supplyList = GetSupplyList()
    end

    for i = #self.supplyList, 1, -1 do
        if wow.GetTime() > self.nextTime then
            Player.Buy(self.supplyList[i])
            self.supplyList[i] = nil
            self.nexttime = wow.GetTime() + math.random(100, 500) / 1000
        end
    end

    if #self.supplyList == 0 then
        return BT.ETaskStatus.Success
    else
        return BT.ETaskStatus.Running
    end
end

function GetSupplyList()
    -- 不同职业, 不同等级需要的补给的种类, 数量不一样
    -- Food: 
    -- Walter: 
    -- Pet Food: 
    -- Arrow & Bullet: 
    Drinks = {"Conjured Fresh Water", "Conjured Sparkling Water", "Sweet Nectar", "Ice Cold Milk", "Melon Juice"}
    Foods = {"Conjured Muffin", "Conjured Sourdough", "Wild Hog Shank", "Mutton Chop", "Cured Ham Steak"}
    return {1, 2, 3}
end
