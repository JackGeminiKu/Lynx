print("Loading WoW")

Wow = {}

-- 魔兽世界API
do
    Wow.ApplyBuff = function(buff, unit)
        local onSelf = Wow.UnitGUID(unit) == Wow.UnitGUID("player")
        for i = 1, 15 do
            local name = Wow.UnitAura(unit, i)
            if name == nil then -- when name is nil we looped thru all auras 
                Wow.DebugPrint('Applying Buff: ' .. buff)
                Wow.CastSpellByName(buff, onSelf)
                return
            elseif name == buff then
                return
            end
        end
    end

    Wow.IsCastable = function(spellName)
        local usable, nomana = Wow.IsUsableSpell(spellName)
        if usable == false or nomana then
            return false
        end
        return not Wow.IsOnCD(spellName)
    end

    Wow.IsOnCD = function(spellName)
        local start, duration, enabled = Wow.GetSpellCooldown(spellName);
        if enabled == 0 then
            return true
        elseif (start > 0 and duration > 0) then
            return true
        else
            return false
        end
    end

    Wow.HasDebuff = function(name, obj)
        for i = 1, 40 do
            local debuff = Wow.UnitDebuff(obj, i)
            if debuff == nil then
                return false
            elseif debuff == name then
                return true
            end
        end
        return false
    end

    Wow.HasAura = function(object, aura)
        for i = 1, 40 do
            local name = Wow.UnitAura(object, i)
            if name then
                if name == aura then
                    return true
                end
            else
                return false
            end
        end
    end

    Wow.IsHunter = function()
        return Wow.UnitClass("player") == "Hunter"
    end

    Wow.IsMage = function()
        return Wow.UnitClass("player") == "Mage"
    end

    Wow.RepopMe = function()
        RepopMe()
    end

    Wow.GetSendMailItem = function(index)
        return GetSendMailItem(index)
    end

    Wow.RepairAllItems = function()
        RepairAllItems()
    end

    Wow.CanMerchantRepair = function()
        return CanMerchantRepair()
    end

    Wow.DeleteCursorItem = function()
        DeleteCursorItem()
    end

    Wow.PickupContainerItem = function(bagId, slot)
        PickupContainerItem(bagId, slot)
    end

    Wow.TargetUnit = function(unit)
        TargetUnit(unit)
    end

    Wow.UnitCreatureType = function(unit)
        return UnitCreatureType(unit)
    end

    Wow.IsSpellInRange = function(spellName)
        return IsSpellInRange(spellName)
    end

    Wow.rad = function(x)
        return math.rad(x)
    end

    Wow.atan2 = function(y, x)
        return math.atan2(y, x)
    end

    Wow.UnitCanAttack = function(attacker, attacked)
        return UnitCanAttack(attacker, attacked)
    end

    Wow.UnitIsPlayer = function(unit)
        return UnitIsPlayer(unit)
    end

    Wow.IsSwimming = function()
        return IsSwimming()
    end

    Wow.SpellStopCasting = function()
        SpellStopCasting()
    end

    Wow.GetContainerItemCooldown = function(bagId, slot)
        return GetContainerItemCooldown(bagId, slot)
    end

    Wow.IsUsableItem = function(item)
        return IsUsableItem(item)
    end

    Wow.GetPetHappiness = function()
        return GetPetHappiness()
    end

    Wow.CastPetAction = function(index)
        return CastPetAction(index)
    end

    Wow.GetPetActionInfo = function(index)
        return GetPetActionInfo(index)
    end

    Wow.UnitExists = function(unit)
        return UnitExists(unit)
    end

    Wow.IsUsableSpell = function(spellName)
        return IsUsableSpell(spellName)
    end

    Wow.GetSpellCooldown = function(spellName)
        return GetSpellCooldown(spellName)
    end

    Wow.UnitPowerMax = function(unit)
        return UnitPowerMax(unit)
    end

    Wow.UnitPower = function(unit)
        return UnitPower(unit)
    end

    Wow.UnitHealthMax = function(unit)
        return UnitHealthMax(unit)
    end

    Wow.UnitHealth = function(unit)
        return UnitHealth(unit)
    end

    Wow.UnitGUID = function(unit)
        return UnitGUID(unit)
    end

    Wow.UnitTarget = function(unit)
        return UnitTarget(unit)
    end

    Wow.UnitAffectingCombat = function(unit)
        return UnitAffectingCombat(unit)
    end

    Wow.UnitLevel = function(unit)
        return UnitLevel(unit)
    end

    Wow.CombatLogGetCurrentEventInfo = function()
        return CombatLogGetCurrentEventInfo()
    end

    Wow.UnitLevel = function(unit)
        return UnitLevel(unit)
    end

    Wow.GetTime = function()
        return GetTime()
    end

    Wow.UnitIsDeadOrGhost = function(unit)
        return UnitIsDeadOrGhost(unit)
    end

    Wow.IsMounted = function()
        return IsMounted()
    end

    Wow.GetObjectCount = function()
        local objects = lb.GetObjects()
        return #objects
    end

    Wow.GetObjectWithIndex = function(index)
        local objects = lb.GetObjects()
        return objects[index]
    end

    Wow.IsIndoors = function()
        return IsIndoors()
    end

    Wow.UnitIsCorpse = function(unit)
        return UnitIsCorpse(unit)
    end

    Wow.ObjectName = function(object)
        return UnitName(object)
    end

    Wow.GetCorpseRecoveryDelay = function()
        return GetCorpseRecoveryDelay()
    end

    Wow.RetrieveCorpse = function()
        RetrieveCorpse()
    end

    Wow.GetItemCount = function(itemName)
        return GetItemCount(itemName)
    end

    Wow.BuyMerchantItem = function(index)
        BuyMerchantItem(index)
    end

    Wow.CreateFrame = function(frameType)
        return CreateFrame(frameType)
    end

    Wow.UnitClass = function(unit)
        return UnitClass(unit)
    end

    Wow.UnitAura = function(unit, index)
        return UnitAura(unit, index)
    end

    Wow.UnitDebuff = function(unit, index)
        return UnitDebuff(unit, index)
    end

    Wow.Dismount = function()
        Dismount()
    end

    Wow.GetInventoryItemDurability = function(invSlot)
        return GetInventoryItemDurability(invSlot)
    end

    Wow.GetContainerNumSlots = function(bagId)
        return GetContainerNumSlots(bagId)
    end

    Wow.GetContainerNumFreeSlots = function(bagId)
        return GetContainerNumFreeSlots(bagId)
    end

    Wow.GetContainerItemLink = function(bagId, slot)
        return GetContainerItemLink(bagId, slot)
    end

    Wow.GetItemInfo = function(item)
        return GetItemInfo(item)
    end

    Wow.GetMerchantItemInfo = function(index)
        return GetMerchantItemInfo(index)
    end

    Wow.UnitIsEnemy = function(unit, otherUnit)
        return UnitIsEnemy(unit, otherUnit)
    end

    Wow.UnitIsDead = function(unit)
        return UnitIsDead(unit)
    end

    Wow.GetUnitSpeed = function(unit)
        return GetUnitSpeed(unit)
    end
end

-- Unlocker
do
    Wow.ObjectID = function(object)
        return lb.ObjectId(object)
    end

    Wow.InteractUnit = function(unit)
        return lb.ObjectInteract(unit)
    end

    Wow.WriteFile = function(path, contents, overwrite)
        if lb ~= nil then
            lb.WriteFile(path, contents, not overwrite)
        end
    end

    Wow.ReadFile = function(path)
        return lb.ReadFile(path)
    end

    Wow.RunMacroText = function(marco)
        lb.Unlock(Wow.RunMacroText, marco)
    end

    Wow.GetDistanceBetweenObjects = function(object1, object2)
        return lb.GetDistance3D(object1, object2)
    end

    Wow.ObjectPosition = function(object)
        return lb.ObjectPosition(object)
    end

    Wow.MoveTo = function(x, y, z)
        lb.MoveTo(x, y, z)
    end

    Wow.SendKey = function(key, released)
        -- TBD: luabox貌似不支持按键功能!
    end

    Wow.FaceDirection = function(facing)
        lb.SetPlayerAngles(facing)
    end

    Wow.GetObjectWithGUID = function(guid)
        -- TBD
    end

    Wow.UnitCanBeSkinned = function(unit)
        -- TBD
    end

    Wow.UnitCanBeLooted = function(unit)
        return lb.UnitIsLootable(unit)
    end

    Wow.CastSpellByName = function(spellName, onSelf)
        onSelf = onSelf or true
        lb.Unlock(CastSpellByName, spellName, onSelf)
    end

    Wow.UnitCastID = function(unit)
        local spellId = lb.UnitCastingInfo(unit)
        return spellId
    end

    Wow.UseContainerItem = function(bagId, slot)
        return lb.Unlock(UseContainerItem, bagId, slot)
    end
end

-- Bit opeartions
do
    Wow.bit = {}
    Wow.bit.bor = function(b1, b2, ...)
        return bit.bor(b1, b2, ...)
    end
end

-- Debug
do
    DEBUG_PRINT_ENABLED = true
    Wow.DebugPrint = function(message)
        if DEBUG_PRINT_ENABLED == true then
            print(message)
            Wow.WriteFile('/Log/Debug.txt', message .. '\n', true)
        end
    end
end
