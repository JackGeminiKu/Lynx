local MAX_GATHER_COUNT = 3
local GATHER_TIME = 5.1

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
    o.herbHistory = nil
    o.gatherCount = 0
    o.lastHerbCount = 0
    o.lastGatherTime = 0
    return o
end

function BT.GatherHerb:OnStart()
    self.herbGuid = self.bTree.sharedData:GetValue("herb guid")
    self.herbName = self.bTree.sharedData:GetValue("herb name")
    self.herbHistory = self.bTree.sharedData:GetValue("herb history", {})
    self.gatherCount = 0
    self.lastHerbCount = Bag.GetItemCount(self.herbName)
    self.lastGatherTime = 0
end

function BT.GatherHerb:OnUpdate()
    local herbGuid = self.herbGuid
    if herbGuid == nil then
        Log.Error("没有设置草药GUID!")
        return BT.ETaskStatus.Success
    end
    if self.herbHistory[herbGuid] ~= nil and self.herbHistory[herbGuid] - wow.GetTime() < 60 then
        Log.Error("这个草药刚刚采集过!")
        return BT.ETaskStatus.Success
    end
    if not wow.ObjectExists(herbGuid) then
        Log.Debug("草药不见了, 可能被别人采了!")
        return BT.ETaskStatus.Success
    end

    if Bag.GetItemCount(self.herbName) > self.lastHerbCount then
        Log.Debug("存入背包: %s", self.herbName)
        self.herbHistory[herbGuid] = wow.GetTime()
        return BT.ETaskStatus.Success
    end

    if wow.GetTime() - self.lastGatherTime > GATHER_TIME then
        self.lastGatherTime = wow.GetTime()
        self.gatherCount = self.gatherCount + 1
        if self.gatherCount > MAX_GATHER_COUNT then
            Log.Error("采集次数已达上限, 放弃吧!")
            return BT.ETaskStatus.Success
        end
        Log.Debug("开始采集: %s", self.herbName)
        wow.GatherHerb(herbGuid)
    end
    return BT.ETaskStatus.Running
end
