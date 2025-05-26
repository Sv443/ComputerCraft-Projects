INTERVAL = 0.05

local chat = peripheral.find("chatBox") or error("Chat Box peripheral not found!")

RUN_CMDS = {
    ["!calc"] = function (ctx, args)
        if #args < 3 or #args % 2 == 0 then
            chat.sendMessageToPlayer("Usage: !calc <num1> <operator> <num2> [<operator> <numN> ...]", ctx.username, "&cCALC", nil, "&4")
            return
        end

        local value = tonumber(args[1])
        if not value then
            chat.sendMessageToPlayer("Invalid number: " .. tostring(args[1]), ctx.username, "&cCALC", nil, "&4")
            return
        end

        local i = 2
        while i <= #args do
            local operator = args[i]
            local num = tonumber(args[i + 1])
            if not num then
                chat.sendMessageToPlayer("Invalid number: " .. tostring(args[i + 1]), ctx.username, "&cCALC", nil, "&4")
                return
            end

            if operator == "+" then
                value = value + num
            elseif operator == "-" then
                value = value - num
            elseif operator == "*" then
                value = value * num
            elseif operator == "/" then
                if num == 0 then
                    chat.sendMessageToPlayer("Cannot divide by zero.", ctx.username, "&cCALC", nil, "&4")
                    return
                end
                value = value / num
            elseif operator == "%" then
                if num == 0 then
                    chat.sendMessageToPlayer("Cannot modulo by zero.", ctx.username, "&cCALC", nil, "&4")
                    return
                end
                value = value % num
            elseif operator == "^" or operator == "**" then
                value = value ^ num
            elseif operator == "sqrt" then
                if num < 0 then
                    chat.sendMessageToPlayer("Cannot take square root of a negative number.", ctx.username, "&cCALC", nil, "&4")
                    return
                end
                value = math.sqrt(num)
            else
                chat.sendMessageToPlayer("Unknown operator: " .. tostring(operator), ctx.username, "&cCALC", nil, "&4")
                return
            end
            i = i + 2
        end

        chat.sendMessageToPlayer("Result: " .. tostring(value), ctx.username, "&eCALC", nil, "&6")
    end
}

function run()
    local event, username, message, uuid, isHidden = os.pullEvent("chat")

    if not message or message:sub(1, 1) ~= "!" then
        return
    end

    local i = 1
    local cmd = nil
    local args = {}
    for word in message:gmatch("%S+") do
        if i == 1 then
            cmd = word
        else
            args[i - 1] = word
        end
        i = i + 1
    end

    local ctx = {
        username = username,
        message = message,
        uuid = uuid,
        isHidden = isHidden
    }

    for command, func in pairs(RUN_CMDS) do
        if cmd == command then
            func(ctx, args)
            return
        end
    end
end

while true do
    run()
    sleep(INTERVAL)
end
