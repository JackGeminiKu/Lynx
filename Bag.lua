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

function Bag.Find(itemName)
    for bag = 0, 4 do
        for slot = 0, Bag.GetNumSlots(bag) do
            local link = Bag.GetItemLink(bag, slot)
            if link then
                local itemName, _, _, _, _, _, _, _ = wow.GetItemInfo(link)
                if itemName == itemName then
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

function Bag.GetItemCount(itemName)
    return wow.GetItemCount(itemName)
end
