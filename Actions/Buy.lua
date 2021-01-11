BT.Buy = {Base = BT.Action}
local this = BT.Buy
this.__index = this
setmetatable(this, this.Base)

function BT.Buy:New(name)
    local o = this.Base:New(name)
    o.nextTime = wow.GetTime()
    o.count = 3
    setmetatable(o, this)
    return o
end

function BT.Buy:OnUpdate()
    -- Player.Buy(1)
    -- return BT.ETaskStatus.Success

    if wow.GetTime() > self.nextTime then
        Log.WriteLine(wow.GetTime() .. ": buy index 1")
        Player.Buy(1)
        self.count = self.count - 1
        self.nexttime = wow.GetTime() + math.random(100, 900) / 1000
    end

    if self.count == 0 then
        return BT.ETaskStatus.Success
    else
        return BT.ETaskStatus.Running
    end
end
