local inKeyBinding = false
local keybindTimeout = false
local binds = {}
local commands = {}
local isDead = false
local availableKeys = {
    "f2",
    "f4",
    "f5",
    "f7",
    "f9",
    "f10",
}

local firstSpawn = true
AddEventHandler('esx:playerLoaded', function()
    if firstSpawn then
        TriggerServerEvent('qb-commandbinding:server:getBinds')
        firstSpawn = false
    end
end)

AddEventHandler('esx:playerLoaded', function() isDead = false end)
AddEventHandler('esx:onPlayerDeath', function() isDead = true end)

RegisterNetEvent('qb-commandbinding:client:loadBinds')
AddEventHandler('qb-commandbinding:client:loadBinds', function(bindstable)
    binds = bindstable
end)

Citizen.CreateThread(function()
    for k, v in pairs(GetRegisteredCommands()) do
        commands[v.name] = true
    end
    for k, v in pairs(availableKeys) do
        if not commands['+commandbind-'..v] and not commands['-commandbind-'..v] then
            RegisterCommand('+commandbind-'..v, function()
                executeKeybind(v)
            end)
            RegisterCommand('-commandbind-'..v, function() end)
            RegisterKeyMapping('+commandbind-'..v, v..' Komut Ataması', 'keyboard', v)
        end
    end
end)

function disableKeybinds(value)
    inKeyBinding = value
end

function executeKeybind(key)
    if not isDead then
        if not inKeyBinding then
            if not keybindTimeout then
                local player = PlayerPedId()
                if not IsPedInAnyVehicle(player, true) then
                    if binds[key] and binds[key]['command'] and binds[key]['command'] ~= '' then
                        if not Config.Blacklist[binds[key]['command']] then
                            ExecuteCommand(binds[key]['command']..' '..binds[key]['argument'])
                            keybindTimeout = true
                            Citizen.Wait(2000)
                            keybindTimeout = false
                        else
                            exports.mythic_notify:DoHudText('error', 'Blacklist komut!')
                        end
                    else
                        exports.mythic_notify:DoHudText('error', 'Bu tuşa atanmış bir komutunuz yok! (Komut atamak için "/binds" komutunu kullanabilirsin.)')
                    end
                end
            else
                exports.mythic_notify:DoHudText('error', 'Bu işlemi bu kadar hızlı tekrarlayamazsınız!')
            end
        end
    end
end

RegisterNUICallback('close', function()
    inKeyBinding = false
    SetNuiFocus(false, false)
end)

RegisterNetEvent('qb-commandbinding:client:openUI')
AddEventHandler('qb-commandbinding:client:openUI', function(bindstable)
    SendNUIMessage({
        action = "openBinding",
        keyData = bindstable
    })
    inKeyBinding = true
    SetNuiFocus(true, true)
    SetCursorLocation(0.5, 0.5)
end)

RegisterNUICallback('save', function(data)
    local keyData = {
        ["f2"]  = {["command"] = data.keyData["f2"][1],  ["argument"] = data.keyData["f2"][2]},
        ["f4"]  = {["command"] = data.keyData["f4"][1],  ["argument"] = data.keyData["f4"][2]},
        ["f5"]  = {["command"] = data.keyData["f5"][1],  ["argument"] = data.keyData["f5"][2]},
        ["f7"]  = {["command"] = data.keyData["f7"][1],  ["argument"] = data.keyData["f7"][2]},
        ["f9"]  = {["command"] = data.keyData["f9"][1],  ["argument"] = data.keyData["f9"][2]},
        ["f10"] = {["command"] = data.keyData["f10"][1], ["argument"] = data.keyData["f10"][2]},
    }
    binds = keyData
    TriggerServerEvent('qb-commandbinding:server:saveBinds', keyData)
    exports.mythic_notify:DoHudText('inform', 'Tuş atamalarınız başarıyla kaydedildi.')
end)