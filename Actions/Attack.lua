BT.Attack = {
    Base = BT.Action
}
local this = BT.Attack
this.__index = this
setmetatable(this, this.Base)

function BT.Attack:New(name)
    local o = this.base:New(name)
    o.nextSpellTime = wow.GetTime()
    o.spellList = {}
    o.isTurning = false
    setmetatable(o, this)
    return o
end

function BT.Attack:OnUpdate()
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
    local facing2 = CalculateDirection()
    Log.Debug("%.1f, %.1f, %.1f / %.1f", math.deg(facing), math.deg(facing2), math.deg(facing - facing2), facing - facing2)
    if math.abs(facing - facing2) > math.pi / 180 * 60 then
        if not self.isTurning then
            self.isTurning = true
            Log.Debug("start turning")
            wow.TurnStart()
        end
        -- FaceDirection(facing2 + math.random(-200, 200) / 1000)
        -- self.nextSpellTime = self.nextSpellTime + 0.1
        return BT.ETaskStatus.Running
    else
        if self.isTurning then
            self.isTurning = false
            Log.Debug("stop turning")
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

function BT.Attack:CastSpell(spellName)
    self.spellList[#self.spellList + 1] = spellName
    Player.CastSpell(spellName, false)
end

function AutoShoot()
    wow.RunMacroText("/cast 射击")
end

function CalculateDirection()
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

function FaceDirection(angle)
    Player.FaceDirection(angle)
end

function FaceTarget()
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
    angle = angle + math.random(-100, 100) / 10

    Player.FaceDirection(angle)
end

function BT.Attack:GetNextSpell()
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
