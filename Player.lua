Player = Unit:New('player')

-- 各种动作
do
    function Player.Attack()
        wow.RunMacroText("/startattack")
    end

    -- 返回true, false, 代表施放成功还是失败
    function Player.CastSpell(spellName, onSelf)
        if Player.IsCastable(spellName) then
            return false
        end
        local onSelf = onSelf or true
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
        wow.Unlock(JumpOrAscendStart)
    end

    function Player.Dismount()
        wow.Dismount()
    end

    function Player.Interact(object)
        return wow.ObjectInteract(object.ObjectTag)
    end

    function Player.RetrieveCorpse()
        return wow.RetrieveCorpse()
    end

    -- 选中object作为当前目标
    function Player.Target(object)
        wow.TargetUnit(object.ObjectTag)
    end

    function Player.FaceTarget()
        if wow.UnitExists('target') then
            local ax, ay, az = Player:Position()
            local bx, by, bz = wow.GetObjectPosition('target')
            local angle = wow.rad(wow.atan2(by - ay, bx - ax))
            if angle < 0 then
                return wow.FaceDirection(wow.rad(wow.atan2(by - ay, bx - ax) + 360))
            else
                return wow.FaceDirection(angle)
            end
        end
    end
end

-- 各种状态
do
    Player.CorpseRecoveryDelay = function()
        return wow.GetCorpseRecoveryDelay()
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

    function Player.IsIndoor()
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
