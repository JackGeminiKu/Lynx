local MAX_GATHER_COUNT = 3
local GATHER_TIME = 3


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
    o.gatherCount = 0
    o.lastHerbCount = 0
    o.lastGatherTime = 0
    return o
end

function BT.GatherHerb:OnStart()
    self.herbGuid = self.bTree.sharedData:GetData("herb guid")
    self.herbName = self.bTree.sharedData:GetData("herb name")
    self.lastHerbCount = Bag.GetItemCount(self.herbName)
    self.lastGatherTime = 0
end

function BT.GatherHerb:OnUpdate()
    local herbGuid = self.herbGuid.value
    if herbGuid == nil then
        Log.Error("没有设置草药GUID!")
        return BT.ETaskStatus.Success
    end
    if not wow.ObjectExists(herbGuid) then
        Log.Debug("草药不见了!")
        return BT.ETaskStatus.Success
    end

    if wow.GetTime() - self.lastGatherTime > GATHER_TIME then
        self.lastGatherTime = wow.GetTime()
        self.gatherCount = self.gatherCount + 1
        if self.gatherCount > MAX_GATHER_COUNT then
            return BT.ETaskStatus.Success
        end
        wow.GatherHerb(herbGuid)
    else
        if Bag.GetItemCount(self.herbName) > self.lastHerbCount then
            return BT.ETaskStatus.Success
        end
    end

    return BT.ETaskStatus.Running
end
