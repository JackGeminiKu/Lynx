BT.SelectCamp = {
    base = BT.Task
}
local this = BT.SelectCamp
this.__index = this
setmetatable(this, this.base)

function BT.SelectCamp:New(name)
    local o = this.base:New(name)
    o.CampName = nil
    o.CampPosition = {X = 1, Y = 1, Z = 1}
    setmetatable(o, this)
    return o
end

function BT.SelectCamp:OnStart()
    -- self.CampName = self.bTree.sharedData:GetData('camp name')
end

function BT.SelectCamp:OnUpdate()
    local zoneName = wow.GetZoneName()
    local minDist = 10000000
    local campDist = 0
    local campName = ''
    local campPosition = nil
    for name, camp in pairs(Camp) do
        LogDebug(name)
        if string.sub(name, 1, #zoneName + 1) == zoneName .. '_' then
            campDist = wow.CalculateDistance(Player:Position(), camp.Position)
            if campDist < minDist then
                minDist = campDist
                campName = name
                campPosition = camp.Position
            end
        end
    end
    self.CampName = campName
    self.CampPosition.X = campPosition.X
    self.CampPosition.Y = campPosition.Y
    self.CampPosition.Z = campPosition.Z
    return BT.ETaskStatus.Success
end
