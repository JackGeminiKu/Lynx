BT.Attack= {
    Base = BT.Action
}
local this = BT.Attack
this.__index = this
setmetatable(this, this.Base)

function BT.Attack:New(name)
    local o = this.base:New(name)
    o.nextSpellTime = wow.GetTime()
    o.spellList = {}
    setmetatable(o, this)
    return o
end

function BT.Attack:OnUpdate()
    if Target:IsDead() or not Player:HasTarget() then
        self.spellList = {}
        return BT.ETaskStatus.Success
    end
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

function BT.Attack:GetNextSpell()
    local spell, time
    if #self.spellList == 0 then
        spell = '炎爆术'
        time =4.5
    else
        spell = '寒冰箭'
        time = 2.1
    end
    return spell, time
end