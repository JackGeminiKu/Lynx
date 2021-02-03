
BT.TestShared2 = {
    base = BT.Action
}
local this = BT.TestShared2

this.__index = this
setmetatable(this, this.base)

function BT.TestShared2:New(name)
    local o = this.base:New(name)
    setmetatable(o, this)
    o.shared.value = Const.Empty
    o.value = Const.Empty
    return o
end

function BT.TestShared2:OnStart()
    self.shared.value = self.bTree.sharedData:GetData("testVal")
    self.value = "init2"
end

function BT.TestShared2:OnUpdate()
    self.sharedVal.value = "sharedVal: by TestShared2"
    self.value = "val: by TestShared2"
    LogMgr.Normal("2: " .. (self.sharedVal.value and self.sharedVal.value or Const.Empty) .. " " .. self.val)
    return BT.ETaskStatus.Success
end
