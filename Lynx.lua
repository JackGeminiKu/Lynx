-- region btree
local function CreateBtBuy()
    local btree = BT.BTree:New(nil, "Lynx")
    local seqBuy = BT.Sequence:New("sequence buy")
    btree:AddRoot(seqBuy)

    local selectMerchant = BT.SelectMerchant:New("select merchant")
    local move = BT.Move:New("move")
    local target = BT.Target:New("target")
    local wait1 = BT.Wait:New("wait_after_target", 1)
    local interact = BT.Interact:New("interact")
    local wait2 = BT.Wait:New("wait_after_interact", 1)
    local buy = BT.Buy:New("buy")
    seqBuy:AddChildList({
        selectMerchant, 
        move, 
        target, 
        wait1, 
        interact, 
        wait2, 
        buy
    })
    -- seqBuy:AddChildList{selectMerchant, move, target, interact, buy}
    return btree
end

local function CreateBtFight()

end

local function CreateBtHerb()
    local seqGather = BT.Sequence:New("sequence gather")
    seqGather:AddChildList({
        BT.GatherHerb:New("gather herb"),
        BT.Wait:New("wait", 2)
    })

    local ufGather = BT.UntilFailure:New("gather until fail")
    ufGather:AddChild(seqGather)

    local invGather = BT.Inverter:New("inverter gather")
    invGather:AddChild(ufGather)

    local seqRoot = BT.Sequence:New("herb root")
    seqRoot:AddChildList({
        BT.FindHerb:New("find herb"),
        BT.Move:New("move to herb"),
        invGather
    })

    local btree = BT.BTree:New(nil, "herb bt")
    btree:AddRoot(seqRoot)
    return btree
end

local _bt = CreateBtHerb()
-- endregion btree

-- region onUpdate
local _frame = wow.CreateFrame("Frame")
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
        Log.WriteLine("Lynx stop!")
        _bt:DisabledBT()
        _frame:SetScript("OnUpdate", nil)
    end
end
-- endregion onUpdate

-- region 插件命令
SLASH_LYNX_START1 = "/lynx-start"
SLASH_LYNX_STOP1 = "/lynx-stop"

SlashCmdList["LYNX_START"] = function()
    Log.WriteLine("Lynx start!")
    _bt:EnabledBT()
    _frame:SetScript("OnUpdate", onUpdate)
end

SlashCmdList["LYNX_STOP"] = function()
    Log.WriteLine("Lynx stop!")
    _bt:DisabledBT()
    _frame:SetScript("OnUpdate", nil)
end
-- endregion 插件命令
