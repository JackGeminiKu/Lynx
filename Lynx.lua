SLASH_LYNX_TEST_AAA1 = '/lynx-test-aaa'

SlashCmdList['LYNX_TEST_AAA'] = function()
    Test:Run()
end

Test = {}
local this = Test

function Test:Run()
    local bt = this:CreateLynx()
    bt:EnabledBT()
    for i = 1, 100 do
        print('Update ' .. i)
        if bt:Update() ~= BT.ETaskStatus.Running then
            break
        end
    end
end

function Test:CreateLynx()
    local btree = BT.BTree:New(nil, "Lynx")
    local seq1001 = BT.Sequence:New("seq1001")
    btree:AddRoot(seq1001)

    local move = BT.Move:New("move")
    local wait1 = BT.Wait:New("wait1.5", 1.5)
    local buy = BT.Buy:New("buy")
    local wait2 = BT.Wait:New("wait2.5", 2.5)
    seq1001:AddChildList{move, wait1, buy, wait2}

    return btree
end