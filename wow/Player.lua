Player = Unit:New('player')

-- 各种动作
do
    function Player.Attack()
        wow.RunMacroText("/startattack")
    end

    -- 返回true, false, 代表施放成功还是失败
    function Player.CastSpell(spellName, onSelf)
        if not Player.IsCastable(spellName) then
            return false
        end
        if onSelf then
            wow.CastSpell(spellName, onSelf)
            return true
        else
            if Player.IsSpellInRange(spellName, 'target') then
                wow.CastSpell(spellName, onSelf)
                return true
            else
                return false
            end
        end
    end

    function Player.Use(itemName)
        wow.RunMacroText('/use ' .. itemName)
    end

    function Player.StopCast()
        wow.SpellStopCasting()
    end

    function Player.Jump()
        if wmbapi ~= nil then
            JumpOrAscendStart()
        end
        if lb ~= nil then
            wow.Unlock(JumpOrAscendStart)
        end
    end

    function Player.StopMove()
        wow.StopMove()
    end

    function Player.TurnLeftStart()
        wow.TurnStart()
    end

    function Player.TurnStop()
        wow.TurnStop()
    end

    function Player.Dismount()
        wow.Dismount()
    end

    function Player.Interact()
        return wow.InteractUnit("target")
    end

    function Player.RetrieveCorpse()
        return wow.RetrieveCorpse()
    end

    -- 选中object作为当前目标
    function Player.Target(object)
        if type(object) == "table" then
            wow.TargetUnit(object.ObjectTag)
        else
            wow.TargetUnit(object)
        end
    end

    function Player.FaceDirection(angle)
        Log.Debug("Face direction: %d °", math.deg(angle))
        wow.FaceDirection(angle) 
    end

    function Player.FaceTarget()
        local facing = Player.CalTargetFacing()
        Player.FaceDirection(facing)
    end

    function Player.Skin(object)
        wow.InteractUnit(object)
    end

    function Player.Loot(object)
        wow.InteractUnit(object)
    end

    function Player.Buy(index)
        Log.Debug("Buy index " .. index)
        wow.BuyMerchantItem(index)
    end

    function Player.Repair(repairVendor)
        wow.InteractUnit(repairVendor)
    end

    -- Releases your ghost to the graveyard
    function Player.RepopMe()
        wow.RepopMe()
    end
end

-- 各种状态
do
    Player.CorpseRecoveryDelay = function()
        return wow.GetCorpseRecoveryDelay()
    end

    -- 计算Facing值, 使玩家正对目标
    Player.CalTargetFacing= function()
        local p = Player:Position()
        local t = Target:Position()
        local dx = t.x - p.x
        local dy = t.y - p.y
        local angle0 = math.atan(dy / dx)
        local angle = 0

        if dy > 0 and dx > 0 then
            angle = angle0
        elseif dy < 0 and dx > 0 then
            angle = angle0
        elseif dy > 0 and dx < 0 then
            angle = angle0 + math.pi
        elseif dy < 0 and dx < 0 then
            angle = math.pi + angle0
        end
        return angle
    end
end

-- 各种判断
do
    Player.IsOnCD = function(spellName)
        local start, duration, enabled = wow.GetSpellCooldown(spellName);
        if enabled == 0 then
            return true
        elseif (start > 0 and duration > 0) then
            return true
        else
            return false
        end
    end

    Player.IsCastable = function(spellName)
        local usable, nomana = wow.IsUsableSpell(spellName)
        if not usable or nomana then
            return false
        end
        return not Player.IsOnCD(spellName)
    end

    function Player.IsSpellInRange(spellName, target)
        return wow.IsSpellInRange(spellName, target)
    end

    Player.IsSwimming = function()
        return wow.IsSwimming()
    end

    Player.IsMounted = function()
        return wow.IsMounted()
    end

    function Player.IsIndoors()
        return IsIndoors()
    end
end

-- 宠物相关
do
    Player.LastFeedPetTime = 0

    function Player.CallPet()
        return wow.RunMacroText("/cast Call Pet")
    end

    function Player.RevivePet()
        return wow.RunMacroText("/cast Revive Pet")
    end

    function Player.FeedPet(foodName)
        Player.LastFeedPetTime = wow.GetTime()
        wow.RunMacroText("/use Feed Pet")
        wow.RunMacroText("/use " .. foodName)
    end

    function Player.MendPet()
        Player.CastSpell("Mend Pet", false)
    end

    function Player.IsMendingPet()
        local _, castChannelID, _, _ = wow.UnitCastID("player")
        return castChannelID == 136
    end
end

-- 静态方法
do
    function Player:Count()
        -- TBD
    end
end

-- 装备相关
do
    function Player.GetLowestDurability()
        local lowest = 9999
        for i = 1, 22 do
            local current, maximum = wow.GetInventoryItemDurability(i);
            if current ~= nil then
                if current < lowest then
                    lowest = current
                end
            end
        end
        return lowest
    end
end
