Log = {}

function Log.Write(...)
    if lb ~= nil then
        local messages = {...}
        local message = ''
        for k, v in ipairs(messages) do
            if message == '' then
                message = v
            else
                message = message .. ', ' .. v
            end
        end
        print(message)
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
    print(message)
    if lb ~= nil then
        wow.WriteFile("E:\\lynx.log", message .. '\n')
    end
end