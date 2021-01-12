Merchant = {
    ['map_id_1'] = {
        ['1号商人'] = {x = 1, y = 1, z = 1, sellFood = true, sellDrink = true, canRepair = true},
        ['2号商人'] = {x = 1, y = 1, z = 1, sellFood = true, sellDrink = true, canRepair = true},
    },
    ['map_id_2'] = {
        ['1号商人'] = {x = 1, y = 1, z = 1, sellFood = true, sellDrink = true, canRepair = true},
        ['2号商人'] = {x = 1, y = 1, z = 1, sellFood = true, sellDrink = true, canRepair = true},
    },
}

function Merchant.CanRepair()
    wow.CanMerchantRepair()
end

function Merchant.Repair()
    wow.RepairAllItems()
end
