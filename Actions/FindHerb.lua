BT.FindHerb = {
    base = BT.Action
}
local this = BT.FindHerb
this.__index = this
setmetatable(this, this.base)

function BT.FindHerb:New(name)
    local o = self.base:New(name)
    setmetatable(o, this)
    o.herbGuid = nil
    o.herbName = nil
    o.destination = nil
    o.herbHistory = nil
    return o
end

function BT.FindHerb:OnStart()
    self.herbGuid = self.bTree.sharedData:GetData("herb guid")
    self.herbName = self.bTree.sharedData:GetData("herb name")
    self.herbLocation = self.bTree.sharedData:GetValue("destination", {})
    self.herbHistory = self.bTree.sharedData:GetValue("herb history", {})
end

local _herbList = {
    ["宁神花"] = 0,
    ["石南草"] = 0,
    ["魔皇草"] = 75
}

local CanGather = function(guid)
    -- TBD: 如果玩家名字是"宁神花", 怎么办?
    local objectName = wow.GetObjectName(guid)
    local playerSkill = 0
    for herbName, herbSkill in ipairs(_herbList) do
        if objectName == herbName and playerSkill >= herbSkill then
            return true
        end
    end
    return false
end

function BT.FindHerb:OnUpdate()
    for _, guid in ipairs(lb.GetObjects(100)) do
        -- TBD: 草药被采集后, 一定时间能lb.GetObjects还是能返回它的GUID. 如果被别人采了, 怎么办?
        if self.herbHistory[guid] == nil or self.herbHistory[guid] - wow.GetTime() > 60 then
            if CanGather(guid) then
                self.herbGuid.value = guid
                self.herbName.value = wow.GetObjectName(guid)
                local x, y, z = wow.GetObjectPosition(guid)
                self.herbLocation = {
                    x = x,
                    y = y,
                    z = z
                }
                return BT.ETaskStatus.Success
            end
        end
    end
    return BT.ETaskStatus.Running
end
