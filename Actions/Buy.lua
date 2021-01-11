BT.Buy = {Base = BT.Action}
local this = BT.Buy
this.__index = this
setmetatable(this, this.Base)

function BT.Buy:New(name)
    local o = this.Base:New(name)
    o.nextTime = os.time()
    o.count = 3
    setmetatable(o, this)
    return o
end

function BT.Buy:OnUpdate()
    if os.time() > self.nextTime then
        print('[buy] ' .. os.time())
        self.count = self.count - 1
        self.nexttime = os.time() + math.random(1, 3)
    end

    if self.count == 0 then
        return BT.ETaskStatus.Success
    else
        return BT.ETaskStatus.Running
    end
    -- Player.Interact(Target)
end
