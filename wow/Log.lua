Log = {}

function Log.Write(...)
    local messages = {...}
    local message = ''
    for k, v in ipairs(messages) do
        if message == '' then
            message = v
        else
            message = message .. ', ' .. tostring(v)
        end
    end
    message = "[" .. wow.GetTime() .. "] " .. message
    print(message)
    if lb ~= nil then
        wow.WriteFile("E:\\lynx.log", message)
    end
end

function Log.WriteLine(...)
    local messages = {...}
    local message = ''
    for k, v in ipairs(messages) do
        if message == '' then
            message = v
        else
            message = message .. ', ' .. tostring(v)
        end
    end
    message = "[" .. wow.GetTime() .. "] " .. message
    print(message)
    if lb ~= nil then
        wow.WriteFile("E:\\lynx.log", message .. "\n")
    end
end
