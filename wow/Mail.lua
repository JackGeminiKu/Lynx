local scriptName = 'felwood_54'
local recipient = 'Leblanc'
if Player:Name() == "CURRENT_PLAYER_NAME" then
    recipient = "ACCOUNT_TO_SEND_TO"
end

print('Mailing...')
-- Keep
local PetFood = {"Haunch of Meat", "Big Bear Meat", "Turtle Meat", "Mutton Chop", "Wild Hog Shank", "Red Wolf Meat"}
local Drinks = {"Conjured Sparkling Water", "Sweet Nectar", "Ice Cold Milk", "Melon Juice"}
local Food = {"Conjured Sourdough", "Wild Hog Shank", "Mutton Chop", "Cured Ham Steak"}
local KeptItems = {"Hearthstone", "Brown Horse Bridle", "Skinning Knife", "Strong Fishing Pole", "Fishing Pole", "Rune of Teleportation", "Rune of Portals"}

local _waypoints = {}

local PULSE_DELAY = 0.2
local START_DELAY = 1

local frame = wow.CreateFrame("Frame")
local bRun = true
local _nextPulseTime = (wow.GetTime() + START_DELAY) + PULSE_DELAY

local _pathIndex = 1
local losFlags = wow.bit.bor(0x10, 0x100)
local PROXIMAL_TOLERANCE = 4

local SKIP_FAR_POINTS = false

local rndMax = 1 -- lets be precise for this short path

local function IsAtMailbox()
    local objCount = Object:Count()
    for i = 1, objCount do
        local object = Object:Get(i)
        if object:Name() == "Mailbox" then
            if object:Distance() < 5 then
                return true
            end
        end
    end

    return false
end

local function OpenMailBox()
    local objCount = Object:Count()
    for i = 1, objCount do
        local object = Object:Get(i)
        if object:Name() == "Mailbox" then
            Player.Interact(object)
        end
    end
end

local function Sleep(secs)
    local timeNow = wow.GetTime()
    if _nextPulseTime > timeNow then -- since this func may be used several times in 1 cycle
        local overheadWait = _nextPulseTime - timeNow;
        _nextPulseTime = timeNow + overheadWait + secs
    else
        _nextPulseTime = overheadWait + secs
    end
end

local function ArrayContains(array, value)
    for i = 1, #array do
        if array[i] == value then
            return true
        end
    end
    return false
end

local name = 'alla'
local cTip = wow.CreateFrame("GameTooltip", name .. "Tooltip", nil, "GameTooltipTemplate")

local function IsSoulbound(bag, slot)
    cTip:SetOwner(UIParent, "ANCHOR_NONE")
    cTip:SetBagItem(bag, slot)
    cTip:Show()
    for i = 1, cTip:NumLines() do
        if (_G[name .. "TooltipTextLeft" .. i]:GetText() == ITEM_SOULBOUND) then
            return true
        end
    end
    cTip:Hide()
    return false
end

local function SendMail()
    wow.RunMacroText('/click MailFrameTab2')
    wow.RunMacroText('/run SendMailSubjectEditBox:SetText("Sell")')
    wow.RunMacroText('/run SendMailNameEditBox:SetText("' .. recipient .. '")')

    for b = 0, 4 do
        for s = 0, 36 do
            local l = wow.GetContainerItemLink(b, s)
            if l then
                local sName, sLink, iRarity, iLevel, iMinLevel, sType, sSubType, iStackCount = wow.GetItemInfo(l)
                if not IsSoulbound(b, s) and not ArrayContains(KeptItems, sName) then
                    if Player:IsHunter() and (sType == "Projectile" or ArrayContains(PetFood, sName)) then
                        -- Log.Debug('Keeping [Hunter Stuff]: '..sName)
                    elseif wow.IsRogue() and sName:find("Throwing") ~= nil then
                        -- Log.Debug('Keeping [Rogue Thrown]: '..sName)
                    elseif sSubType == "Bag" or (Player:IsHunter() and (sSubType == "Quiver" or sSubType == "Ammo Pouch")) then
                        -- Bug where last Bag is perceived as item in other bags for selling :/
                    elseif sName:find("Recipe:") == nil and (sName:find("Potion") ~= nil or sName:find("Bandage") ~= nil) then
                        -- Log.Debug('Keeping [Potion/Bandage]: '..sName)
                    elseif ArrayContains(Food, sName) or ArrayContains(Drinks, sName) then
                        -- Log.Debug('Keeping [Food/Drink]: '..sName)
                    else
                        if iRarity >= 1 then
                            Log.Debug('Sending: ' .. l)
                            wow.UseContainerItem(b, s)
                        end
                    end
                else
                    -- Log.Debug('Keeping [Soulbound/ToKeep]: '..sName)
                end
            end
        end
    end

    local name, texture, count, quality = wow.GetSendMailItem(1)
    if name == nil or name == "" then -- if there is not attached mail
        bRun = false
        Log.Debug('Finished Sending Mail')
        wow.RunMacroText('/run SendMailCancelButton:Click()')
        return false
    else
        wow.RunMacroText('/run SendMailMailButton:Click()')
        return true
    end
end

local function TryExit()
    -- Needs to be called within OnUpdate itself
    if AtEndthen then
        bRun = false
    end

    if bRun == false then
        local exitMacro = '.loadfile Lynx.lua'
        Log.Debug("Starting main.lua from mail.lua")
        wow.RunMacroText(exitMacro)
        frame:SetScript("OnUpdate", nil)
    end
end

local function SetIndexToClosest()
    local px, py, pz = Player:Position()
    local closestIndex = 1
    local closestDist = 9999999
    local foundIndex = false

    for i = 1, #_waypoints, 1 do
        local waypoint = _waypoints[i]
        if waypoint ~= nil then
            local dist = wow.CalculateDistance(px, py, pz, waypoint[1], waypoint[2], waypoint[3])
            if dist <= closestDist then
                if TraceLine(px, py, pz + 2.5, waypoint[1], waypoint[2], waypoint[3] + 2.5, losFlags) == nil then
                    foundIndex = true
                    closestIndex = i
                    closestDist = dist
                end
            end
        end
    end

    if closestDist > 100 then
        Log.Debug("Closest Mailbox path is " .. math.ceil(closestDist) .. " yard away ==> TERMINATING")
        AtEnd = true
        TryExit()
    end

    if foundIndex then
        _pathIndex = closestIndex
        Log.Debug("Starting at mail path at idx " .. _pathIndex)
    end
end

local _firstTick = true

local function MoveToClosestWaypoint()
    if _firstTick == true then
        _firstTick = false
        SetIndexToClosest()
    end

    local px, py, pz = Player:Position()
    local waypoint = _waypoints[_pathIndex] -- return is imp to always assign next xyz correctly
    if waypoint ~= nil then
        local dist = wow.CalculateDistance(px, py, pz, waypoint[1], waypoint[2], waypoint[3])
        if dist <= PROXIMAL_TOLERANCE then
            if _pathIndex < #_waypoints then
                _pathIndex = _pathIndex + 1
                Log.Debug('Moving to MAIL idx {' .. _pathIndex .. '/' .. #_waypoints .. '}')
                return
            else
                AtEnd = true
            end
        end
    end

    -- Check if Stuck
    if _pathIndex == LastIndex then
        LastIndexCount = LastIndexCount + 1
        StuckTime = StuckTime + PULSE_DELAY
    else
        StuckTime = 0
        LastIndexCount = 0
    end
    if LastIndexCount > 35 and (_pathIndex < #_waypoints - 2) then
        local stuckStr = 'Appears to be STUCK: at idx=' .. _pathIndex
        Log.Debug(stuckStr)
        Player.Jump()
        _pathIndex = _pathIndex + 1
        AtEnd = _pathIndex > #_waypoints
        return
    end

    if _pathIndex < 1 then
        _pathIndex = 1
    elseif _pathIndex > #_waypoints then
        _pathIndex = #_waypoints
        AtEnd = true
    end

    -- Move
    local rnd = (math.random(-rndMax, rndMax) / 100)
    local nextWaypoint = _waypoints[_pathIndex]
    local distToNext = wow.CalculateDistance(px, py, pz, nextWaypoint[1], nextWaypoint[2], nextWaypoint[3])
    if not SKIP_FAR_POINTS or (SKIP_FAR_POINTS and distToNext < 50) then
        if IGNORE_LOS == true or TraceLine(px, py, pz + 2.5, nextWaypoint[1], nextWaypoint[2], nextWaypoint[3] + 2.5, losFlags) == nil then
            Navigator.MoveToeTo(nextWaypoint[1] + rnd, nextWaypoint[2] + rnd, nextWaypoint[3] + rnd)
        end
    else
        if SKIP_FAR_POINTS then
            Log.Debug('*Skipping* to MAIL idx {' .. _pathIndex .. '/' .. #_waypoints .. '}')
            _pathIndex = _pathIndex + 1
            AtEnd = _pathIndex > #_waypoints
            return
        else
            Log.Debug('*Waiting* for player to be close to path...')
        end
    end

    LastIndex = _pathIndex
end

local _mailboxOpened = false
local function Pulse()
    if IsAtMailbox() and not _mailboxOpened then
        OpenMailBox()
        _mailboxOpened = true
        Sleep(3)
        return
    elseif _mailboxOpened then
        if SendMail() then
            Sleep(2)
        end
    else
        MoveToClosestWaypoint()
    end
end

local function PulseReady()
    local timeNow = wow.GetTime()
    if timeNow >= _nextPulseTime then
        _nextPulseTime = timeNow + PULSE_DELAY
        return true
    else
        return false
    end
end

Log.Debug('Mailing items to ' .. recipient)

frame:SetScript("OnUpdate", function(self, elapsed)
    if PulseReady() then
        LibDraw.clearCanvas()
        Pulse()
        TryExit()
    end
end)
