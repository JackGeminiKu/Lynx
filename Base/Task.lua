require("Common/Common")

BT.Task = {
    bTree = nil,
    base = nil
}
local this = BT.Task
this.__index = this

function BT.Task:New(name)
    local o = {}
    setmetatable(o, this)
    o.sName = name or Const.Empty
    return o
end

function BT.Task:Init(bTree)
    self.bTree = bTree
end

function BT.Task:SetName(name)
    self.sName = name
end

function BT.Task:CheckType(type)
    local task = self
    while true do
        if task.base == nil then
            return false
        end
        if task.base == type then
            return true
        end
        task = task.base
    end
end

function BT.Task:CanExcuteParallel()
    return false
end

function BT.Task:OnAwake()
end

function BT.Task:OnStart()
end

function BT.Task:OnUpdate()
end

function BT.Task:OnPause(bPause)
end

function BT.Task:OnEnd()
end

function BT.Task:OnConditionalAbort()
end
