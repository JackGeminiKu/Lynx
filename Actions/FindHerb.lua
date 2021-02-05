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
    return o
end

function BT.FindHerb:OnStart()
    self.herbGuid = self.bTree.sharedData:GetData("herb guid")
    self.herbName = self.bTree.sharedData:GetData("herb name")
    self.herbLocation = self.bTree.sharedData:GetData("destination")
end

function BT.FindHerb:OnUpdate()
    for _, guid in ipairs(lb.GetObjects(100)) do
        local objectName = wow.ObjectName(guid)
        if objectName == "宁神花" or objectName == "石南草" or objectName == "魔皇草" then
            self.herbGuid.value = guid
            self.herbName.value = objectName
            local x, y, z = wow.ObjectPosition(guid)
            self.herbLocation.value = {x = x, y = y, z = z}
            return BT.ETaskStatus.Success
        end
    end
    return BT.ETaskStatus.Running
end