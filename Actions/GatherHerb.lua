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
    o.herbName = nil
    o.herbCount = 0
    o.gatherTime = 3000
    return o
end

function BT.GatherHerb:OnStart()
    self.herbGuid = self.bTree.sharedData:GetData("herb guid")
    self.herbName = self.bTree.sharedData:GetData("herb name")
    self.herbCount = Bag.GetItemCount(self.herbName)
end

function BT.GatherHerb:OnUpdate()
    local herbGuid = self.herbGuid.value
    if herbGuid == nil then
        Log.WriteLine("采集草药失败, 没有设定采药点!")
        return BT.ETaskStatus.Failure
    end
    if not wow.ObjectExists(herbGuid) then
        Log.WriteLine("采集草药失败, 草药没了!")
        return BT.ETaskStatus.Failure
    end

    wow.GatherHerb(herbGuid)
    --wait 2000

    local herbCount = Bag.GetItemCount(self.herbName)
    if herbCount > self.herbCount then
        return BT.ETaskStatus.Success
    else
        return BT.ETaskStatus.Running
    end

    return BT.ETaskStatus.Success
end
