print("Loading WoW")

wow = {}

-- 魔兽世界API
do
    wow.CalculateDistance = function(...)
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

    wow.HasDebuff = function(name, obj)
        for i = 1, 40 do
            local debuff = wow.UnitDebuff(obj, i)
            if debuff == nil then
                return false
            elseif debuff == name then
                return true
            end
        end
        return false
    end

    wow.HasAura = function(object, aura)
        for i = 1, 40 do
            local name = wow.UnitAura(object, i)
            if name then
                if name == aura then
                    return true
                end
            else
                return false
            end
        end
    end



    wow.IsRouge = function()
        return wow.UnitClass("player") == "Rogue"
    end

    wow.RepopMe = function()
        RepopMe()
    end

    wow.GetSendMailItem = function(index)
        return GetSendMailItem(index)
    end

    wow.RepairAllItems = function()
        RepairAllItems()
    end

    wow.CanMerchantRepair = function()
        return CanMerchantRepair()
    end

    wow.DeleteCursorItem = function()
        DeleteCursorItem()
    end

    wow.PickupContainerItem = function(bagId, slot)
        PickupContainerItem(bagId, slot)
    end

    wow.TargetUnit = function(unit)
        TargetUnit(unit)
    end

    wow.UnitCreatureType = function(unit)
        return UnitCreatureType(unit)
    end

    wow.IsSpellInRange = function(spellName)
        return IsSpellInRange(spellName)
    end

    wow.rad = function(x)
        return math.rad(x)
    end

    wow.atan2 = function(y, x)
        return math.atan2(y, x)
    end

    wow.UnitCanAttack = function(attacker, attacked)
        return UnitCanAttack(attacker, attacked)
    end

    wow.UnitIsPlayer = function(unit)
        return UnitIsPlayer(unit)
    end

    wow.SpellStopCasting = function()
        SpellStopCasting()
    end

    wow.GetContainerItemCooldown = function(bagId, slot)
        return GetContainerItemCooldown(bagId, slot)
    end

    wow.IsUsableItem = function(item)
        return IsUsableItem(item)
    end

    wow.GetPetHappiness = function()
        return GetPetHappiness()
    end

    wow.CastPetAction = function(index)
        return CastPetAction(index)
    end

    wow.GetPetActionInfo = function(index)
        return GetPetActionInfo(index)
    end

    wow.UnitExists = function(unit)
        return UnitExists(unit)
    end

    wow.IsUsableSpell = function(spellName)
        return IsUsableSpell(spellName)
    end

    wow.GetSpellCooldown = function(spellName)
        return GetSpellCooldown(spellName)
    end

    wow.UnitPower = function(unit)
        return UnitPower(unit)
    end

    wow.UnitPowerPercent = function(unit)
        return 100 * UnitPower(unit) / UnitPowerMax(unit)
    end

    wow.UnitPowerMax = function(unit)
        return UnitPowerMax(unit)
    end

    wow.UnitHealth = function(unit)
        return UnitHealth(unit)
    end

    wow.UnitHealthPercent = function(unit)
        return 100 * UnitHealth(unit) / UnitHealthMax(unit)
    end

    wow.UnitHealthMax = function(unit)
        return UnitHealthMax(unit)
    end

    wow.UnitGUID = function(unit)
        return UnitGUID(unit)
    end

    wow.UnitTarget = function(unit)
        return lb.UnitTarget(unit)
    end

    wow.UnitAffectingCombat = function(unit)
        return UnitAffectingCombat(unit)
    end

    wow.UnitLevel = function(unit)
        return UnitLevel(unit)
    end

    wow.CombatLogGetCurrentEventInfo = function()
        return CombatLogGetCurrentEventInfo()
    end

    wow.UnitLevel = function(unit)
        return UnitLevel(unit)
    end

    wow.GetTime = function()
        return GetTime()
    end

    wow.UnitIsDeadOrGhost = function(unit)
        return UnitIsDeadOrGhost(unit)
    end

    wow.GetObjects = function()
        return lb.GetObjects(30)
    end

    wow.GetObjectCount = function()
        local objects = lb.GetObjects()
        return #objects
    end

    wow.GetObjectWithIndex = function(index)
        local objects = lb.GetObjects()
        return objects[index]
    end

    wow.IsIndoors = function()
        return IsIndoors()
    end

    wow.UnitIsCorpse = function(unit)
        return UnitIsCorpse(unit)
    end

    wow.GetCorpseRecoveryDelay = function()
        return GetCorpseRecoveryDelay()
    end

    wow.RetrieveCorpse = function()
        RetrieveCorpse()
    end

    wow.BuyMerchantItem = function(index)
        BuyMerchantItem(index)
    end

    wow.CreateFrame = function(frameType)
        return CreateFrame(frameType)
    end

    wow.UnitClass = function(unit)
        return UnitClass(unit)
    end

    wow.UnitAura = function(unit, index)
        return UnitAura(unit, index)
    end

    wow.UnitDebuff = function(unit, index)
        return UnitDebuff(unit, index)
    end

    wow.Dismount = function()
        Dismount()
    end

    wow.GetInventoryItemDurability = function(invSlot)
        return GetInventoryItemDurability(invSlot)
    end

    wow.GetContainerNumSlots = function(bagId)
        return GetContainerNumSlots(bagId)
    end

    wow.GetContainerNumFreeSlots = function(bagId)
        return GetContainerNumFreeSlots(bagId)
    end

    wow.GetContainerItemLink = function(bagId, slot)
        return GetContainerItemLink(bagId, slot)
    end

    wow.GetItemInfo = function(item)
        return GetItemInfo(item)
    end

    wow.GetMerchantItemInfo = function(index)
        return GetMerchantItemInfo(index)
    end

    wow.UnitIsEnemy = function(unit)
        return UnitIsEnemy("player", unit)
    end

    wow.UnitIsDead = function(unit)
        return UnitIsDead(unit)
    end

    wow.GetUnitSpeed = function(unit)
        return GetUnitSpeed(unit)
    end

    wow.IsInCombat = function(unit)
        unit = unit or "player"
        return wow.UnitAffectingCombat(unit)
    end

    wow.ObjectID = function(object)
        return lb.ObjectId(object)
    end

    wow.InteractUnit = function(unit)
        return lb.ObjectInteract(unit)
    end

    wow.ReadFile = function(path)
        return lb.ReadFile(path)
    end

    wow.RunMacroText = function(marco)
        lb.Unlock(wow.RunMacroText, marco)
    end

    wow.GetDistanceBetweenObjects = function(object1, object2)
        return lb.GetDistance3D(object1, object2)
    end

    -- 返回x, y, z
    wow.GetObjectPosition = function(object)
        return lb.ObjectPosition(object)
    end

    wow.SendKey = function(key, released)
        -- TBD: luabox貌似不支持按键功能!
    end

    wow.FaceDirection = function(facing)
        lb.SetPlayerAngles(facing)
    end

    wow.GetObjectWithGUID = function(guid)
        -- TBD
    end

    wow.UnitCanBeSkinned = function(unit)
        -- TBD
    end

    wow.UnitCanBeLooted = function(unit)
        return lb.UnitIsLootable(unit)
    end

    wow.UnitCastID = function(unit)
        local spellId = lb.UnitCastingInfo(unit)
        return spellId
    end

    wow.UseContainerItem = function(bagId, slot)
        return lb.Unlock(UseContainerItem, bagId, slot)
    end

    wow.ObjectName = function(object)
        if lb ~= nil then
            return lb.ObjectName(object)
        end
    end

    wow.ApplyBuff = function(buff, unit)
        local onSelf = wow.UnitGUID(unit) == wow.UnitGUID("player")
        for i = 1, 15 do
            local name = wow.UnitAura(unit, i)
            if name == nil then -- when name is nil we looped thru all auras 
                wow.Log('Applying Buff: ' .. buff)
                player.CastSpell(buff, onSelf)
                return
            elseif name == buff then
                return
            end
        end
    end
end

-- Bit opeartions
do
    wow.bit = {}
    wow.bit.bor = function(b1, b2, ...)
        return bit.bor(b1, b2, ...)
    end
end

-- Log
do
    wow.Log = function(content)
        if lb ~= nil then
            print(content)
            lb.WriteFile("E:\\log-" .. lb.GetGameAccountName() .. ".txt", content .. '\n', true)
        end
    end

end
