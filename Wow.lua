print("Loading WoW")

Wow = {}

-- 魔兽世界API
do
    CalculateDistance = function(...)
        local x1, y1, z1, x2, y2, z2
        if select("#", ...) == 6 then
           x1, y1, z1, x2, y2, z2 = ... 
        else
            local point1, point2 = ...
            x1 = point1[1]
            y1 = point1[2]
            z1 = point1[3]
            x2 = point2[1]
            y2 = point2[2]
            z2 = point2[3]
        end
        return math.sqrt(((x1 - x2) ^ 2) + ((y1 - y2) ^ 2) + ((z1 - z2) ^ 2))
    end

    IsCastable = function(spellName)
        local usable, nomana = IsUsableSpell(spellName)
        if usable == false or nomana then
            return false
        end
        return not IsOnCD(spellName)
    end

    IsOnCD = function(spellName)
        local start, duration, enabled = GetSpellCooldown(spellName);
        if enabled == 0 then
            return true
        elseif (start > 0 and duration > 0) then
            return true
        else
            return false
        end
    end

    HasDebuff = function(name, obj)
        for i = 1, 40 do
            local debuff = UnitDebuff(obj, i)
            if debuff == nil then
                return false
            elseif debuff == name then
                return true
            end
        end
        return false
    end

    HasAura = function(object, aura)
        for i = 1, 40 do
            local name = UnitAura(object, i)
            if name then
                if name == aura then
                    return true
                end
            else
                return false
            end
        end
    end

    IsHunter = function()
        return UnitClass("player") == "Hunter"
    end

    IsMage = function()
        return UnitClass("player") == "Mage"
    end

    RepopMe = function()
        RepopMe()
    end

    GetSendMailItem = function(index)
        return GetSendMailItem(index)
    end

    RepairAllItems = function()
        RepairAllItems()
    end

    CanMerchantRepair = function()
        return CanMerchantRepair()
    end

    DeleteCursorItem = function()
        DeleteCursorItem()
    end

    PickupContainerItem = function(bagId, slot)
        PickupContainerItem(bagId, slot)
    end

    TargetUnit = function(unit)
        TargetUnit(unit)
    end

    UnitCreatureType = function(unit)
        return UnitCreatureType(unit)
    end

    IsSpellInRange = function(spellName)
        return IsSpellInRange(spellName)
    end

    rad = function(x)
        return math.rad(x)
    end

    atan2 = function(y, x)
        return math.atan2(y, x)
    end

    UnitCanAttack = function(attacker, attacked)
        return UnitCanAttack(attacker, attacked)
    end

    UnitIsPlayer = function(unit)
        return UnitIsPlayer(unit)
    end

    IsSwimming = function()
        return IsSwimming()
    end

    SpellStopCasting = function()
        SpellStopCasting()
    end

    GetContainerItemCooldown = function(bagId, slot)
        return GetContainerItemCooldown(bagId, slot)
    end

    IsUsableItem = function(item)
        return IsUsableItem(item)
    end

    GetPetHappiness = function()
        return GetPetHappiness()
    end

    CastPetAction = function(index)
        return CastPetAction(index)
    end

    GetPetActionInfo = function(index)
        return GetPetActionInfo(index)
    end

    UnitExists = function(unit)
        return UnitExists(unit)
    end

    IsUsableSpell = function(spellName)
        return IsUsableSpell(spellName)
    end

    GetSpellCooldown = function(spellName)
        return GetSpellCooldown(spellName)
    end

    UnitPowerMax = function(unit)
        return UnitPowerMax(unit)
    end

    UnitPower = function(unit)
        return UnitPower(unit)
    end

    UnitHealthMax = function(unit)
        return UnitHealthMax(unit)
    end

    UnitHealth = function(unit)
        return UnitHealth(unit)
    end

    UnitGUID = function(unit)
        return UnitGUID(unit)
    end

    UnitTarget = function(unit)
        return lb.UnitTarget(unit)
    end

    UnitAffectingCombat = function(unit)
        return UnitAffectingCombat(unit)
    end

    UnitLevel = function(unit)
        return UnitLevel(unit)
    end

    CombatLogGetCurrentEventInfo = function()
        return CombatLogGetCurrentEventInfo()
    end

    UnitLevel = function(unit)
        return UnitLevel(unit)
    end

    GetTime = function()
        return GetTime()
    end

    UnitIsDeadOrGhost = function(unit)
        return UnitIsDeadOrGhost(unit)
    end

    IsMounted = function()
        return IsMounted()
    end

    GetObjectCount = function()
        local objects = lb.GetObjects()
        return #objects
    end

    GetObjectWithIndex = function(index)
        local objects = lb.GetObjects()
        return objects[index]
    end

    IsIndoors = function()
        return IsIndoors()
    end

    UnitIsCorpse = function(unit)
        return UnitIsCorpse(unit)
    end

    GetCorpseRecoveryDelay = function()
        return GetCorpseRecoveryDelay()
    end

    RetrieveCorpse = function()
        RetrieveCorpse()
    end

    GetItemCount = function(itemName)
        return GetItemCount(itemName)
    end

    BuyMerchantItem = function(index)
        BuyMerchantItem(index)
    end

    CreateFrame = function(frameType)
        return CreateFrame(frameType)
    end

    UnitClass = function(unit)
        return UnitClass(unit)
    end

    UnitAura = function(unit, index)
        return UnitAura(unit, index)
    end

    UnitDebuff = function(unit, index)
        return UnitDebuff(unit, index)
    end

    Dismount = function()
        Dismount()
    end

    GetInventoryItemDurability = function(invSlot)
        return GetInventoryItemDurability(invSlot)
    end

    GetContainerNumSlots = function(bagId)
        return GetContainerNumSlots(bagId)
    end

    GetContainerNumFreeSlots = function(bagId)
        return GetContainerNumFreeSlots(bagId)
    end

    GetContainerItemLink = function(bagId, slot)
        return GetContainerItemLink(bagId, slot)
    end

    GetItemInfo = function(item)
        return GetItemInfo(item)
    end

    GetMerchantItemInfo = function(index)
        return GetMerchantItemInfo(index)
    end

    UnitIsEnemy = function(unit, otherUnit)
        return UnitIsEnemy(unit, otherUnit)
    end

    UnitIsDead = function(unit)
        return UnitIsDead(unit)
    end

    GetUnitSpeed = function(unit)
        return GetUnitSpeed(unit)
    end
end

-- Unlocker
do
    ObjectID = function(object)
        return lb.ObjectId(object)
    end

    InteractUnit = function(unit)
        return lb.ObjectInteract(unit)
    end

    WriteFile = function(path, contents, overwrite)
        if lb ~= nil then
            lb.WriteFile(path, contents, not overwrite)
        end
    end

    ReadFile = function(path)
        return lb.ReadFile(path)
    end

    RunMacroText = function(marco)
        lb.Unlock(RunMacroText, marco)
    end

    GetDistanceBetweenObjects = function(object1, object2)
        return lb.GetDistance3D(object1, object2)
    end

    ObjectPosition = function(object)
        return lb.ObjectPosition(object)
    end

    MoveTo = function(x, y, z)
        lb.MoveTo(x, y, z)
    end

    MoveToPoint = function(point)
        lb.MoveTo(point[1], point[2], point[3])
    end

    SendKey = function(key, released)
        -- TBD: luabox貌似不支持按键功能!
    end

    FaceDirection = function(facing)
        lb.SetPlayerAngles(facing)
    end

    GetObjectWithGUID = function(guid)
        -- TBD
    end

    UnitCanBeSkinned = function(unit)
        -- TBD
    end

    UnitCanBeLooted = function(unit)
        return lb.UnitIsLootable(unit)
    end

    CastSpellByName = function(spellName, onSelf)
        onSelf = onSelf or true
        lb.Unlock(CastSpellByName, spellName, onSelf)
    end

    UnitCastID = function(unit)
        local spellId = lb.UnitCastingInfo(unit)
        return spellId
    end

    UseContainerItem = function(bagId, slot)
        return lb.Unlock(UseContainerItem, bagId, slot)
    end

    ObjectName = function(object)
        if lb ~= nil then
            return lb.ObjectName(object)
        end
    end

    ApplyBuff = function(buff, unit)
        local onSelf = UnitGUID(unit) == UnitGUID("player")
        for i = 1, 15 do
            local name = UnitAura(unit, i)
            if name == nil then -- when name is nil we looped thru all auras 
                DebugPrint('Applying Buff: ' .. buff)
                CastSpellByName(buff, onSelf)
                return
            elseif name == buff then
                return
            end
        end
    end
end

-- Bit opeartions
do
    bit = {}
    bit.bor = function(b1, b2, ...)
        return bit.bor(b1, b2, ...)
    end
end

-- Debug
do
    DEBUG_PRINT_ENABLED = true
    DebugPrint = function(message)
        if DEBUG_PRINT_ENABLED == true then
            print(message)
            WriteFile('/Log/Debug.txt', message .. '\n', true)
        end
    end
end
