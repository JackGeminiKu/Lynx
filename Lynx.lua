-- region btree
local function CreateLynx()
    local btree = BT.BTree:New(nil, "Lynx")
    local seq_buy = BT.Sequence:New("sequence buy")
    btree:AddRoot(seq_buy)

    local selectVendor = BT.SelectVendor:New("select vendor")
    local move = BT.Move:New("move")
    local buy = BT.Buy:New("buy")
    seq_buy:AddChildList{selectVendor, move, buy}

    return btree
end
local bt = CreateLynx()
bt:EnabledBT()
-- endregion

-- region onUpdate
Frame = wow.CreateFrame("Frame")
Frame.elapsed = 1

PULSE_DELAY = 0.1
START_DELAY = 0.0
LastPulseTime = wow.GetTime() + START_DELAY
NextPulseTime = LastPulseTime + PULSE_DELAY

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