Bag = {}

function Bag.GetNumSlots(bag)
    return wow.GetContainerNumSlots(bag)
end

function Bag.GetFreeSlots()
    local freeSlots = 0
    for i = 0, 4 do
        local numberOfFreeSlots, bagType = wow.GetContainerNumFreeSlots(i);
        if bagType == 0 then -- https://wowwiki.fandom.com/wiki/ItemFamily
            freeSlots = freeSlots + wow.GetContainerNumFreeSlots(i)
        end
    end
    return freeSlots
end

function Bag.GetItemLink(bag, slot)
    return wow.GetContainerItemLink(bag, slot)
end

function Bag.GetItemName(bag, slot)
    local link = wow.GetContainerItemLink(bag, slot)
    local name, _, _, _, _, _, _, _ = wow.GetItemInfo(link)
    return name
end

function Bag.GetItemCount(itemName)
    return wow.GetItemCount(itemName)
end

-- 如果找到了物品(第一个), 返回bag, slot; 否则, 返回nil
function Bag.GetItemPosition(...)
    local items = {...}
    for bag = 0, 4 do
        for slot = 0, Bag.GetNumSlots(bag) do
            local name = Bag.GetItemName(bag, slot)
            for i = 1, #items do
                if name == items[i] then
                    return bag, slot
                end
            end
        end
    end
    return nil
end

function Bag.GetItems()
    local items = {}
    for bag = 0, 4 do
        for slot = 0, Bag.GetNumSlots(bag) do
            local name = Bag.GetItemName(bag, slot)
            items[#items + 1] = name
        end
    end
    return items
end

function Bag.GetBandageName()
    for bag = 0, 4 do
        for slot = 0, Bag.GetNumSlots(bag) do
            local itemName = Bag.GetItemName(bag, slot)
            if itemName:find("Bandage") ~= nil then
                return itemName
            end
        end
    end
    return nil
end

function Bag.Found(...)
    local items = {...}
    for bag = 0, 4 do
        for slot = 0, Bag.GetNumSlots(bag) do
            for i = 1, #items do
                if Bag.GetItemName(bag, slot) == items[i] then
                    return true
                end
            end
        end
    end
    return false
end

function Bag.UseItem(bag, slot)
    wow.UseContainerItem(bag, slot)
end

function Bag.SellItem(bag, slot)
    wow.UseContainerItem(bag, slot)
end

function Bag.IsOnCD(bag, slot)
    local startTime, duration, isEnabled = wow.GetContainerItemCooldown(bag, slot)
    return startTime ~= 0
end

function Bag.IsItemUsable(itemName)
    local usable, nomana = wow.IsUsableItem(itemName)
    if not usable or nomana then
        return false
    end
    local bag, slot = Bag.GetItemPosition(itemName)
    if not bag or not slot then
        return false
    end
    return not Bag.IsOnCD(bag, slot)
end

function Bag.DeleteItem(itemName)
    for bag = 0, 4 do
        for slot = 0, Bag.GetNumSlots(bag) do
            if Bag.GetItemName(bag, slot) == itemName then
                Log.Debug('DELETING ' .. itemName .. '!!!')
                wow.PickupContainerItem(bag, slot)
                wow.DeleteCursorItem()
            end
        end
    end
end
