BT.FindHerb = {
    base = BT.Action
}
local this = BT.FindHerb
this.__index = this
setmetatable(this, this.base)

function BT.FindHerb:New(name)
    local o = this.base:New(name)
    setmetatable(o, this)
    o.herbGuid = nil
    o.herbName = nil
    o.herbLocation = nil
    o.herbHistory = nil
    return o
end

function BT.FindHerb:OnStart()
    self.herbGuid = self.bTree.sharedData:GetData('herb guid')
    self.herbName = self.bTree.sharedData:GetData('herb name')
    self.herbLocation = self.bTree.sharedData:GetData('destination', {})
    self.herbHistory = self.bTree.sharedData:GetData('herb history', {})
end

local _herbList = {
    ['宁神花'] = 0,
    ['银叶草'] = 0,
    ['石南草'] = 0,
    ['魔皇草'] = 75,
    ['地根草'] = 75
}

local CanGather = function(guid)
    if wow.UnitIsPlayer(guid) then
        return false
    end

    local objectName = wow.GetObjectName(guid)
    local playerSkill = 103
    for herbName, herbSkill in pairs(_herbList) do
        if objectName == herbName and playerSkill >= herbSkill then
            return true
        end
    end
    return false
end

function BT.FindHerb:OnUpdate()
    for _, guid in ipairs(wow.GetObjects(100)) do
        -- TBD: 草药被采集后, 一定时间能lb.GetObjects还是能返回它的GUID. 如果被别人采了, 怎么办?
        if self.herbHistory[guid] == nil or self.herbHistory[guid] - wow.GetTime() > 60 then
            if CanGather(guid) then
                local herbName = wow.GetObjectName(guid)
                self.herbGuid.value = guid
                self.herbName.value = herbName
                local x, y, z = wow.GetObjectPosition(guid)
                self:LogDebug('找到草药: %s (%f,%f,%f)', herbName, x, y, z)
                self.herbLocation.X = x
                self.herbLocation.Y = y
                self.herbLocation.Z = z
                return BT.ETaskStatus.Success
            end
        end
    end
    return BT.ETaskStatus.Running
end
