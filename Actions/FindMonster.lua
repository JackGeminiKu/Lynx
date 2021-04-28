BT.FindMonster = {
    base = BT.Action
}

local this = BT.FindMonster
this.__index = this
setmetatable(this, this.base)

function BT.FindMonster:New(name)
    local o = self.base:New(name)
    setmetatable(o, this)
    o.monster = nil
    return o
end

function BT.FindMonster:OnStart()
    self.monster = self.bTree.sharedData:GetData("monster")
end

function BT.FindMonster:OnUpdate()
    local minDist = 10000
    local monster= nil
    for _, object in ipairs(Object:GetObjects(100)) do
        if object:Health() == 100 and object:CanAttack() and not object:IsPlayer() then
            if object:Distance() < minDist then
                minDist = object:Distance()
                monster = object
            end
        end
    end

    if monster ~= nil then
        self.monster.Value = monster
        Player.Target(monster)
        return BT.ETaskStatus.Success
    else
        return BT.ETaskStatus.Failure
    end
end
