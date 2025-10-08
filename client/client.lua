
-- __| |____________________________________________| |__
--(__   ____________________________________________   __)
 --  | |                                            | |
---  | |                                            | |
   --| |                                            | |
   --| |            Script BY.: Kacza               | |
   --| |                                            | |
   --| |                                            | |
   --| |                                            | |
 --__| |____________________________________________| |__
--(__   ____________________________________________   __)
--   | |                                            | |

RegisterNUICallback("accept", function(_, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "hide" })
    TriggerServerEvent("eventInvite:accept")
    cb({})
end)


RegisterNUICallback("reject", function(_, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "hide" })
    TriggerServerEvent("eventInvite:reject")
    cb({})
end)


RegisterNetEvent("eventInvite:show", function(data)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action     = "show",
        name       = data.name,
        joined     = data.joined,
        maxPlayers = data.maxPlayers,
        showMax    = data.showMax
    })

    
     Citizen.SetTimeout(90000, function()
            SendNUIMessage({ action = "hide" })
            SetNuiFocus(false, false)
    end)


end)


RegisterNetEvent("eventInvite:updateCount", function(data)
    SendNUIMessage({
        action     = "updateCount",
        joined     = data.joined,
        maxPlayers = data.maxPlayers,
        showMax    = data.showMax
    })
end)


RegisterNetEvent("eventInvite:teleport", function(coords)
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
end)


RegisterNetEvent("eventInvite:hide", function()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "hide" })
end)

   


TriggerEvent('chat:addSuggestion', '/createevent',  "Create a",  { {name = "max_players", help = "Max Players"}, {name = "event_name", help = "Event name"}})