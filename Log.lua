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
        lb.WriteFile("E:\\log-" .. lb.GetGameAccountName() .. ".txt", message, true)
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
        lb.WriteFile("E:\\log-" .. lb.GetGameAccountName() .. ".txt", message .. '\n', true)
    end
end