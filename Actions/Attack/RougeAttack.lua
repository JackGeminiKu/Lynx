BT.RougeAttack = {
    base = BT.Action
}
local this = BT.RougeAttack
this.__index = this
setmetatable(this, this.base)

function BT.RougeAttack:New(name)
    local o = this.base:New(name)
    o.nextSpellTime = wow.GetTime()
    o.spellList = {}
    o.isTurning = false
    o.target = nil
    setmetatable(o, this)
    return o
end

function BT.RougeAttack:OnStart()
    self.spellList = {}
    self.target = self.bTree.sharedData:GetData('target').value
    Player.Target(self.bTree.sharedData:GetData('target').value)
end

function BT.RougeAttack:OnUpdate()
    -- 战斗结束了?
    if self.target:IsDead() and not Player:IsInCombat() then
        self.spellList = {}
        return BT.ETaskStatus.Success
    end

    -- -- 停下来
    -- if Player:IsMoving() then
    --     Player.StopMove()
    --     return BT.ETaskStatus.Running
    -- end

    -- 没有目标
    if not Player:HasTarget() then
        return BT.ETaskStatus.Running
    end

    -- 调整方向
    local facing = Player:Facing()
    local facing2 = Player.CalTargetFacing()
    if math.abs(facing - facing2) > math.pi / 180 * 60 then
        self:LogDebug('%.1f, %.1f, %.1f', math.deg(facing), math.deg(facing2), math.deg(facing - facing2))
        if not self.isTurning then
            self.isTurning = true
            Player.TurnStart()
        end
        return BT.ETaskStatus.Running
    else
        if self.isTurning then
            self:LogDebug('%.1f, %.1f, %.1f', math.deg(facing), math.deg(facing2), math.deg(facing - facing2))
            self.isTurning = false
            Player.TurnStop()
            return BT.ETaskStatus.Running
        end
    end

    -- 攻击
    Player.StartAttack()
    if wow.GetTime() > self.nextSpellTime then
        local spellName, time = self:GetNextSpell()
        if Player.IsCastable(spellName, 'target') then
            self:CastSpell(spellName)
            self.nextSpellTime = wow.GetTime() + time
        end
    end
    return BT.ETaskStatus.Running
end

function BT.RougeAttack:CastSpell(spellName)
    self.spellList[#self.spellList + 1] = spellName
    Player.CastSpell(spellName)
end

function BT.RougeAttack:GetNextSpell()
    local spellCount = #self.spellList
    if
        spellCount >= 3 and self.spellList[spellCount] == '邪恶攻击' and self.spellList[spellCount - 1] == '邪恶攻击' and
            self.spellList[spellCount - 2] == '邪恶攻击'
     then
        return '刺骨', 1
    else
        return '邪恶攻击', 1
    end
end
