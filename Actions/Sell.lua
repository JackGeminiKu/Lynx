BT.Sell = {
    base = BT.Task
}
local this = BT.Sell
this.__index = this
setmetatable(this, this.base)

function BT.Sell:New(name)
    local o = self.base:New(name)
    o.itemsToSell = {}
    o.sellTime = nil
    setmetatable(o, this)
    return o
end

function BT.Sell:OnStart()
    self.sellTime = GetNextSellTime()
    -- table.insert(self.itemsToSell, {Bag = 0, Slot = 1})
    -- table.insert(self.itemsToSell, {Bag = 0, Slot = 2})
    -- table.insert(self.itemsToSell, {Bag = 0, Slot = 3})
    for bag = 0, 4 do
        for slot = 1, Bag.GetNumSlots(bag) do
            if CanBeSold(bag, slot) then
                table.insert(self.itemsToSell, {Bag = bag, Slot = slot})
            end
        end
    end
end

function BT.Sell:OnUpdate()
    if #self.itemsToSell == 0 then
        return BT.ETaskStatus.Success
    end

    if wow.GetTime() > self.sellTime then
        local lastItem = self.itemsToSell[#self.itemsToSell]
        Bag.SellItem(lastItem.Bag, lastItem.Slot)
        table.remove(self.itemsToSell)
        self.sellTime = GetNextSellTime()
    end
    return BT.ETaskStatus.Running
end

-- 哪些东西不卖?
-- 绿色以上品质的
-- 采集的物品: 草药, 矿石, 皮
local _whitelist = {'矿工锄', '初级治疗药水', '亚麻布', '亚麻绷带'}

CanBeSold = function(bag, slot)
    local _, _, _, quality, _, _, itemLink = wow.GetContainerItemInfo(bag, slot)
    if itemLink == nil then  -- 没有物品
        return false
    end
    local name, _, _, _, _, _, _, _ = wow.GetItemInfo(itemLink)
    for k, v in ipairs(_whitelist) do
        if name == v then
            return false
        end
    end
    return quality <= 1
end

GetNextSellTime = function()
    return wow.GetTime() + math.random(1000, 2000) / 10000
end
