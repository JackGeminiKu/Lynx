BT.FindMonster = {
    base = BT.Action
}

local this = BT.FindMonster
this.__index = this
setmetatable(this, this.base)

function BT.FindMonster:New(name)
    local o = self.base:New(name)
    setmetatable(o, this)
    o.target = nil
    return o
end

function BT.FindMonster:OnStart()
    self.target = self.bTree.sharedData:GetData("target")
end

function BT.FindMonster:OnUpdate()
    local minDist = 10000
    local target= nil
    for _, object in ipairs(Object:GetObjects(100)) do
        if object:Health() == 100 and object:CanAttack() and not object:IsPlayer() then
            if object:Distance() < minDist then
                minDist = object:Distance()
                target = object
            end
        end
    end

    if target ~= nil then
        self.target.Value = target
        Player.Target(target)
        return BT.ETaskStatus.Success
    else
        return BT.ETaskStatus.Failure
    end
end
