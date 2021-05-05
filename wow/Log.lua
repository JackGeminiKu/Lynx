Log = {}
LogType = {
    Debug = 'debug',
    Error = 'error'
}

local function WriteLine(type, message)
    message = string.format('[%.3f] [%s] %s', wow.GetTime(), type, message)
    print(message)
    wow.WriteFile('E:\\lynx.log', message .. '\n')
    if type == LogType.Error then
        wow.WriteFile('E:\\lynx_error.log', message .. '\n')
    end
end

function Log.Debug(formatstring, ...)
    local args = {...}
    for i = 1, select("#", ...) do
        local v = select(i, ...)
        if v == nil then
            args[i] = 'nil'
        end
    end
    WriteLine(LogType.Debug, string.format(formatstring, unpack(args)))
end

function Log.Error(formatstring, ...)
    local args = {...}
    for k, v in ipairs(args) do
        if v == nil then
            args[k] = 'nil'
        end
    end
    WriteLine(LogType.Error, string.format(formatstring, unpack(args)))
end
