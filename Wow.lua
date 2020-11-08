print("WoW")

Wow = {}

-- 魔兽世界API
do
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

    Wow.GetObjectCount =  function()
       local objects =  lb.GetObjects() 
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
        return UnitName(object)[1]
    end

    Wow.GetCorpseRecoveryDelay = function()
        return GetCorpseRecoveryDelay()
    end

    Wow.RetrieveCorpse = function()
        RetrieveCorpse()
    end

    Wow.GetItemCount = function()
        return GetItemCount()
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

    Wow.GetContainerItemLink = function(bagId, slot)
        return GetContainerItemLink(bagId, slot)
    end

    Wow.GetItemInfo = function(item)
        return GetItemInfo(item)
    end

    Wow.GetMerchantItemInfo = function(index)
        return GetMerchantItemInfo(index)
    end

    Wow.UnitIsEnemy = function(unit)
        return UnitIsEnemy(unit)
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
    Wow.WriteFile = function(path, contents, overwrite)
        return lb.WriteFile(path, contents, not overwrite)
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
end

-- Bit opeartions
do
    Wow.bit = {}
    Wow.bit.bor = function(b1, b2, ...)
        return bit.bor(b1, b2, ...)
    end
end