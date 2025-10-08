ESX = exports['es_extended']:getSharedObject()
local eventCoords = nil
local joinedPlayers = {}

local webhookURL = Config.EventWebhook 

local function sendDiscordLog(adminName, eventName, maxPlayers)
    local connect = {
        {
            ["color"] = 3447003,
            ["title"] = "🎯 Event created",
            ["fields"] = {
                { ["name"] = "💂Admin", ["value"] = adminName, ["inline"] = true },
                { ["name"] = "🎮Event name", ["value"] = eventName, ["inline"] = true },
                { ["name"] = "👥Max players", ["value"] = tostring(maxPlayers), ["inline"] = true },
                { ["name"] = "🕒Time", ["value"] = os.date("%Y-%m-%d %H:%M:%S"), ["inline"] = false }
            },
            ["footer"] = {
                ["text"] = "Kz scripts"
            }
        }
    }

    PerformHttpRequest(webhookURL, function(err, text, headers) end, 'POST', json.encode({username = "Kz Events", embeds = connect}), { ['Content-Type'] = 'application/json' })
end

RegisterCommand("createevent", function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local group = xPlayer.getGroup()

    local allowed = false
    for _, g in ipairs(Config.AdminGroups) do
        if group == g then
            allowed = true
            break
        end
    end
    if not allowed then
        TriggerClientEvent('chat:addMessage', source, {
            args = {"[Rendszer]", "You don't have permission to do that"}
        })
        return
    end

    local name = table.concat(args, " ", 2)
    if name == "" then
        TriggerClientEvent('chat:addMessage', source, {
            args = {"[Rendszer]", "Usage: /createevent [Max players] [Event name]"}
        })
        return
    end
    local maxPlayers = tonumber(args[1]) or 0

    eventCoords = GetEntityCoords(GetPlayerPed(source))
    joinedPlayers = {}

    for _, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent("eventInvite:show", playerId, {
            name       = name,
            joined     = 0,
            maxPlayers = maxPlayers,
            showMax    = (maxPlayers > 0)
        })
    end

   
    sendDiscordLog(xPlayer.getName(), name, maxPlayers)
end, false)


RegisterNetEvent("eventInvite:accept")
AddEventHandler("eventInvite:accept", function()
    local src = source
    if not eventCoords then return end

    if not joinedPlayers[src] then
        joinedPlayers[src] = true
    end

    local joinedCount = 0
    for _ in pairs(joinedPlayers) do joinedCount = joinedCount + 1 end

    local maxPlayers = nil
    maxPlayers = tonumber(args and args[2]) or 0

    for _, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent("eventInvite:updateCount", playerId, {
            joined     = joinedCount,
            maxPlayers = maxPlayers,
            showMax    = (maxPlayers > 0)
        })
    end

    TriggerClientEvent("eventInvite:teleport", src, eventCoords)
end)


RegisterNetEvent("eventInvite:reject")
AddEventHandler("eventInvite:reject", function()
    TriggerClientEvent("eventInvite:hide", source)
end)
