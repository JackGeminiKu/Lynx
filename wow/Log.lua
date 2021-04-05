Log = {}
LogType = {
    Debug = "debug",
    Error = "error"
}

local function WriteLine(type, message)
    message = string.format("[%.3f] [%s] %s", wow.GetTime(), type, message)
    print(message)
    wow.WriteFile("E:\\lynx.log", message .. "\n")
    if type == LogType.Error then
        wow.WriteFile("E:\\lynx_error.log", message .. "\n")
    end
end

function Log.Debug(formatstring, ...)
    WriteLine(LogType.Debug, string.format(formatstring, ...))
end

function Log.Error(formatstring, ...)
    WriteLine(LogType.Error, string.format(formatstring, ...))
end
