-- URL shown after creating a channel webhook
DISCORD_WH_URL = ""
-- the message to send
MESSAGE = "yo waddup"
-- the side that the button is attached to
BUTTON_SIDE = "front"

function run()
    local input
    while true do
        input = redstone.getInput(BUTTON_SIDE)

        -- if the button is pressed
        if input then
            sendMsg(MESSAGE)

            -- wait for the button signal to turn off
            while input do
                input = redstone.getInput(BUTTON_SIDE)
                os.sleep(0.5)
            end
        end
        os.sleep(0.1) -- loop every redstone tick
    end
end

run()

-- sends a simple message to the webhook at DISCORD_WH_URL
-- returns the request body as a string on success, or nil on error
function sendMsg(msg)
    local data = '{"content":"' .. msg .. '"}'
    local headers = {}
    -- the default is text/plain which Discord doesn't accept
    headers["content-type"] = "application/json"

    http.request(DISCORD_WH_URL, data, headers)

    while true do
        local event, url, body = os.pullEvent()

        if event == "http_success" then
            return body
        elseif event == "http_failure" then
            return nil
        end
    end
end
