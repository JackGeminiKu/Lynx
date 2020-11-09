local scriptName = 'felwood_54'
local recipient = 'Leblanc'
if Wow.ObjectName("player") == "CURRENT_PLAYER_NAME" then
    recipient = "ACCOUNT_TO_SEND_TO"
end

print('Mailing...')
-- Keep
local PetFood = {"Haunch of Meat", "Big Bear Meat", "Turtle Meat", "Mutton Chop", "Wild Hog Shank", "Red Wolf Meat"}
local Drinks = {"Conjured Sparkling Water", "Sweet Nectar", "Ice Cold Milk", "Melon Juice"}
local Food = {"Conjured Sourdough", "Wild Hog Shank", "Mutton Chop", "Cured Ham Steak"}
local toKeep = {"Hearthstone", "Brown Horse Bridle", "Skinning Knife", "Strong Fishing Pole", "Fishing Pole", "Rune of Teleportation", "Rune of Portals"}

local waypoints = {}

local waypointsCount = table.getn(waypoints)

local pulseDelay = 0.2
local startDelay = 1
local bPrint = false

local frame = Wow.CreateFrame("Frame")
local bRun = true
local canPulseAt = (Wow.GetTime() + startDelay) + pulseDelay

local pathIdx = 1
local losFlags = Wow.bit.bor(0x10, 0x100)
local proximalTolerance = 4

local bSkipFarPoints = false
local bReLoop = false

local rndMax = 1 -- lets be precise for this short path

local function IsAtMailbox()
    local objCount = Wow.GetObjectCount()
    for i = 1, objCount do
        local obj = Wow.GetObjectWithIndex(i)
        local name = Wow.ObjectName(obj)
        if name == "Mailbox" then
            local dist = Wow.GetDistanceBetweenObjects("player", obj)
            if dist < 5 then
                return true
            end
        end
    end

    return false
end

local function OpenMailBox()
    local objCount = Wow.GetObjectCount()
    for i = 1, objCount do
        local obj = Wow.GetObjectWithIndex(i)
        local name = Wow.ObjectName(obj)
        if name == "Mailbox" then
            Wow.ObjectInteract(obj)
        end
    end
end

local function Sleepy(secs)
    local timeNow = Wow.GetTime()

    if canPulseAt > timeNow then -- since this func may be used several times in 1 cycle
        local overheadWait = canPulseAt - timeNow;
        canPulseAt = timeNow + overheadWait + secs
    else
        canPulseAt = overheadWait + secs
    end
end

local function ArrContains(arr, search)
    local count = table.getn(arr)
    for i = 1, count, 1 do
        if arr[i] == search then
            return true
        end
    end
    return false
end

local function DbgPrint(str)
    if bPrint == true then
        print(str)
        Wow.WriteFile('_Lynx/Debug.txt', str .. '\n', true)
    end
end

local class, englishClass = Wow.UnitClass("player");
local isHunter = class == "Hunter"
local isMage = class == "Mage"
local isRogue = class == "Rogue"

local name = 'alla'
local cTip = Wow.CreateFrame("GameTooltip", name .. "Tooltip", nil, "GameTooltipTemplate")
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

-- To see UI elements use /framestack 
local function PulseSend()
    Wow.RunMacroText('/click MailFrameTab2')
    Wow.RunMacroText('/run SendMailSubjectEditBox:SetText("Sell")')
    Wow.RunMacroText('/run SendMailNameEditBox:SetText("' .. recipient .. '")')

    for b = 0, 4 do
        for s = 0, 36 do
            l = Wow.GetContainerItemLink(b, s)
            if l then
                local sName, sLink, iRarity, iLevel, iMinLevel, sType, sSubType, iStackCount = Wow.GetItemInfo(l)
                if IsSoulbound(b, s) == false and ArrContains(toKeep, sName) == false then
                    if isHunter and (sType == "Projectile" or ArrContains(PetFood, sName)) then
                        -- DbgPrint('Keeping [Hunter Stuff]: '..sName)
                    elseif isRogue and sName:find("Throwing") ~= nil then
                        -- DbgPrint('Keeping [Rogue Thrown]: '..sName)
                    elseif sSubType == "Bag" or (isHunter and (sSubType == "Quiver" or sSubType == "Ammo Pouch")) then
                        -- Bug where last Bag is perceived as item in other bags for selling :/
                    elseif sName:find("Recipe:") == nil and (sName:find("Potion") ~= nil or sName:find("Bandage") ~= nil) then
                        -- DbgPrint('Keeping [Potion/Bandage]: '..sName)
                    elseif ArrContains(Food, sName) or ArrContains(Drinks, sName) then
                        -- DbgPrint('Keeping [Food/Drink]: '..sName)
                    else
                        if iRarity >= 1 then
                            DbgPrint('Sending: ' .. l)
                            Wow.UseContainerItem(b, s)
                        end
                    end
                else
                    -- DbgPrint('Keeping [Soulbound/ToKeep]: '..sName)
                end
            end
        end
    end

    local Name, Texture, Count, Quality = Wow.GetSendMailItem(1)
    if Name == nil or Name == "" then -- if there is not attached mail
        bRun = false
        DbgPrint('Finished Sending Mail')
        Wow.RunMacroText('/run SendMailCancelButton:Click()')
    end

    -- frame:SetScript("OnUpdate", nil)
    Wow.RunMacroText('/run SendMailMailButton:Click()')
    Sleepy(2)
end

local function ShouldExit()
    -- Needs to be called within OnUpdate itself
    if AtEndthen then
        bRun = false
    end

    if bRun == false then
        local exitMacro = '.loadfile _Lynx\\' .. scriptName .. '\\main.lua'
        DbgPrint("Starting main.lua from mail.lua")
        Wow.RunMacroText(exitMacro)
        frame:SetScript("OnUpdate", nil)
    end
end

local function CalculateDistance(x1, y1, z1, x2, y2, z2)
    return math.sqrt(((x1 - x2) ^ 2) + ((y1 - y2) ^ 2) + ((z1 - z2) ^ 2))
end

local function SetIDXToClosest()
    local px, py, pz = Wow.ObjectPosition("player")
    local moveToIdx = 1
    local moveToDist = 9999999
    local foundSomething = false

    for i = 1, waypointsCount, 1 do
        local xyz = waypoints[i]
        if xyz ~= nil then
            local dist = CalculateDistance(px, py, pz, xyz[1], xyz[2], xyz[3])

            if dist <= moveToDist then
                if TraceLine(px, py, pz + 2.5, xyz[1], xyz[2], xyz[3] + 2.5, losFlags) == nil then
                    foundSomething = true
                    moveToIdx = i
                    moveToDist = dist
                end
            end
        end
    end

    if moveToDist > 100 then
        DbgPrint("Closest Mailbox path is " .. math.ceil(moveToDist) .. " yard away ==> TERMINATING")
        AtEnd= true
        ShouldExit()
    end

    if foundSomething then
        pathIdx = moveToIdx
        DbgPrint("Starting at mail path at idx " .. pathIdx)
    end
end

local firstTick = true

local function StrictPathFollow()
    if firstTick == true then
        firstTick = false
        SetIDXToClosest()
    end

    local px, py, pz = Wow.ObjectPosition("player")
    local xyz = waypoints[pathIdx] -- return is imp to always assign next xyz correctly

    if xyz ~= nil then
        -- Add Class Specific
        -- !Move this to last (after movement!!!)
        if xyz[4] ~= nil then
            -- Define 4th Param Stuff
        end

        local dist = CalculateDistance(px, py, pz, xyz[1], xyz[2], xyz[3])
        -- print(' = DIST: '..dist)
        if dist <= proximalTolerance then
            if pathIdx < waypointsCount then
                pathIdx = pathIdx + 1
                DbgPrint('Moving to MAIL idx {' .. pathIdx .. '/' .. waypointsCount .. '}')
                return
            else
                AtEnd= true
            end
        end
    end

    -- Check if Stuck
    if pathIdx == LastIdx then
        LastIdxCount = LastIdxCount + 1
        StuckTime = StuckTime + pulseDelay
    else
        StuckTime = 0
        LastIdxCount = 0
    end

    -- Skip if stuck (forced) but never skip last post so as to trigger the appropriate fail safes
    -- using counter in the form of lastIdxCount is mehhh coz doesnt give indication of time stuck (we vary pulseDelay all the time)
    if LastIdxCount > 35 and (pathIdx < waypointsCount - 2) then
        local stuckStr = 'Appears to be STUCK: at idx=' .. pathIdx
        print(stuckStr)
        Wow.WriteFile('_Lynx/Stuck.txt', stuckStr .. '\n', true)
        -- local prevIdx = pathIdx
        -- pathIdx = 1
        -- FindNextBestPoint()
        Wow.SendKey(' ')
        pathIdx = pathIdx + 1
        AtEnd= pathIdx > waypointsCount
        if AtEndthen then
        end
        return
    end

    if pathIdx < 1 then
        pathIdx = 1
    elseif pathIdx > waypointsCount then
        pathIdx = waypointsCount
        AtEnd= true
    end

    -- Move
    local rnd = (math.random(-rndMax, rndMax) / 100)
    local moveToXYZ = waypoints[pathIdx]
    if moveToXYZ ~= nil then
        dX = moveToXYZ[1] + rnd
        dY = moveToXYZ[2] + rnd
        dZ = moveToXYZ[3] + rnd
    end

    local distToNext = CalculateDistance(px, py, pz, moveToXYZ[1], moveToXYZ[2], moveToXYZ[3])
    if bSkipFarPoints == false or (bSkipFarPoints and distToNext < 50) then
        if IgnoreLOS== true or TraceLine(px, py, pz + 2.5, moveToXYZ[1], moveToXYZ[2], moveToXYZ[3] + 2.5, losFlags) == nil then
            Wow.MoveTo(moveToXYZ[1] + rnd, moveToXYZ[2] + rnd, moveToXYZ[3] + rnd)
        end
    else
        if bSkipFarPoints then
            DbgPrint('*Skipping* to MAIL idx {' .. pathIdx .. '/' .. waypointsCount .. '}')
            pathIdx = pathIdx + 1
            AtEnd= pathIdx > waypointsCount
            return
        else
            DbgPrint('*Waiting* for player to be close to path...')
        end
    end

    LastIdx = pathIdx
end

local mailboxOpened = false
local function Pulse()
    if IsAtMailbox() and mailboxOpened == false then
        OpenMailBox()
        mailboxOpened = true
        Sleepy(3)
        return
    elseif mailboxOpened == true then
        PulseSend()
    else
        StrictPathFollow()
    end
end

local function CanPulse()
    local timeNow = Wow.GetTime()
    if timeNow >= canPulseAt then
        canPulseAt = timeNow + pulseDelay
        return true
    else
        return false
    end
end

DbgPrint('Mailing items to ' .. recipient)

frame:SetScript("OnUpdate", function(self, elapsed)
    if CanPulse() == true then
        LibDraw.clearCanvas()
        Pulse()
        ShouldExit()
    end
end)
