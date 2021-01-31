BT.Buy = {
    Base = BT.Action
}
local this = BT.Buy
this.__index = this
setmetatable(this, this.Base)

function BT.Buy:New(name)
    local o = this.Base:New(name)
    o.nextTime = wow.GetTime()
    o.supplyList = {}
    setmetatable(o, this)
    return o
end

function BT.Buy:OnStart()
    -- 计算要买什么东西?
    self.supplyList = GetSupplyList()
end

function BT.Buy:OnUpdate()
    if #self.supplyList == 0 then
        return BT.ETaskStatus.Success
    end

    if wow.GetTime() > self.nextTime then
        -- print("buy: " .. self.supplyList[#self.supplyList])
        Player.Buy(self.supplyList[#self.supplyList])
        self.supplyList[#self.supplyList] = nil
        self.nextTime = wow.GetTime() + math.random(100, 500) / 1000
    end

    return BT.ETaskStatus.Running
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
