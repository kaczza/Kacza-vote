local currentVotes = {}
local voteOptions = {}
local voteCreator = nil
ESX = exports["es_extended"]:getSharedObject()

function isAdmin(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end
    local group = xPlayer.getGroup()
    for _, allowed in pairs(Config.AdminGroups) do
        if group == allowed then return true end
    end
    return false
end

RegisterServerEvent('ox_vote:createVote', function(title, options)
    local src = source
    if not isAdmin(src) then return end
    voteCreator = src

    currentVotes = {}
    voteOptions = {}
    for _, opt in pairs(options) do
        voteOptions[opt] = 0
    end

    for _, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('ox_vote:showVote', tonumber(playerId), {
            title = title,
            options = (function()
                local result = {}
                for _, opt in pairs(options) do
                    table.insert(result, {
                        title = opt,
                        icon = 'check',
                        onSelect = function()
                            TriggerServerEvent('ox_vote:submitVote', opt)
                        end
                    })
                end
                return result
            end)()
        })
    end

    TriggerClientEvent('ox_vote:openVoteStats', src, voteOptions)
end)

RegisterCommand('createvote', function(source)
    if not isAdmin(source) then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Hiba',
            description = 'Nincs jogosultságod szavazást indítani!',
            type = 'error'
        })
        return
    end
    TriggerClientEvent('ox_vote:startVoteInput', source)
end)

RegisterServerEvent('ox_vote:submitVote', function(option)
    local src = source
    if currentVotes[src] then return end

    currentVotes[src] = option
    voteOptions[option] = (voteOptions[option] or 0) + 1

    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Szavazat elküldve!',
        description = 'Köszönjük a szavazatot.',
        type = 'success'
    })

    PerformHttpRequest(Config.VoteWebhook, function() end, 'POST', json.encode({
        username = "Kz VoteSystem",
        embeds = {{
            title = "Új szavazat érkezett!",
            description = ("**Játékos ID:** %s\n**Szavazat:** %s"):format(src, option),
            color = 65280
        }}
    }), { ['Content-Type'] = 'application/json' })

    if voteCreator then
        TriggerClientEvent('ox_vote:updateVoteStats', voteCreator, voteOptions)
    end
end)