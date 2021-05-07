-- region btree
local function CreateBt_Sell()
    local btree = BT.BTree:New(nil, 'Sell')
    local seqSell = BT.Sequence:New('sequence to sell')
    local selectCamp = BT.SelectCamp:New('select camp')
    local moveToCamp = BT.MoveToPosition:New('move to camp', selectCamp.CampPosition)
    local findSeller = BT.FindSeller:New('find seller')
    local moveToSeller = BT.MoveToObject:New('move to seller', Target)
    local interact = BT.Interact:New('interact with seller')
    local sell = BT.Sell:New('sell')
    btree:AddRoot(seqSell)
    seqSell:AddChildList(
        {selectCamp, moveToCamp, findSeller, moveToSeller, interact, BT.Wait:New('wait after interact', 1), sell}
    )
    return btree
end

local function CreateBt_Buy()
    local btree = BT.BTree:New(nil, 'Lynx')
    local seqBuy = BT.Sequence:New('sequence buy')
    local selectMerchant = BT.SelectMerchant:New('select merchant')
    local move = BT.MoveToPosition:New('move')
    local target = BT.Target:New('target')
    local wait1 = BT.Wait:New('wait_after_target', 1)
    local interact = BT.Interact:New('interact')
    local wait2 = BT.Wait:New('wait_after_interact', 1)
    local buy = BT.Buy:New('buy')
    btree:AddRoot(seqBuy)
    seqBuy:AddChildList(
        {
            selectMerchant,
            move,
            target,
            wait1,
            interact,
            wait2,
            buy
        }
    )
    return btree
end

local function CreateBt_AttactMonster()
    local btree = BT.BTree:New(nil, 'monster bt')
    local attackNode = BT.Sequence:New('attack node')
    local findMonster = BT.FindMonster:New('find monster')
    local moveToMonster = BT.MoveToObject:New('move to monster', findMonster.Monster)   -- object
    local targetMonster = BT.Target:New('target monster', findMonster.Monster)  -- object or guid?
    local attackMonster = BT.RougeAttack:New('attack monster', findMonster.Monster) -- object or guid?
    btree:AddRoot(attackNode)
    attackNode:AddChildList(
        {
            findMonster,
            moveToMonster,
            targetMonster,
            attackMonster
        }
    )
    return btree
end

local function CreateBt_Herb()
    -- 攻击
    local attackNode = BT.Sequence:New('attack node')
    attackNode:SetAbortType(BT.EAbortType.LowerPriority)
    attackNode:AddChildList({BT.IsAttacked:New('attacked', true), BT.MageAttack:New('attack')})

    -- 采集
    local herbNode = BT.Sequence:New('herb node')
    herbNode:AddChildList(
        {
            BT.FindHerb:New('find herb'),
            BT.MoveToPosition:New('move to herb'),
            BT.Wait:New('wait after move', 0.1),
            BT.GatherHerb:New('gather herb')
        }
    )

    -- root
    local root = BT.Selector:New('root')
    root:AddChildList({attackNode, herbNode})

    -- tree
    local btree = BT.BTree:New(nil, 'herb bt')
    btree:AddRoot(root)
    return btree
end

local function CreateBt_Attack()
    local root = BT.Sequence:New('attack root')
    root:AddChildList({BT.MageAttack:New('attack mob')})
    local btree = BT.BTree:New(nil, 'herb bt')
    btree:AddRoot(root)
    return btree
end

-- endregion btree

-- region onUpdate
local _frame = wow.CreateFrame('Frame')
_frame.elapsed = 1

local PULSE_DELAY = 0.1
local START_DELAY = 0.0
local _lastPulseTime = wow.GetTime() + START_DELAY
local _nextPulseTime = _lastPulseTime + PULSE_DELAY

local function ReadyToPulse()
    local timeNow = wow.GetTime()
    if timeNow < _nextPulseTime then
        return false
    end
    _lastPulseTime = timeNow
    _nextPulseTime = _lastPulseTime + PULSE_DELAY
    return true
end

local function onUpdate(...)
    if not ReadyToPulse() then
        return
    end

    if _bt:Update() ~= BT.ETaskStatus.Running then
        Log.Debug('Lynx stop!')
        _bt:DisabledBT()
        _frame:SetScript('OnUpdate', nil)
    end
end
-- endregion onUpdate

-- region 插件命令
SLASH_LYNX_START1 = '/lynx-start'
SLASH_LYNX_STOP1 = '/lynx-stop'
SLASH_LYNX_SELL_START1 = '/lynx-sell-start'
SLASH_LYNX_SELL_STOP1 = '/lynx-sell-stop'
SLASH_LYNX_ATTACK_START1 = '/lynx-attack-start'
SLASH_LYNX_ATTACK_STOP1 = '/lynx-attack-stop'

SlashCmdList['LYNX_SELL_START'] = function()
    Log.Debug('Lynx sell start!')
    _bt = CreateBt_Sell()
    _bt:EnabledBT()
    _frame:SetScript('OnUpdate', onUpdate)
end

SlashCmdList['LYNX_SELL_STOP'] = function()
    Log.Debug('Lynx sell stop!')
    _bt:DisabledBT()
    _frame:SetScript('OnUpdate', nil)
end

SlashCmdList['LYNX_ATTACK_START'] = function()
    Log.Debug('Lynx attack start!')
    _bt = CreateBt_AttactMonster()
    _bt:EnabledBT()
    _frame:SetScript('OnUpdate', onUpdate)
end

SlashCmdList['LYNX_ATTACK_STOP'] = function()
    Log.Debug('Lynx attack stop!')
    _bt:DisabledBT()
    _frame:SetScript('OnUpdate', nil)
end
-- endregion 插件命令
