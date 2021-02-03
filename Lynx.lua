-- region btree
local function CreateLynx()
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

local function CreateHerbBt()
    local seqGather = BT.Sequence:New("sequence gather")
    seqGather:AddChidList({
        BT.GatherHerb:New("gather herb"),
        BT.Wait:New("wait", 2000)
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

local bt = CreateHerbBt()
bt:EnabledBT()
-- endregion

-- region onUpdate
local Frame = wow.CreateFrame("Frame")
Frame.elapsed = 1

local PULSE_DELAY = 0.1
local START_DELAY = 0.0
local LastPulseTime = wow.GetTime() + START_DELAY
local NextPulseTime = LastPulseTime + PULSE_DELAY

local function ReadyToPulse()
    local timeNow = wow.GetTime()
    if timeNow < NextPulseTime then
        return false
    end
    LastPulseTime = timeNow
    NextPulseTime = LastPulseTime + PULSE_DELAY
    return true
end

local function onUpdate(...)
    if not ReadyToPulse() then
        return
    end

    if bt:Update() ~= BT.ETaskStatus.Running then
        Log.WriteLine("Lynx stop!")
        Frame:SetScript("OnUpdate", nil)
    end
end
-- endregion

-- region 插件命令
SLASH_LYNX_START1 = "/lynx-start"
SLASH_LYNX_STOP1 = "/lynx-stop"

SlashCmdList["LYNX_START"] = function()
    bt:RestartBT()
    Log.WriteLine("Lynx start!")
    Frame:SetScript("OnUpdate", onUpdate)
end

SlashCmdList["LYNX_STOP"] = function()
    Log.WriteLine("Lynx stop!")
    Frame:SetScript("OnUpdate", nil)
end
-- endregion
