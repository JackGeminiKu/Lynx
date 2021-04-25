wow = {}

-- **************
-- * 魔兽世界API *
-- **************

wow.Raycast = function(x1, y1, z1, x2, y2, z2, flags)
    if wmbapi then
        return wmbapi.Raycast(x1, y1, z1, x2, y2, z2, flags)
    end
    if lb then
        return lb.Raycast(x1, y1, z1, x2, y2, z2, flags)
    end
end

-- 返回物体的目标或者nil(如果不是有效的Object)
wow.GetTarget = function(unitTag)
    if wmbapi then
        return wmbapi.UnitTarget(unitTag)
    end
    if lb then
        return lb.UnitTarget(unitTag)
    end
end

-- 获取Object的Id
wow.ObjectId = function(objectTag)
    if wmbapi then
        return wmbapi.ObjectId(objectTag)
    end
    if lb then
        return lb.ObjectId(objectTag)
    end
end

-- 是否在坐骑上
wow.IsMounted = function()
    return IsMounted()
end

-- 是否在游泳
wow.IsSwimming = function()
    return IsSwimming()
end

-- 施放魔法
wow.CastSpell = function(spellName, onSelf)
    local target = 'target'
    if onSelf then
        target = 'player'
    end
    Log.Debug("释放法术: %s", spellName)
    if wmbapi then
        CastSpellByName(spellName, target)
    elseif lb then
        lb.Unlock(CastSpellByName, spellName, target)
    end
end

-- 获取物品数量
wow.GetItemCount = function(item)
    return GetItemCount(item)
end

-- 获取Unit的施放信息
wow.UnitCastingInfo = function(unit)
    return UnitCastingInfo(unit)
end

-- 获取物体名字
wow.GetObjectName = function(object)
    if wmbapi then
        return UnitName(object)
    end
    if lb then
        return lb.ObjectName(object)
    end
end

-- 返回物体的坐标: x, y, z
wow.GetObjectPosition = function(object)
    if wmbapi then
        return wmbapi.ObjectPosition(object)
    end
    if lb then
        return lb.ObjectPosition(object)
    end
end

-- 计算两点或两者间距离
wow.CalculateDistance = function(...)
    local x1, y1, z1, x2, y2, z2
    if select("#", ...) == 6 then
        x1, y1, z1, x2, y2, z2 = ...    -- x1, y1, z1, x2, y2, z2
    else
        local point1, point2 = ...    -- {x1, y1, z1}, {x2, y2, z2}
        x1 = point1[1]
        y1 = point1[2]
        z1 = point1[3]
        x2 = point2[1]
        y2 = point2[2]
        z2 = point2[3]
    end
    return math.sqrt(((x1 - x2) ^ 2) + ((y1 - y2) ^ 2) + ((z1 - z2) ^ 2))
end

-- 计算两个object之间的距离. 例如: Player 和 Target
wow.GetDistanceBetweenObjects = function(object1, object2)
    if wmbapi then
        return wmbapi.GetDistanceBetweenObjects(object1, object2)
    end
    if lb then
        return lb.GetDistanceBetweenObjects(object1, object2)
    end
end

-- 检查object是否有某个debuff
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

-- Unit是否存在某个光环
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

-- 检查是否是盗贼
wow.IsRouge = function()
    return wow.UnitClass("player") == "Rogue"
end

-- Releases your ghost to the graveyard
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
    -- TBD
    Log.Debug("Set target: " .. unit)
    lb.UnitTagHandler(TargetUnit, unit)
    -- lb.Unlock(TargetUnit, unit)
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

-- 施放宠物动作条技能
wow.CastPetAction = function(index)
    return CastPetAction(index)
end

-- 获取宠物动作条技能相关信息
wow.GetPetActionInfo = function(index)
    return GetPetActionInfo(index)
end

-- Unit是否存在
wow.UnitExists = function(unit)
    return UnitExists(unit)
end

function wow.ObjectExists(guid)
    if wmbapi then
        return wmbapi.ObjectExists(guid)
    end
    if lb then
        return lb.ObjectExists(guid)
    end
end

wow.IsUsableSpell = function(spellName)
    return IsUsableSpell(spellName)
end

wow.GetSpellCooldown = function(spellName)
    return GetSpellCooldown(spellName)
end

-- 获取Unit当前能量值
wow.UnitPower = function(unit)
    return UnitPower(unit)
end

wow.UnitPowerPercent = function(unit)
    return 100 * UnitPower(unit) / UnitPowerMax(unit)
end

-- 获取Unit能量上限值
wow.UnitPowerMax = function(unit)
    return UnitPowerMax(unit)
end

-- 获取Unit当前生命值
wow.UnitHealth = function(unit)
    return UnitHealth(unit)
end

wow.UnitHealthPercent = function(unit)
    return 100 * UnitHealth(unit) / UnitHealthMax(unit)
end

-- 获取Unit生命上限值
wow.UnitHealthMax = function(unit)
    return UnitHealthMax(unit)
end

wow.UnitGUID = function(unit)
    return UnitGUID(unit)
end

wow.GetTarget = function(unit)
    if wmbapi then
        return wmbapi.UnitTarget(unit)
    end
    if lb then
        return lb.UnitTarget(unit)
    end
end

wow.UnitAffectingCombat = function(unit)
    return UnitAffectingCombat(unit)
end

-- 获取Unit的等级
wow.GetUnitLevel = function(unit)
    return UnitLevel(unit)
end

wow.CombatLogGetCurrentEventInfo = function()
    return CombatLogGetCurrentEventInfo()
end

wow.GetTime = function()
    return GetTime()
end

-- Unit是否死亡, 或者处于灵魂状态
wow.UnitIsDeadOrGhost = function(unit)
    return UnitIsDeadOrGhost(unit)
end

-- 获取周围物体, 默认距离为30
wow.GetObjects = function(range)
    if wmbapi then
        local objects = {}
        for i = 1, wmbapi.GetObjectCount() do
            tinsert(objects, wmbapi.GetObjectWithIndex(i))
        end
        return objects
    end
    if lb then
        return lb.GetObjects(range)
    end
end

wow.IsIndoors = function()
    return IsIndoors()
end

wow.UnitIsCorpse = function(unit)
    return UnitIsCorpse(unit)
end

-- 获取复活CD时间
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

-- Unit是否已经死亡
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
    if wmbapi then
        return wmbapi.ObjectId(object)
    end
    if lb then
        return lb.ObjectId(object)
    end
end

wow.InteractUnit = function(unit)
    if wmbapi then
        return InteractUnit(unit)
    end
    if lb then
        return lb.ObjectInteract(unit)
    end
end

wow.ReadFile = function(path)
    if wmbapi then
        return wmbapi.ReadFile(path)
    end
    if lb then
        return lb.ReadFile(path)
    end
end

wow.RunMacroText = function(macro)
    if wmbapi then
        RunMacroText(macro)
    end
    if lb then
        lb.Unlock(wow.RunMacroText, macro)
    end
end

-- 返回x, y, z
wow.GetObjectPosition = function(object)
    if wmbapi then
        return wmbapi.ObjectPosition(object)
    end
    if lb then
        return lb.ObjectPosition(object)
    end
end

wow.SendKey = function(key, released)
    -- TBD: luabox貌似不支持按键功能!
end

wow.FaceDirection = function(facing)
    if wmbapi then
        wmbapi.FaceDirection(facing)
        return
    end
    if lb then
        lb.SetPlayerAngles(facing)
        return
    end
end

wow.GetObjectWithGUID = function(guid)
    -- TBD
end

wow.UnitCanBeSkinned = function(unit)
    -- TBD
end

wow.UnitCanBeLooted = function(unit)
    if wmbapi then
        return wmbapi.UnitIsLootable(unit)
    end
    if lb then
        return lb.UnitIsLootable(unit)
    end
end

wow.UnitCastID = function(unit)
    if wmbapi then
        return select(7, GetSpellInfo(UnitCastingInfo(unit))), wmbapi.UnitCastingTarget
    end
    if lb then
        local spellId = lb.UnitCastingInfo(unit)
        return spellId
    end
end

wow.UseContainerItem = function(bagId, slot)
    if wmbapi then
        return UseContainerItem(bagId, slot)
    end
    if lb then
        return lb.Unlock(UseContainerItem, bagId, slot)
    end
end

wow.GetObjectName = function(object)
    if wmbapi then
        return UnitName(object)
    end
    if lb then
        return lb.ObjectName(object)
    end
end

wow.ApplyBuff = function(buff, unit)
    local onSelf = wow.UnitGUID(unit) == wow.UnitGUID("player")
    for i = 1, 15 do
        local name = wow.UnitAura(unit, i)
        if name == nil then -- when name is nil we looped thru all auras 
            Log.Debug('Applying Buff: ' .. buff)
            Player.CastSpell(buff, onSelf)
            return
        elseif name == buff then
            return
        end
    end
end

wow.GetFacing = function(object)
    if wmbapi ~= nil then
        return wmbapi.ObjectFacing(object)
    end
end

-- wow.Unlock = function(method, arg1, arg2, ...)
--     return lb.Unlock(method, arg1, arg2, ...)
-- end

wow.MoveTo = function(x, y, z)
    if wmbapi then
        wmbapi.MoveTo(x, y, z)
        return
    end
    if lb then
        lb.MoveTo(x, y, z)
        return
    end
end

wow.StopMove = function()
    if wmbapi then
        MoveAndSteerStop()
        MoveForwardStop()
        MoveBackwardStop()
        PitchDownStop()
        PitchUpStop()
        StrafeLeftStop()
        StrafeRightStop()
        TurnLeftStop()
        TurnOrActionStop()
        TurnRightStop()
        if GetUnitSpeed("player") > 0 then
            MoveForwardStart()
            MoveForwardStop()
        end
        if wmbapi.GetKeyState(0x02) then
            TurnOrActionStart()
        elseif wmbapi.GetKeyState(0x01) then
            CameraOrSelectOrMoveStart()
        end
        return
    end
    if lb then
        lb.Navigator.Stop()
    end
end

-- 返回x, y, z or ni if no collision
wow.Raycast = function(x1, y1, z1, x2, y2, z2, flags)
    return Raycast(x1, y1, z1, x2, y2, z2, flags)
end

-- 写文件, 成功返回true, 否则, 返回false
wow.WriteFile = function(path, content, append)
    append = append or true
    if wmbapi then
        return wmbapi.WriteFile(path, content, append)
    end
    if lb then
        return lb.WriteFile(path, content, append)
    end
end

-- 返回角色到目标的Nav waypoints, 角色不移动!
wow.GetWaypoints = function(x, y, z, TargetId)
    if wmbapi then
        local mapId = wmbapi.GetCurrentMapInfo()
        local px, py, pz = Player:Position()
        -- Log.Debug("Get waypoints: %d (%f,%f,%f) --> (%f,%f,%f)", mapId, px, py, pz, x, y, z)
        print(px, py, pz, x, y, z)
        local points, polygons = wmbapi.FindPath(mapId, px, py, pz, x, y, z)
        local waypoints = {}
        for k, v in ipairs(points) do
            waypoints[#waypoints + 1] = {
                x = v[1],
                y = v[2],
                z = v[3]
            }
        end
        return waypoints
    end
    if lb then
        return lb.NavMgr_MoveTo(x, y, z, TargetId)
    end
end

wow.GameObjectHasLockType = function(GUID, lockType)
    -- TBD
    return lb.GameObjectHasLockType(GUID, lockType)
end

-- Bit opeartions
do
    wow.bit = {}
    wow.bit.bor = function(b1, b2, ...)
        return bit.bor(b1, b2, ...)
    end
end

-- Get Angle from Object to another, you can pass this either an array of positions (Not an object) or a GUID.
-- @returns [number, number] X/Y Axis angle, Z angle.
wow.GetAngle = function(Object1, Object2)
    local X1, Y1, Z1
    local X2, Y2, Z2
    if type(Object1) == "string" then
        X1, Y1, Z1 = wow.ObjectPosition(Object1)
    else
        X1, Y1, Z1 = Object1[1], Object1[2], Object1[3]
    end
    if type(Object2) == "string" then
        X2, Y2, Z2 = wow.ObjectPosition(Object2)
    else
        X2, Y2, Z2 = Object2[1], Object2[2], Object2[3]
    end
    if X1 == nil or X2 == nil then
        return nil
    end

    local Angle = math.sqrt(math.pow(X1 - X2, 2) + math.pow(Y1 - Y2, 2))
    if Angle == 0 then
        Angle = 1
    end
    return math.atan2(Y2 - Y1, X2 - X1) % (math.pi * 2), math.atan((Z1 - Z2) / Angle) % math.pi
end

wow.GatherHerb = function(guid)
    if wmbapi then
        InteractUnit(guid)
        return
    end
    if lb then
        lb.UnitTagHandler(InteractUnit, guid)
        return
    end
end

wow.GatherMine = function(guid)
    if wmbapi then
        InteractUnit(guid)
        return
    end
    if lb then
        lb.UnitTagHandler(InteractUnit, guid)
        return
    end
end

wow.TurnStart = function()
    Log.Debug("Turn start")
    if wmbapi ~= nil then
        TurnLeftStart()
    end
end

wow.TurnStop = function()
    Log.Debug("Turn stop")
    if wmbapi ~= nil then
        TurnLeftStop()
    end
end
