RegisterNetEvent('ox_vote:showVote', function(data)
    lib.registerContext({
        id = 'vote_menu',
        title = data.title,
        options = data.options
    })

    lib.showContext('vote_menu')
end)

RegisterNetEvent('ox_vote:sendVote', function(option)
    TriggerServerEvent('ox_vote:submitVote', option)
end)

RegisterNetEvent('ox_vote:startVoteInput', function()
    local title = lib.inputDialog('Create vote', {'Question / Title'})
    if not title or not title[1] or title[1] == '' then return end

    local options = {}

    for i = 1, 4 do
        local option = lib.inputDialog('Option #' .. i, {'Option (enter for skip)'})
        if not option or option[1] == '' then
            if i < 3 then
                lib.notify({ title = 'Hiba', description = '!', type = 'error' })
                return
            end
            break
        end
        table.insert(options, option[1])
    end

    if #options < 2 then
        lib.notify({ title = 'Hiba', description = 'Minimum 2 options!', type = 'error' })
        return
    end

    TriggerServerEvent('ox_vote:createVote', title[1], options)
end)

RegisterNetEvent('ox_vote:openVoteStats', function(votes)
    local options = {}
    for name, count in pairs(votes) do
        table.insert(options, {
            title = name,
            description = ('Votes: %d'):format(count),
            icon = 'check'
        })
    end

    lib.registerContext({
        id = 'vote_stats',
        title = 'Vote stats',
        options = options
    })

    lib.showContext('vote_stats')
end)

RegisterNetEvent('ox_vote:updateVoteStats', function(votes)
    local options = {}
    for name, count in pairs(votes) do
        table.insert(options, {
            title = name,
            description = ('Votes: %d'):format(count),
            icon = 'check'
        })
    end

    lib.updateContext('vote_stats', {
        id = 'vote_stats',
        title = 'Vote stats',
        options = options
    })
end)
