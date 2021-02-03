BT.Shared = {}
BT.Shared.__index = BT.Shared

function BT.Shared:New()
    local o = {}
    setmetatable(o, BT.Shared)
    o.data = {} -- value is [name] = {name = name,value = value}
    return o
end

function BT.Shared:GetData(name)
    if self.data[name] == nil then
        self.data[name] = {
            name = name,
            value = nil
        }
    end
    return self.data[name]
end

function BT.Shared:GetNullData(name)
    if self.data[name] ~= nil then
        return nil
    end
    return self:GetData(name)
end

function BT.Shared:SetDestination(x, y, z) 

end

function BT.Shared:GetDestination()

end
