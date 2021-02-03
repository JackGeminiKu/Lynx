
BT.TestShared1 = {
    base = BT.Action
}
local this = BT.TestShared1

this.__index = this
setmetatable(this, this.base)

function BT.TestShared1:New(name)
    local o = this.base:New(name)
    setmetatable(o, this)
    o.shared.value = Const.Empty
    o.value = Const.Empty
    return o
end

function BT.TestShared1:OnStart()
    self.shared.value = self.bTree.sharedData:GetData("testVal")
    self.value = "init1"
end

function BT.TestShared1:OnUpdate()
    self.sharedVal.value = "sharedVal: by TestShared1"
    self.value = "val: by TestShared1"
    LogMgr.Normal("1: " .. (self.sharedVal.value and self.sharedVal.value or Const.Empty) .. " " .. self.val)
    return BT.ETaskStatus.Success
end
