Test = {}
local this = Test

function Test:Run()
    local bt = this:CreateLynx()
    bt:EnabledBT()
    local status
    repeat
        status = bt:Update()
    until status ~= BT.ETaskStatus.Running
end

function Test:CreateLynx()
    local btree = BT.BTree:New(nil, "Lynx")
    local seq1001 = BT.Sequence:New("seq1001")
    btree:AddRoot(seq1001)

    local attack = BT.Attack:New("attack")
    seq1001:AddChildList{attack}

    return btree
end

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

local bt = this:CreateLynx()
bt:EnabledBT()

local function onUpdate(...)
    if not ReadyToPulse() then
        return
    end

    if bt:Update() ~= BT.ETaskStatus.Running then
        Log.WriteLine("Lynx stop!")
        Frame:SetScript("OnUpdate", nil)
    end
end

-- region 插件命令
SLASH_LYNX_TEST_AAA1 = '/lynx-test-aaa'
SLASH_LYNX_START1 = "/lynx-start"
SLASH_LYNX_STOP1 = "/lynx-stop"

SlashCmdList['LYNX_TEST_AAA'] = function()
    Test:Run()
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
-- endregion