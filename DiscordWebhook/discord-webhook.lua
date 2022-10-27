-- URL shown after creating a channel webhook
WEBHOOK_URL = ""
-- the message to send
MESSAGE = "yo waddup"
-- the side that the button is attached to
BUTTON_SIDE = "front"

function run()
    local input
    while true do
        input = redstone.getInput(BUTTON_SIDE)
        if input then
            sendMsg(MESSAGE)
            os.sleep(1)
        end
        os.sleep(0.1)
    end
end

run()

-- sends a simple message to WEBHOOK_URL
-- returns the request body as a string on success, or nil on error
function sendMsg(msg)
    local data = "{" .. '"content": "' .. msg .. '"' .. "}"
    local headers = {}
    headers["content-type"] = "application/json"

    http.request(WEBHOOK_URL, data, headers)

    while true do
        local event, url, body = os.pullEvent()

        if event == "http_success" then
            return body
        elseif event == "http_failure" then
            return nil
        end
    end
end
