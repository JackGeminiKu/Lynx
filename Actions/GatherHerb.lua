BT.GatherHerb = {
    base = BT.Action
}

local this = BT.GatherHerb
this.__index = this
setmetatable(this, this.base)

function BT.GatherHerb:New(name)
    local o = self.base:New(name)
    setmetatable(o, this)
    o.herbGuid = nil
    o.gatherTime = 3000
    return o
end

function BT.GatherHerb:OnStart()
    self.herbGuid = self.bTree.sharedData:GetData("herbGuid")
end

function BT.GatherHerb:OnUpdate()
    local herbGuid = self.herbGuid.val
    if herbGuid == nil or not wow.ObjectExists(herbGuid) then
        return BT.ETaskStatus.Success
    end
    lb.UnitTagHandler(InteractUnit, guid)
    return BT.ETaskStatus.Success
end