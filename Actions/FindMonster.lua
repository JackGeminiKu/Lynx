BT.FindMonster = {
    base = BT.Action
}

local this = BT.FindMonster
this.__index = this
setmetatable(this, this.base)

function BT.FindMonster:New(name)
    local o = self.base:New(name)
    setmetatable(o, this)
    o.monsterGuid = nil
    return o
end

function BT.FindMonster:OnStart()
    self.monsterGuid = self.bTree.sharedData:GetData("monster guid")
end

function BT.FindMonster:OnUpdate()
    local minDist = 10000
    local monsterGuid = nil
    for _, object in ipairs(Object:GetObjects(100)) do
        if object:Health() == 100 and object:CanAttack() and not object:IsPlayer() then
            if object:Distance() < minDist then
                minDist = object:Distance()
                monsterGuid = object:GUID()
            end
        end
    end

    if monsterGuid ~= nil then
        self.monsterGuid.Value = monsterGuid
        return BT.ETaskStatus.Success
    else
        return BT.ETaskStatus.Failure
    end
end
