BT.MageAttack = {
    base = BT.Action
}
local this = BT.MageAttack
this.__index = this
setmetatable(this, this.base)

function BT.MageAttack:New(name)
    local o = this.base:New(name)
    o.nextSpellTime = wow.GetTime()
    o.spellList = {}
    o.isTurning = false
    setmetatable(o, this)
    return o
end

function BT.MageAttack:OnUpdate()
    if not Player:HasTarget() or Target:IsDead() then
        self.spellList = {}
        return BT.ETaskStatus.Success
    end

    -- -- 面向目标
    -- local angle = wow.GetAngle('player', 'target')
    -- self:LogDebug('angle = ' .. angle)
    -- if angle > math.pi / 2 then
    --     Player.SetAngle(angle)
    -- end

    -- 停下来
    if Player:IsMoving() then
        Player.StopMove()
        return BT.ETaskStatus.Running
    end

    -- 调整方向?
    local facing = Player:Facing()
    local facing2 = Player.CalTargetFacing()
    Log.Debug(
        '%.1f, %.1f, %.1f / %.1f',
        math.deg(facing),
        math.deg(facing2),
        math.deg(facing - facing2),
        facing - facing2
    )
    if math.abs(facing - facing2) > math.pi / 180 * 60 then
        if not self.isTurning then
            self.isTurning = true
            Log.Debug('start turning')
            wow.TurnStart()
        end
        -- FaceDirection(facing2 + math.random(-200, 200) / 1000)
        -- self.nextSpellTime = self.nextSpellTime + 0.1
        return BT.ETaskStatus.Running
    else
        if self.isTurning then
            self.isTurning = false
            Log.Debug('stop turning')
            wow.TurnStop()
            return BT.ETaskStatus.Running
        end
    end

    -- 攻击
    if wow.GetTime() > self.nextSpellTime then
        local spellName, time = self:GetNextSpell()
        self:CastSpell(spellName)
        self.nextSpellTime = wow.GetTime() + time
    end
    return BT.ETaskStatus.Running
end

function BT.MageAttack:CastSpell(spellName)
    if Player.IsCastable(spellName, 'target') then
        self.spellList[#self.spellList + 1] = spellName
        Player.CastSpell(spellName)
    end
end

function BT.MageAttack:GetNextSpell()
    local spell, time
    if #self.spellList == 0 then
        spell = '火球术'
        time = 2.5
    else
        if Target:Health() < 20 then
            spell = '火焰冲击'
            time = 1.5
        else
            spell = '寒冰箭'
            time = 1.7
        end
    end
    return spell, time
end
