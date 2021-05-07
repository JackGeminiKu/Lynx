BT.SelectCamp = {
    base = BT.Task
}
local this = BT.SelectCamp
this.__index = this
setmetatable(this, this.base)

function BT.SelectCamp:New(name)
    local o = this.base:New(name)
    o.CampName = nil
    o.CampPosition = {X = nil, Y = nil, Z = nil}
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
        if string.sub(name, 1, #zoneName + 1) == zoneName .. '_' then
            campDist = wow.CalculateDistance(Player:Position(), camp.Position)
            if campDist < minDist then
                minDist = campDist
                campName = name
                campPosition = camp.Position
            end
        end
    end
    if campName == '' then
        self:LogDebug('当前地区(%s)没有找到营地!', zoneName)
        return BT.ETaskStatus.Failure
    end
    self.CampName = campName
    self.CampPosition.X = campPosition.X
    self.CampPosition.Y = campPosition.Y
    self.CampPosition.Z = campPosition.Z
    return BT.ETaskStatus.Success
end
