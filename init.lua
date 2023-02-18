require("socket")
require("ssl")

local json = require "json"
local https = require 'ssl.https'

local Webhooks = { -- Set your webhooks here!
    -- webhooName  -> link 
    ['default'] = '',
}

local Colors = { -- https://www.spycolor.com/
    ['default'] = 14423100,
    ['blue'] = 255,
    ['red'] = 16711680,
    ['green'] = 65280,
    ['white'] = 16777215,
    ['black'] = 0,
    ['orange'] = 16744192,
    ['yellow'] = 16776960,
    ['pink'] = 16761035,
    ["lightgreen"] = 65309,
}

function HLHttpRequest(url, json, headers)
    local res, code, headers, status = https.request {
        method = "POST",
        url = url,
        source = json,
        headers = headers,
    }
end


function LogDiscord(name, title, color, message, tagEveryone)
    local tag = tagEveryone or false
    local webHook = Webhooks[name] or Webhooks['default']
    local embedData = {
        {
            ['title'] = title,
            ['color'] = Colors[color] or Colors['default'],
            ['footer'] = {
                ['text'] = os.date('%c'),
            },
            ['description'] = message,
            ['author'] = {
                ['name'] = 'HogWrap',
                ['icon_url'] = '',
            },
        }
    }
    HLHttpRequest(webHook, json.encode({ username = 'HogWrap', embeds = embedData}), { ['Content-Type'] = 'application/json' })
    Citizen.Wait(100)
    if tag then
        HLHttpRequest(webHook, json.encode({ username = 'HogWrap', content = '@everyone'}), { ['Content-Type'] = 'application/json' })
    end
end

-- Currently only logging when players join and leave.

registerForEvent("player_joined", function()
    LogDiscord('default', 'Join', 'green', 'A new player as joined!')
end)

registerForEvent("player_left ", function()
    LogDiscord('default', 'Left', 'red', 'A player as left!')
end)

registerForEvent("init", function()
    print("Loaded discordLogs!")
    LogDiscord('default', 'Loaded!', 'green', 'discordLogs have been loaded!')
end)