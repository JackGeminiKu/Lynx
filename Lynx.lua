-- region btree
local function CreateLynx()
    local btree = BT.BTree:New(nil, "Lynx")
    local seqBuy = BT.Sequence:New("sequence buy")
    btree:AddRoot(seqBuy)

    local selectMerchant = BT.SelectMerchant:New("select merchant")
    local move = BT.Move:New("move")
    local target = BT.Target:New("target")
    local interact = BT.Interact:New("interact")
    local buy = BT.Buy:New("buy")
    seqBuy:AddChildList{selectMerchant, move, target, interact, buy}
    return btree
end

local bt = CreateLynx()
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
