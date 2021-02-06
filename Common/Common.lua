Common = {}

function Common.TableFind(tab, val)
    for k, v in pairs(tab) do
        if v == val then
            return k
        end
    end
    return nil
end

function Common.TableRemove(tab, val)
    for k, v in pairs(tab) do
        if v == val then
            table.remove(tab, k)
            break
        end
    end
end

Const = {
    Empty = "none"
}

BT = {}

BT.EBTreeStatus = {
    None = "None",
    Pause = "Pause",
    Disabled = "Disabled",
    Active = "Active"
}

BT.ETaskStatus = {
    Inactive = "Inactive",
    Failure = "Failure",
    Success = "Success",
    Running = "Running" 
}

BT.ETaskType = {
    UnKnow = "Unknow",
    Composite = "Composite", -- 必须包含子节点
    Decorator = "Decorator", -- 必须包含子节点
    Action = "Action", -- 最终子节点
    Conditional = "Conditional" -- 最终子节点
}

BT.EAbortType = {
    None = 0,
    Self = 1,
    LowerPriority = 2,
    Both = 3
}

BT.ErrorRet = {
    ChildCountMin = "儿子个数过少",
    ChildCountMax = "儿子已满"
}