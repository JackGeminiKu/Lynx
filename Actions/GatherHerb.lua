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
    local herbGuid = self.herbGuid.value
    if herbGuid == nil then
        Log.WriteLine("采集草药失败, 没有设定采药点!")
        return BT.ETaskStatus.Failure
    end
    if not wow.ObjectExists(herbGuid) then
        Log.WriteLine("采集草药失败, 采药没了!")
        return BT.ETaskStatus.Failure
    end
    wow.GatherHerb(herbGuid)
    return BT.ETaskStatus.Success
end
