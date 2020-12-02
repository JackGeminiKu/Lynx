Player = Unit:New('player')

-- 各种动作
do
    function Player.CastSpell(spellName, onSelf)
        wow.CastSpell(spellName, onSelf)
    end

    function Player.UseItem(itemName)
        wow.RunMacroText('/use ' .. itemName)
    end

    function Player.StopCast()
        wow.SpellStopCasting()
    end

    function Player.Jump()
        wow.SendKey(' ')
    end

    function Player.Interact(object)
        return wow.ObjectInteract(object.ObjectTag)
    end

    function Player.RetrieveCorpse()
        return wow.RetrieveCorpse()
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
        if usable == false or nomana then
            return false
        end
        return not Player.IsOnCD(spellName)
    end

    Player.IsSwimming = function()
        return wow.IsSwimming()
    end

    Player.IsMounted = function()
        return wow.IsMounted()
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
