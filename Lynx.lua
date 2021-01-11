SLASH_LYNX_TEST_AAA1 = '/lynx-test-aaa'
SLASH_LYNX_START1 = "/lynx-start"
SLASH_LYNX_STOP1 = "/lynx-stop"

SlashCmdList['LYNX_TEST_AAA'] = function()
    Test:Run()
end

Test = {}
local this = Test

function Test:Run()
    local bt = this:CreateLynx()
    bt:EnabledBT()
    for i = 1, 10000 do
        Log.WriteLine('Update ' .. i)
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

Frame = wow.CreateFrame("Frame")
Frame.elapsed = 1

PULSE_DELAY = 0.25
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

local bt = this:CreateLynx()
bt:EnabledBT()

local function onUpdate(...)
    if not ReadyToPulse() then    -- every 249 ms
        return
    end

    if bt:Update() ~= BT.ETaskStatus.Running then
        Log.WriteLine("Lynx stop!")
        Frame:SetScript("OnUpdate", nil)
    end
end

SlashCmdList["LYNX_START"] = function()
    bt:RestartBT()
    Log.WriteLine("Lynx start!")
    Frame:SetScript("OnUpdate", onUpdate)
end

SlashCmdList["LYNX_STOP"] = function()
    Log.WriteLine("Lynx stop!")
    Frame:SetScript("OnUpdate", nil)
end