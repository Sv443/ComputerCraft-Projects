INTERVAL = 0.05

local chat = peripheral.find("chatBox") or error("Chat Box peripheral not found!")

RUN_CMDS = {
    ["!calc"] = function (ctx, args)
        if #args < 3 or #args % 2 == 0 then
            chat.sendMessage("Usage: !calc <num1> <operator> <num2> [<operator> <numN> ...]", "&cCALC", nil, "&4")
            return
        end

        local value = tonumber(args[1])
        if not value then
            chat.sendMessage("Invalid number: " .. tostring(args[1]), "&cCALC", nil, "&4")
            return
        end

        local i = 2
        while i <= #args do
            local operator = args[i]
            local num = tonumber(args[i + 1])
            if not num then
                chat.sendMessage("Invalid number: " .. tostring(args[i + 1]), "&cCALC", nil, "&4")
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
                    chat.sendMessage("Cannot divide by zero.", "&cCALC", nil, "&4")
                    return
                end
                value = value / num
            elseif operator == "%" then
                if num == 0 then
                    chat.sendMessage("Cannot modulo by zero.", "&cCALC", nil, "&4")
                    return
                end
                value = value % num
            elseif operator == "^" or operator == "**" then
                value = value ^ num
            elseif operator == "root" or operator == "r" then
                if value < 0 then
                    chat.sendMessage("Cannot take square root of a negative number.", "&cCALC", nil, "&4")
                    return
                end
                if num <= 0 then
                    chat.sendMessage("Cannot take " .. num .. "-th root.", "&cCALC", nil, "&4")
                    return
                end
                value = value ^ (1 / num)
            else
                chat.sendMessage("Unknown operator: " .. tostring(operator), "&cCALC", nil, "&4")
                return
            end
            i = i + 2
        end

        local calcRes = tostring(value)

        local message = {
            {
                text = "[",
                color = "gold",
                clickEvent = {
                    action = "open_url",
                    value = b64dec("aHR0cHM6Ly9yZS5zdjQ0My5uZXQvY2MtcHJvamVjdHM=")
                },
                hoverEvent = {
                    action = "show_text",
                    value = "Click to open the repository for this project."
                }
            },
            {
                text = "CALC",
                color = "yellow",
                clickEvent = {
                    action = "open_url",
                    value = b64dec("aHR0cHM6Ly9yZS5zdjQ0My5uZXQvY2MtcHJvamVjdHM=")
                },
                hoverEvent = {
                    action = "show_text",
                    value = "Click to open the repository for this project."
                }
            },
            {
                text = "]",
                color = "gold",
                clickEvent = {
                    action = "open_url",
                    value = b64dec("aHR0cHM6Ly9yZS5zdjQ0My5uZXQvY2MtcHJvamVjdHM=")
                },
                hoverEvent = {
                    action = "show_text",
                    value = "Click to open the repository for this project."
                }
            },
            {
                text = " Result: " .. calcRes,
                color = "white"
            }
        }

        chat.sendFormattedMessage(textutils.serialiseJSON(message), "@" .. ctx.username, "()")
    end
}

function b64dec(data)
    local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    data = string.gsub(data, "[^"..b.."=]", "")
 
    return (data:gsub(".", function(x)
        if x == "=" then return "" end
        local r, f = "", (b:find(x) - 1)
        for i = 6, 1, -1 do
            r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and "1" or "0")
        end
        return r
    end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(x)
        if #x ~= 8 then return "" end
        local c = 0
        for i = 1, 8 do
            c = c + (x:sub(i, i) == "1" and 2 ^ (8 - i) or 0)
        end
        return string.char(c)
    end))
end

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

-- cause pastebin hates links
print(b64dec("CnwgQ2hhdENhbGN1bGF0b3IgYnkgU3Y0NDMKfCBodHRwczovL3JlLnN2NDQzLm5ldC9jYy1wcm9qZWN0cwo="))
print("Type !calc <num1> <operator> <num2> [<operator> <numN> ...] in chat to calculate.\n")
print("Operators: +, -, *, /, %, ^ or **, root or r\n")

while true do
    run()
    sleep(INTERVAL)
end
