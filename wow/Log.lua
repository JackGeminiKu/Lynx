Log = {}
LogType = {
    Debug = "debug",
    Error = "error"
}

local function WriteLine(type, message)
    message = string.format("[%.3f] [%s]: %s", wow.GetTime(), type, message)
    print(message)
    if lb ~= nil then
        wow.WriteFile("E:\\lynx.log", message .. "\n")
        if type == LogType.Error then
            wow.WriteFile("E:\\lynx_error.log", message .. "\n")
        end
    end
end

function Log.Debug(message)
    WriteLine(LogType.Debug, message)
end

function Log.Error(message)
    WriteLine(LogType.Error, message)
end
