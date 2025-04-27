local FLEECA_LOCATIONS = {
    fleeca_hawick_east = {
        id = "fleeca_hawick_east",
        label = "East Hawick Ave",
    },
    fleeca_hawick_west = {
        id = "fleeca_hawick_west",
        label = "West Hawick Ave",
    },
    fleeca_delperro = {
        id = "fleeca_delperro",
        label = "Boulevard Del Perro",
    },
    fleeca_great_ocean = {
        id = "fleeca_great_ocean",
        label = "Great Ocean Highway",
    },
    fleeca_route68 = {
        id = "fleeca_route68",
        label = "Route 68",
    },
    fleeca_vespucci = {
        id = "fleeca_vespucci",
        label = "Vespucci Blvd",
    },
}

function GetSpawnLocations()
    local p = promise.new()

    Database.Game:find({
        collection = 'locations',
        query = {
            Type = 'spawn'
        }
    }, function(success, results)
        if success and #results > 0 then
            p:resolve(results)
        else
            p:resolve(false)
        end
    end)

    local res = Citizen.Await(p)
    return res
end

local webhookUrl = "WEBHOOK-WEBHOOK"

local roleHierarchy = {
    Developer = 1,
    Owner = 2,
    Admin = 3,
    Staff = 4,
    Mod = 5,
    Support = 6,
    Whitelisted = 7
}

local superAdmins = {
    ["76561198825297639"] = true,
    ["NILL"] = true,
    ["NILL"] = true,
    ["NILL"] = true
}

function RegisterCallbacks()
    Callbacks:RegisterServerCallback('Admin:GetPlayerList', function(source, data, cb)
        
        local player = Fetch:Source(source)
        if player and player.Permissions:IsSupport() then
            local data = {}
            local activePlayers = Fetch:All()

            for k, v in pairs(activePlayers) do
                if v and v:GetData('AccountID') then
                    local char = v:GetData('Character')
                    table.insert(data, {
                        Source = v:GetData('Source'),
                        Name = v:GetData('Name'),
                        AccountID = v:GetData('AccountID'),
                        Identifier = v:GetData('Identifier'),
                        Character = char and {
                            First = char:GetData('First'),
                            Last = char:GetData('Last'),
                            SID = char:GetData('SID'),
                        } or false,
                    })
                end
            end
            cb(data)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Admin:GetDisconnectedPlayerList', function(source, data, cb)
        
        local player = Fetch:Source(source)
        if player and player.Permissions:IsSupport() then
            local rDs = exports['mythic-base']:FetchComponent('RecentDisconnects')
            cb(rDs)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Admin:GetPlayer', function(source, data, cb)
        
        local player = Fetch:Source(source)
        if player and player.Permissions:IsSupport() then
            local target = Fetch:Source(data)

            if target then
                local staffGroupName = false
                if target.Permissions:IsSupport() then
                    local highestLevel = 0
                    for k, v in ipairs(target:GetData('Groups')) do
                        if C.Groups[tostring(v)] ~= nil and (type(C.Groups[tostring(v)].Permission) == 'table') then
                            if C.Groups[tostring(v)].Permission.Level > highestLevel then
                                highestLevel = C.Groups[tostring(v)].Permission.Level
                                staffGroupName = C.Groups[tostring(v)].Name
                            end
                        end
                    end
                end

                local coords = GetEntityCoords(GetPlayerPed(target:GetData('Source')))

                local char = target:GetData('Character')
                local tData = {
                    Source = target:GetData('Source'),
                    Name = target:GetData('Name'),
                    AccountID = target:GetData('AccountID'),
                    Identifier = target:GetData('Identifier'),
                    Level = target.Permissions:GetLevel(),
                    Groups = target:GetData('Groups'),
                    StaffGroup = staffGroupName,
                    Character = char and {
                        First = char:GetData('First'),
                        Last = char:GetData('Last'),
                        SID = char:GetData('SID'),
                        DOB = char:GetData('DOB'),
                        Phone = char:GetData('Phone'),
                        Jobs = char:GetData('Jobs'),
                        Coords = {
                            x = coords.x,
                            y = coords.y,
                            z = coords.z
                        }
                    } or false,
                }

                cb(tData)
            else
                local rDs = exports['mythic-base']:FetchComponent('RecentDisconnects')
                for k, v in ipairs(rDs) do
                    if v.Source == data then
                        local tData = v

                        if tData.IsStaff then
                            local highestLevel = 0
                            for k, v in ipairs(tData.Groups) do
                                if C.Groups[tostring(v)] ~= nil and (type(C.Groups[tostring(v)].Permission) == 'table') then
                                    if C.Groups[tostring(v)].Permission.Level > highestLevel then
                                        highestLevel = C.Groups[tostring(v)].Permission.Level
                                        tData.StaffGroup = C.Groups[tostring(v)].Name
                                    end
                                end
                            end
                        end

                        tData.Disconnected = true
                        tData.Reconnected = false

                        for k, v in pairs(Fetch:All()) do
                            if v:GetData('AccountID') == tData.AccountID then
                                tData.Reconnected = k
                            end
                        end

                        cb(tData)
                        return
                    end
                end

                cb(false)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Admin:BanPlayer', function(source, data, cb)
        
        local player = Fetch:Source(source)
        if player and data.targetSource and type(data.length) == "number" and type(data.reason) == "string" and data.length >= -1 and data.length <= 90 then
            if player.Permissions:IsAdmin() or (player.Permissions:IsMod() and data.length > 0 and data.length <= 7) then
                cb(Punishment.Ban:Source(data.targetSource, data.length, data.reason, source))
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Admin:Wardrobe', function(source, data, cb)
        
        local player = Fetch:Source(source)
        if player and player.Permissions:IsSupport() then
            local target = tonumber(data.player)
            local typ1e = data.wardrobeType
            TriggerClientEvent("Admin:Wardrobe:Reciver", target, typ1e)
            cb(true)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Admin:KickPlayer', function(source, data, cb)
        
        local player = Fetch:Source(source)
        if player and data.targetSource and type(data.reason) == "string" and player.Permissions:IsMod() then
            cb(Punishment:Kick(data.targetSource, data.reason, source))
        else
            cb(false)
        end
    end)
    
    Callbacks:RegisterServerCallback('Admin:ActionPlayer', function(source, data, cb)
        
        local player = Fetch:Source(source)
        if player and data.action and data.targetSource and player.Permissions:IsSupport() then
            local target = Fetch:Source(data.targetSource)
            if target then
                local canFuckWith = player.Permissions:GetLevel() > target.Permissions:GetLevel()
                local notMe = player:GetData('Source') ~= target:GetData('Source')
                local wasSuccessful = false

                local targetChar = target:GetData('Character')
                if targetChar then
                    local playerPed = GetPlayerPed(player:GetData('Source'))
                    local targetPed = GetPlayerPed(target:GetData('Source'))
                    if data.action == 'bring' and canFuckWith and notMe then
                        local playerCoords = GetEntityCoords(playerPed)
                        Pwnzor.Players:TempPosIgnore(target:GetData("Source"))
                        SetEntityCoords(targetPed, playerCoords.x, playerCoords.y, playerCoords.z + 1.0)

                        cb({
                            success = true,
                            message = 'Brought Successfully'
                        })

                        wasSuccessful = true
                    elseif data.action == 'goto' then
                        local targetCoords = GetEntityCoords(targetPed)
                        SetEntityCoords(playerPed, targetCoords.x, targetCoords.y, targetCoords.z + 1.0)

                        cb({
                            success = true,
                            message = 'Teleported To Successfully'
                        })

                        wasSuccessful = true
                    elseif data.action == 'heal' then
                        if (notMe or player.Permissions:IsAdmin()) then
                            Callbacks:ClientCallback(targetChar:GetData("Source"), "Damage:Heal", true)
                            
                            cb({
                                success = true,
                                message = 'Healed Successfully'
                            })

                            wasSuccessful = true
                        else
                            cb({
                                success = false,
                                message = 'Can\'t Heal Yourself'
                            })
                        end
                    elseif data.action == 'attach' and canFuckWith and notMe then
                        TriggerClientEvent('Admin:Client:Attach', source, target:GetData('Source'), GetEntityCoords(targetPed), {
                            First = targetChar:GetData("First"),
                            Last = targetChar:GetData("Last"),
                            SID = targetChar:GetData("SID"),
                            Account = target:GetData("AccountID"),
                        })

                        cb({
                            success = true,
                            message = 'Attached Successfully'
                        })

                        wasSuccessful = true
                    elseif data.action == 'marker' and (canFuckWith or player.Permissions:GetLevel() == 100) then
                        local targetCoords = GetEntityCoords(targetPed)
                        TriggerClientEvent('Admin:Client:Marker', source, targetCoords.x, targetCoords.y)
                    end

                    if wasSuccessful then
                        Logger:Warn(
                            "Admin",
                            string.format(
                                "%s [%s] Used Staff Action %s On %s [%s] - Character %s %s (%s)", 
                                player:GetData("Name"),
                                player:GetData("AccountID"),
                                string.upper(data.action),
                                target:GetData("Name"),
                                target:GetData("AccountID"),
                                targetChar:GetData('First'),
                                targetChar:GetData('Last'),
                                targetChar:GetData('SID')
                            ),
                            {
                                console = (player.Permissions:GetLevel() < 100),
                                file = false,
                                database = true,
                                discord = (player.Permissions:GetLevel() < 100) and {
                                    embed = true,
                                    type = "error",
                                    webhook = GetConvar("discord_admin_webhook", ''),
                                } or false,
                            }
                        )
                    end
                    return
                end
            end
        end

        cb(false)
    end)

    Callbacks:RegisterServerCallback('Admin:CurrentVehicleAction', function(source, data, cb)
        
        local player = Fetch:Source(source)
        if player and data.action and player.Permissions:IsAdmin() and player.Permissions:GetLevel() >= 90 then
            Logger:Warn(
                "Admin",
                string.format(
                    "%s [%s] Used Vehicle Action %s",
                    player:GetData("Name"),
                    player:GetData("AccountID"),
                    string.upper(data.action)
                ),
                {
                    console = (player.Permissions:GetLevel() < 100),
                    file = false,
                    database = true,
                    discord = (player.Permissions:GetLevel() < 100) and {
                        embed = true,
                        type = "error",
                        webhook = GetConvar("discord_admin_webhook", ''),
                    } or false,
                }
            )
            cb(true)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Admin:NoClip', function(source, data, cb)
        
        local player = Fetch:Source(source)
        if player and player.Permissions:IsAdmin() then
            Logger:Warn(
                "Admin",
                string.format(
                    "%s [%s] Used NoClip (State: %s)",
                    player:GetData("Name"),
                    player:GetData("AccountID"),
                    data?.active and 'On' or 'Off'
                ),
                {
                    console = (player.Permissions:GetLevel() < 100),
                    file = false,
                    database = true,
                    discord = (player.Permissions:GetLevel() < 100) and {
                        embed = true,
                        type = "error",
                        webhook = GetConvar("discord_admin_webhook", ''),
                    } or false,
                }
            )
            cb(true)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Admin:UpdatePhonePerms', function(source, data, cb)
        
        local player = Fetch:Source(source)
        if player.Permissions:IsAdmin() then
            local target = Fetch:Source(data.player)
            if target ~= nil then
                local char = target:GetData("Character")
                if char ~= nil then
                    local cPerms = char:GetData("PhonePermissions")
                    cPerms[data.app][data.perm] = data.player
                    char:SetData("PhonePermissions", cPerms)
                    cb(true)
                else
                    cb(false)
                end
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)
    Callbacks:RegisterServerCallback('Admin:GetBanks', function(source, data, cb)
        local heistId = {
            'mazebank',
            'lombank',
            'paleto',
            'bobcat'
        }

        for _, location in pairs(FLEECA_LOCATIONS) do
            table.insert(heistId, string.format('"%s (%s)"', location.id, location.label))
        end

        cb(heistId)
    end)
    Callbacks:RegisterServerCallback('Admin:GetPlayerPermission', function(source, data, cb)
        local player = Fetch:Source(source)
        if player then
            if player.Permissions:IsDev() then
                cb('Developer')
            elseif player.Permissions:IsOwner() then
                cb('Owner')
            elseif player.Permissions:IsAdmin() then
                cb('Admin')
            elseif player.Permissions:IsStaff() then
                cb('Mod')
            elseif player.Permissions:IsMod() then
                cb('Mod')
            elseif player.Permissions:IsSupport() then
                cb('Support')
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)
    

    Callbacks:RegisterServerCallback('Admin:ToggleGod', function(source, data, cb)
        
        local player = Fetch:Source(source)
        if player and player.Permissions:IsAdmin() then
            Logger:Warn(
                "Admin",
                string.format(
                    "%s [%s] Toggled God Mode",
                    player:GetData("Name"),
                    player:GetData("AccountID")
                ),
                {
                    console = (player.Permissions:GetLevel() < 100),
                    file = false,
                    database = true,
                    discord = (player.Permissions:GetLevel() < 100) and {
                        embed = true,
                        type = "error",
                        webhook = GetConvar("discord_admin_webhook", ''),
                    } or false,
                }
            )

            TriggerClientEvent('Admin:Client:ToggleGodmode', source)
            cb(true)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Admin:AddCash', function(source, data, cb)
        
        local player = Fetch:Source(source)
        if player and player.Permissions:IsAdmin() then
            Logger:Warn(
                "Admin",
                string.format(
                    "%s [%s] Added $%s to themselves",
                    player:GetData("Name"),
                    player:GetData("AccountID"),
                    data.amount
                ),
                {
                    console = (player.Permissions:GetLevel() < 100),
                    file = false,
                    database = true,
                    discord = (player.Permissions:GetLevel() < 100) and {
                        embed = true,
                        type = "error",
                        webhook = GetConvar("discord_admin_webhook", ''),
                    } or false,
                }
            )

            local amount = tonumber(data.amount)
            if amount and amount > 0 then
                exports["mythic-base"]:FetchComponent("Wallet"):Modify(source, amount)
                Execute:Client(source, "Notification", "Success", "Added $" .. amount)
            end
            cb(true)
        else
            cb(false)
        end
    end)
    
    Callbacks:RegisterServerCallback('Admin:GiveItem', function(source, data, cb)
        
        print(source, json.encode(data))
        local player = Fetch:Source(source)
        if player and player.Permissions:IsAdmin() then
            Logger:Warn(
                "Admin",
                string.format(
                    "%s [%s] Gave item %s x%s to %s",
                    player:GetData("Name"),
                    player:GetData("AccountID"),
                    data.itemName,
                    data.itemCount,
                    data.player
                ),
                {
                    console = (player.Permissions:GetLevel() < 100),
                    file = false,
                    database = true,
                    discord = (player.Permissions:GetLevel() < 100) and {
                        embed = true,
                        type = "error",
                        webhook = GetConvar("discord_admin_webhook", ''),
                    } or false,
                }
            )
    
            local targetId = data.player == "me" and source or tonumber(data.player)
            local itemName = data.itemName
            local amount = tonumber(data.itemCount)
    
            local target = Fetch:Source(targetId)
            if target then
                local char = target:GetData("Character")
                if char then
                    Inventory:AddItem(char:GetData("SID"), itemName, amount, {}, 1)
                    Execute:Client(source, "Notification", "Success",
                        string.format("Gave %dx %s to %s", amount, itemName, targetId))
                end
            end
            cb(true)
        else
            cb(false)
        end
    end)
    
    Callbacks:RegisterServerCallback('Admin:GiveWeapon', function(source, data, cb)
        
        print(source, json.encode(data))
        local player = Fetch:Source(source)
        if player and player.Permissions:IsAdmin() then
            Logger:Warn(
                "Admin",
                string.format(
                    "%s [%s] Gave weapon %s to %s",
                    player:GetData("Name"),
                    player:GetData("AccountID"),
                    data.weaponName,
                    data.player
                ),
                {
                    console = (player.Permissions:GetLevel() < 100),
                    file = false,
                    database = true,
                    discord = (player.Permissions:GetLevel() < 100) and {
                        embed = true,
                        type = "error",
                        webhook = GetConvar("discord_admin_webhook", ''),
                    } or false,
                }
            )
    
            local targetId = data.player == "me" and source or tonumber(data.player)
            local weapon = string.upper(data.weaponName)
            local ammo = tonumber(data.ammo) or 0
            local scratched = data.scratched == "1"
    
            local target = Fetch:Source(targetId)
            if target then
                local char = target:GetData("Character")
                if char then
                    Inventory:AddItem(char:GetData("SID"), weapon, 1,
                        { ammo = ammo, clip = 0, Scratched = scratched }, 1)
                    Execute:Client(source, "Notification", "Success",
                        string.format("Gave weapon %s to %s", weapon, targetId))
                end
            end
            cb(true)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Admin:OpenInventory', function(source, data, cb)
        
        local player = Fetch:Source(source)
        if player and player.Permissions:IsAdmin() then
            Logger:Warn(
                "Admin",
                string.format(
                    "%s [%s] Viewed inventory of State ID %s",
                    player:GetData("Name"),
                    player:GetData("AccountID"),
                    data.player
                ),
                {
                    console = (player.Permissions:GetLevel() < 100),
                    file = false,
                    database = true,
                    discord = (player.Permissions:GetLevel() < 100) and {
                        embed = true,
                        type = "error",
                        webhook = GetConvar("discord_admin_webhook", ''),
                    } or false,
                }
            )
    
            Inventory:OpenSecondary(source, 1, data.player)
            cb(true)
        else
            cb(false)
        end
    end)
    
    Callbacks:RegisterServerCallback('Admin:OpenStash', function(source, data, cb)
        
        local player = Fetch:Source(source)
        if player and player.Permissions:IsAdmin() then
            Logger:Warn(
                "Admin",
                string.format(
                    "%s [%s] Viewed stash %s",
                    player:GetData("Name"),
                    player:GetData("AccountID"),
                    data.stashId
                ),
                {
                    console = (player.Permissions:GetLevel() < 100),
                    file = false,
                    database = true,
                    discord = (player.Permissions:GetLevel() < 100) and {
                        embed = true,
                        type = "error",
                        webhook = GetConvar("discord_admin_webhook", ''),
                    } or false,
                }
            )
    
            Inventory:OpenSecondary(source, 13, string.format("stash:%s", data.stashId))
            cb(true)
        else
            cb(false)
        end
    end)
    
    Callbacks:RegisterServerCallback('Admin:OpenTrunk', function(source, data, cb)
        
        local player = Fetch:Source(source)
        if player and player.Permissions:IsAdmin() then
            Logger:Warn(
                "Admin",
                string.format(
                    "%s [%s] Viewed trunk of vehicle %s",
                    player:GetData("Name"),
                    player:GetData("AccountID"),
                    data.vin
                ),
                {
                    console = (player.Permissions:GetLevel() < 100),
                    file = false,
                    database = true,
                    discord = (player.Permissions:GetLevel() < 100) and {
                        embed = true,
                        type = "error",
                        webhook = GetConvar("discord_admin_webhook", ''),
                    } or false,
                }
            )
    
            Inventory:OpenSecondary(source, 4, data.vin)
            cb(true)
        else
            cb(false)
        end
    end)

    -- Job Commands
    Callbacks:RegisterServerCallback('Admin:GiveJob', function(source, data, cb)
        
        local player = Fetch:Source(source)
        if not player and player.Permissions:IsAdmin() then
            cb(false)
            return
        end

        local target, jobId, gradeId, workplaceId = data.player , data.jobId , data.gradeId , data.workplaceId
        target = tonumber(target)
        if not workplaceId then workplaceId = false end

        if target and jobId and gradeId then
            local jobExists = Jobs:DoesExist(jobId, workplaceId, gradeId)
            if jobExists then
                local success = Jobs:GiveJob(target, jobId, workplaceId, gradeId)
                if success then
                    if jobExists.Workplace then
                        Chat.Send.System:Single(source, string.format('Gave State ID: %s Job: %s - %s - %s',
                            target, jobExists.Name, jobExists.Workplace.Name, jobExists.Grade.Name))
                    else
                        Chat.Send.System:Single(source, string.format('Gave State ID: %s Job: %s - %s',
                            target, jobExists.Name, jobExists.Grade.Name))
                    end
                else
                    Chat.Send.System:Single(source, 'Error Giving Job - Maybe that State ID Doesn\'t Exist')
                end
            else
                Chat.Send.System:Single(source, 'Job Doesn\'t Exist')
            end
        else
            Chat.Send.System:Single(source, 'Invalid Arguments')
        end
        cb(true)
    end)

    Callbacks:RegisterServerCallback('Admin:RemoveJob', function(source, data, cb)
        
        local player = Fetch:Source(source)
        if not player and player.Permissions:IsAdmin() then
            cb(false)
            return
        end


        local target = tonumber(data.player)
        local jobId = data.jobId

        local success = Jobs:RemoveJob(target, jobId)
        if success then
            Chat.Send.System:Single(source, 'Successfully Removed Job From State ID:' .. target)
        else
            Chat.Send.System:Single(source, 'Error Removing Job')
        end
        cb(true)
    end)

    -- Heist Commands
    Callbacks:RegisterServerCallback('Admin:ResetHeist', function(source, data, cb)
        local player = Fetch:Source(source)
        if not player and player.Permissions:IsAdmin() then
            cb(false)
            return
        end
        
        local heistId = data.heistId
        if heistId == "mazebank" then
            TriggerEvent("ResetMazeBank")
            Execute:Client(source, "Notification", "Success", "Maze Bank Heist Reset")
        elseif heistId == "lombank" then
            TriggerEvent("ResetLombank")
            Execute:Client(source, "Notification", "Success", "Lombank Heist Reset")
        elseif heistId == "paleto" then
            TriggerEvent("ResetPaleto")
            Execute:Client(source, "Notification", "Success", "Paleto Bank Heist Reset")
        elseif heistId == "bobcat" then
            TriggerEvent("ResetBobcat")
            Execute:Client(source, "Notification", "Success", "Bobcat Reset")
        elseif heistId:find("fleeca") and FLEECA_LOCATIONS[heistId] then
            TriggerEvent("ResetFleeca",heistId)
            Execute:Client(source, "Notification", "Success",
                string.format("Fleeca %s Reset", FLEECA_LOCATIONS[heistId].label))
        else
            Execute:Client(source, "Notification", "Error", "Invalid Bank ID")
        end
        cb(true)
    end)

    Callbacks:RegisterServerCallback('Admin:DisablePower', function(source, data, cb)
        
        local player = Fetch:Source(source)
        if not player and player.Permissions:IsAdmin() then
            cb(false)
            return
        end

        if data.heistId == "mazebank" then
            TriggerEvent("MazeBankDisablePower")
        elseif data.heistId == "lombank" then
            TriggerEvent("LombankDisablePower")
        elseif data.heistId == "paleto" then
            TriggerEvent("DisablePaletoPower")
        else
            Execute:Client(source, "Notification", "Error", "Invalid Bank ID")
        end
        cb(true)
    end)

    -- MDT Commands
    Callbacks:RegisterServerCallback('Admin:SetCallsign', function(source, data, cb)
        
        local player = Fetch:Source(source)
        if not player and player.Permissions:IsAdmin() then
            cb(false)
            return
        end

        local tPly = Fetch:Source(tonumber(data.player))
        if tPly ~= nil then
            local target = tPly:GetData("Character")
            if Jobs.Permissions:HasJob(tPly:GetData("Source"), "police")
                or Jobs.Permissions:HasJob(tPly:GetData("Source"), "ems")
            then
                if MDT.People:Update(-1, target:GetData("SID"), "Callsign", data.callsign) then
                    Chat.Send.System:Single(source, "Updated Callsign")
                else
                    Chat.Send.System:Single(source, "Error Updating Callsign")
                end
            else
                Chat.Send.System:Single(source, "Target is not Emergency Personnel")
            end
        else
            Chat.Send.System:Single(source, "Invalid State ID")
        end
        cb(true)
    end)

    -- Inventory Commands
    Callbacks:RegisterServerCallback('Admin:ClearInventory', function(source, data, cb)
        
        local player = Fetch:Source(source)
        if not player and player.Permissions:IsAdmin() then
            cb(false)
            return
        end

        local player = Fetch:Source(tonumber(data.player))
        if player then
            local char = player:GetData("Character")
            MySQL.query.await("DELETE FROM inventory WHERE name = ?", {
                string.format("%s:%s", char:GetData("SID"), 1)
            })

            Execute:Client(source, "Notification", "Success",
                "Cleared inventory of " .. char:GetData("SID"))
                TriggerEvent("refreshShit",char:GetData("SID"), true)
        else
            Execute:Client(source, "Notification", "Error", "Player not found")
        end
        cb(true)
    end)

    -- Callbacks:RegisterServerCallback('Admin:clearinventory2', function(source, data, cb)
    --     
    --     local player = Fetch:Source(source)
    --     if not player and player.Permissions:IsAdmin() then
    --         cb(false)
    --         return
    --     end

    --     local player = Fetch:Source(tonumber(data.player))
    --     local 
    --     if player then
    --         local char = player:GetData("Character")
    --         MySQL.query.await("DELETE FROM inventory WHERE Owner = ?", {
    --             string.format("%s:%s", char:GetData("SID"), 1)
    --         })

    --         Execute:Client(char:GetData("Source"), "Notification", "Error",
    --             "Your inventory was cleared by " .. Fetch:Source(source):GetData("Character"):GetData("SID"))
    --         Execute:Client(source, "Notification", "Success",
    --             "Cleared inventory of " .. char:GetData("SID"))
    --     else
    --         Execute:Client(source, "Notification", "Error", "Player not found")
    --     end
    --     cb(true)
    -- end)

    -- Storage Unit Commands
    Callbacks:RegisterServerCallback('Admin:UnitAdd', function(source, data, cb)
        
        local player = Fetch:Source(source)
        if not player and player.Permissions:IsAdmin() then
            cb(false)
            return
        end

        local ped = GetPlayerPed(source)
        local coords = GetEntityCoords(ped)

        local res = StorageUnits:Create(
            vector3(coords.x, coords.y, coords.z - 1.2),
            data.unitLabel,
            tonumber(data.unitLevel),
            data.managingBusiness
        )

        if res then
            Chat.Send.System:Single(source, "Storage Unit Added, ID: " .. res)
        end
        cb(true)
    end)

    -- Reputation Commands
    Callbacks:RegisterServerCallback('Admin:AddRep', function(source, data, cb)
        
        local player = Fetch:Source(source)
        if not player and player.Permissions:IsAdmin() then
            cb(false)
            return
        end
        local player = Fetch:Source(tonumber(data.player))
        if player then
            Reputation.Modify:Add(player:GetData('Source'), data.repId, tonumber(data.amount))
            Chat.Send.System:Single(source, string.format('%s Rep Added For %s To State ID %s',
                data.amount, data.repId, data.player))
        else
            Chat.Send.System:Single(source, 'Invalid Target')
        end
        cb(true)
    end)

    -- Message Commands
    Callbacks:RegisterServerCallback('Admin:ServerMessage', function(source, data, cb)
        
        local player = Fetch:Source(source)
        if not player and player.Permissions:IsAdmin() then
            cb(false)
            return
        end


        Chat.Send.Server:All(data.message)
        cb(true)
    end)

    -- App Commands
    Callbacks:RegisterServerCallback('Admin:PhonePerm', function(source, data, cb)
        
        local player = Fetch:Source(source)
        if not player and player.Permissions:IsAdmin() then
            cb(false)
            return
        end

        local player = Fetch:Source(tonumber(data.player))
        if player then
            local char = player:GetData('Character')
            if char then
                local phonePermissions = char:GetData('PhonePermissions')
                if phonePermissions[data.appId] then
                    if phonePermissions[data.appId][data.permId] ~= nil then
                        phonePermissions[data.appId][data.permId] =
                            not phonePermissions[data.appId][data.permId]
                        char:SetData('PhonePermissions', phonePermissions)
                        Chat.Send.System:Single(source, phonePermissions[data.appId][data.permId] and
                            'Enabled Permission' or 'Disabled Permission')
                    else
                        Chat.Send.System:Single(source, 'Permission Doesn\'t Exist')
                    end
                else
                    Chat.Send.System:Single(source, 'App Doesn\'t Exist')
                end
            end
        else
            Chat.Send.System:Single(source, 'Invalid Target')
        end
        cb(true)
    end)

    -- Dealership Commands
    Callbacks:RegisterServerCallback('Admin:SetStock', function(source, data, cb)
        
        local player = Fetch:Source(source)
        if not player and player.Permissions:IsAdmin() then
            cb(false)
            return
        end

        local dealership, vehicle, modelType, amount, price = data.dealershipId , data.vehicleId , data.modelType , data.amount , data.price
        amount = tonumber(amount)
        price = tonumber(price)


        if amount and price and price > 0 then
            local res = Dealerships.Stock:Add(dealership, vehicle, modelType, amount, {
                class = data.class,
                price = price,
                make = data.make,
                model = data.model,
                category = data.category
            })

            if res and res.success then
                if res.existed then
                    Chat.Send.System:Single(source, "Success - Already Exists")
                else
                    Chat.Send.System:Single(source, "Success")
                end
            else
                Chat.Send.System:Single(source, "Failed")
            end
        else
            Chat.Send.System:Single(source, "Invalid Arguments")
        end
        cb(true)
    end)

    -- System Commands
    Callbacks:RegisterServerCallback('Admin:ToggleRobbery', function(source, data, cb)
        local player = Fetch:Source(source)
        if not player and player.Permissions:IsAdmin() then
            cb(false)
            return
        end
        GlobalState["RobberiesDisabled"] = not GlobalState["RobberiesDisabled"]
        Execute:Client(source, "Notification", "Success",
            "Robberies " .. (GlobalState["RobberiesDisabled"] and "Disabled" or "Enabled"))
        cb(true)
    end)

    Callbacks:RegisterServerCallback('Admin:DisableLockdown', function(source, data, cb)
        
        local player = Fetch:Source(source)
        if not player and player.Permissions:IsAdmin() then
            cb(false)
            return
        end
        GlobalState["RestartLockdown"] = false
        Execute:Client(source, "Notification", "Success", "Restart Lockdown Disabled")
        cb(true)
    end)

    Callbacks:RegisterServerCallback('Admin:ToggleInvisible', function(source, data, cb)
        
        local player = Fetch:Source(source)
        if player and player.Permissions:IsAdmin() then
            Logger:Warn(
                "Admin",
                string.format(
                    "%s [%s] Used Invisibility",
                    player:GetData("Name"),
                    player:GetData("AccountID")
                ),
                {
                    console = (player.Permissions:GetLevel() < 100),
                    file = false,
                    database = true,
                    discord = (player.Permissions:GetLevel() < 100) and {
                        embed = true,
                        type = "error",
                        webhook = GetConvar("discord_admin_webhook", ''),
                    } or false,
                }
            )

            TriggerClientEvent('Admin:Client:Invisible', source)
            cb(true)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Admin:Die', function(source, data, cb)
        TriggerClientEvent("SetPlayerHealthToZero", tonumber(data.player))
        cb(true)
    end)

    Callbacks:RegisterServerCallback('Admin:CheckHeist', function(source, data, cb)
        local heistId = data.heistId
        TriggerEvent('Admin:CheckHeist:Event', heistId)
        cb(true)
    end)

    Callbacks:RegisterServerCallback('Admin:SetOwner', function(source, data, cb)
        local jobId, target = data.jobId, data.player
        target = math.tointeger(target)

        if target and jobId then
            local jobExists = Jobs:Get(jobId)
            if jobExists and jobExists.Type == 'Company' then
                local success = Jobs.Management:Edit(jobId, {
                    Owner = target
                })
                if success then
                    Chat.Send.System:Single(source, string.format('Set Owner of %s (%s) to State ID %s', jobExists.Name, jobExists.Id, target))
                else
                    Chat.Send.System:Single(source, 'Error Setting Job Owner')
                end
            else
                Chat.Send.System:Single(source, 'Job Doesn\'t Exist or Isn\'t a Company')
            end
        else
            Chat.Send.System:Single(source, 'Invalid Job or State ID')
        end
        cb(true)
    end)

    Callbacks:RegisterServerCallback('Admin:UnitCopy', function(source, data, cb)
        cb(exports["mythic-businesses"]:UnitCopy())
    end)

    Callbacks:RegisterServerCallback('Admin:UnitCopy', function(source, data, cb)
        cb(exports["mythic-businesses"]:UnitDelete(data.unitId))
    end)

    Callbacks:RegisterServerCallback('Admin:UnitCopy', function(source, data, cb)
        cb(exports["mythic-businesses"]:UnitOwn(data.unitId))
    end)

    Callbacks:RegisterServerCallback('Admin:ReclaimCallsign', function(source, data, cb)
        Database.Game:findOneAndUpdate({
            collection = "characters",
            query = {
                Callsign = data.callsign,
            },
            update = {
                ['$set'] = {
                    Callsign = false,
                },
            },
            options = {
                projection = {
                    SID = 1,
                    User = 1,
                    First = 1,
                    Last = 1,
                },
            },
        }, function(success, results)
            if success and results then
                local plyr = Fetch:SID(results.SID)
                if plyr then
                    local char = plyr:GetData("Character")
                    if char then
                        char:SetData("Callsign", false)
                    end
                end

                Chat.Send.System:Single(source, string.format("Callsign Reclaimed From %s %s (%s)", results.First, results.Last, results.SID))
            else
                Chat.Send.System:Single(source, "Nobody With That Callsign")
            end
        end)
        cb(true)
    end)

    Callbacks:RegisterServerCallback('Admin:AddMDTSysAdmin', function(source, data, cb)
        local targetStateId = math.tointeger(data.player)
        local success = MDT.People:Update(-1, targetStateId, "MDTSystemAdmin", true)
        if success then
            Chat.Send.System:Single(source, "Granted System Admin to State ID: " .. targetStateId)
        else
            Chat.Send.System:Single(source, "Error Granting System Admin")
        end
        cb(true)
    end)

    Callbacks:RegisterServerCallback('Admin:RemoveMDTSysAdmin', function(source, data, cb)
        local targetStateId = math.tointeger(data.player)
		local success = MDT.People:Update(-1, targetStateId, "MDTSystemAdmin", false)
		if success then
			Chat.Send.System:Single(source, "Revoked System Admin from State ID: " .. targetStateId)
		else
			Chat.Send.System:Single(source, "Error Revoking System Admin")
		end
        cb(true)
    end)

    Callbacks:RegisterServerCallback('Admin:SystemMessage', function(source, data, cb)
        local player = Fetch:Source(source)
        if not player and player.Permissions:IsAdmin() then
            cb(false)
            return
        end

        Chat.Send.System:All(data.message)
        cb(true)
    end)

    Callbacks:RegisterServerCallback('Admin:Broadcast', function(source, data, cb)
        local player = Fetch:Source(source)
        if not player and player.Permissions:IsAdmin() then
            cb(false)
            return
        end
		Chat.Send.Broadcast:All(player:GetData("Name"), data.message)
        cb(true)
    end)

    Callbacks:RegisterServerCallback('Admin:Broadcast', function(source, data, cb)
        local player = Fetch:Source(source)
        if not player and player.Permissions:IsAdmin() then
            cb(false)
            return
        end
		local target = tonumber(data.player)
		if plyr ~= nil then
			Phone.Email:Send(target, data.senderEmail, os.time() * 1000, data.subject, data.body)
		else
			Chat.Send.System:Single(source, "Invalid State ID")
		end
        cb(true)
    end)

    Callbacks:RegisterServerCallback('Admin:LaptopPerm', function(source, data, cb)
        
        local player = Fetch:Source(source)
        if not player and player.Permissions:IsAdmin() then
            cb(false)
            return
        end

		local target = Fetch:Source(tonumber(data.player))
		local app, perm = data.appId, data.permId

		if target ~= nil then
			local char = target:GetData("Character")
			if char ~= nil then
				local laptopPermissions = char:GetData("LaptopPermissions")
				if laptopPermissions[app] then
					if laptopPermissions[app][perm] ~= nil then
						if laptopPermissions[app][perm] then
							laptopPermissions[app][perm] = false
							Chat.Send.System:Single(source, "Disabled Permission")
						else
							laptopPermissions[app][perm] = true
							Chat.Send.System:Single(source, "Enabled Permission")
						end

						char:SetData("LaptopPermissions", laptopPermissions)
					else
						Chat.Send.System:Single(source, "Permission Doesn't Exist")
					end
				else
					Chat.Send.System:Single(source, "App Doesn't Exist")
				end
			end
		else
			Chat.Send.System:Single(source, "Invalid Target")
		end
        cb(true)
    end)

    Callbacks:RegisterServerCallback('Admin:BizWizSet', function(source, data, cb)
        local setting = data.bizWizType
		if setting == "false" then
			setting = false
		end

    	local res = Jobs.Data:Set(data.jobId, "bizWiz", setting)

		if res?.success then
			Chat.Send.System:Single(source, "Success")
		else
			Chat.Send.System:Single(source, "Failed")
		end
        cb(true)
    end)

    Callbacks:RegisterServerCallback('Admin:BizWizLogo', function(source, data, cb)
		local setting = data.logoUrl
		if setting == "false" then
			setting = false
		end

    local res = Jobs.Data:Set(data.jobId, "bizWizLogo", setting)

		if res?.success then
			Chat.Send.System:Single(source, "Success")
		else
			Chat.Send.System:Single(source, "Failed")
		end
        cb(true)
    end)

    Callbacks:RegisterServerCallback('Admin:ClearAlias', function(source, data, cb)
		if tonumber(data.player) then
			local plyr = Fetch:Source(tonumber(data.player))
			if plyr ~= nil then
				local char = plyr:GetData("Character")
				if char ~= nil then
					local aliases = char:GetData("Alias")
					aliases[args[2]] = nil
					char:SetData("Alias", aliases)
					Chat.Send.System:Single(
						source,
						string.format(
							"Alias Cleared For %s %s (%s) For %s",
							char:GetData("First"),
							char:GetData("Last"),
							char:GetData("SID"),
							args[2]
						)
					)
				else
					Chat.Send.System:Single(source, "Invalid Target")
				end
			else
				Chat.Send.System:Single(source, "Invalid Target")
			end
		else
			Chat.Send.System:Single(source, "Invalid Target")
		end
        cb(true)
    end)

    Callbacks:RegisterServerCallback('Admin:IncStock', function(source, data, cb)
        local dealership, vehicle, amount = data.dealershipId, data.vehicleId, data.amount
        amount = tonumber(amount)

        if amount and amount > 0 then
            local res = Dealerships.Stock:Increase(dealership, vehicle, amount)

            if res and res.success then
                Chat.Send.System:Single(source, "Successfully Increased Stock")
            else
                Chat.Send.System:Single(source, "Not In Stock")
            end
        else
            Chat.Send.System:Single(source, "Invalid Arguments")
        end
        cb(true)
    end)

    Callbacks:RegisterServerCallback('Admin:SetStockPrice', function(source, data, cb)
        local dealership, vehicle, amount = data.dealershipId, data.vehicleId, data.amount
        price = tonumber(price)

        if price and price > 0 then
            local res = Dealerships.Stock:Update(dealership, vehicle, {
                ["data.price"] = price
            })

            if res and res.success then
                Chat.Send.System:Single(source, "Successfully Set Price to $" .. price)
            else
                Chat.Send.System:Single(source, "Not In Stock")
            end
        else
            Chat.Send.System:Single(source, "Invalid Arguments")
        end
        cb(true)
    end)

    Callbacks:RegisterServerCallback('Admin:SetStockName', function(source, data, cb)
        local dealership, vehicle, make, model, class = data.dealershipId, data.vehicleId, data.make, data.model, data.class

        if make and model then
            if class then
                local res = Dealerships.Stock:Update(dealership, vehicle, {
                    ["data.make"] = make,
                    ["data.model"] = model,
                    ["data.class"] = class,
                })
            else
                local res = Dealerships.Stock:Update(dealership, vehicle, {
                    ["data.make"] = make,
                    ["data.model"] = model
                })
            end

            if res and res.success then
                if class then
                    Chat.Send.System:Single(source, "Successfully Set Name to " .. make .. " " .. model .. " " .. class)
                else
                    Chat.Send.System:Single(source, "Successfully Set Name to " .. make .. " " .. model)
                end
            else
                Chat.Send.System:Single(source, "Not In Stock")
            end
        else
            Chat.Send.System:Single(source, "Invalid Arguments")
        end
        cb(true)
    end)

    Callbacks:RegisterServerCallback('Admin:RemRep', function(source, data, cb)
        
        local player = Fetch:Source(source)
        if not player and player.Permissions:IsAdmin() then
            cb(false)
            return
        end
        local player = Fetch:Source(tonumber(data.player))
        if player then
            Reputation.Modify:Remove(player:GetData('Source'), data.repId, tonumber(data.amount))
            Chat.Send.System:Single(source, string.format('%s Rep Added For %s To State ID %s',
                data.amount, data.repId, data.player))
        else
            Chat.Send.System:Single(source, 'Invalid Target')
        end
        cb(true)
    end)

    Callbacks:RegisterServerCallback('Admin:Screenshot', function(source, data, cb)
		local plyr = Fetch:Source(tonumber(data.player))
		if plyr ~= nil then
			local wh = "WEBHOOK-WEBHOOK"
			if wh ~= nil and wh ~= "" then
				Callbacks:ClientCallback(
					plyr:GetData("Source"),
					"Commands:SS",
					string.gsub(wh, "https://discord.com/api/webhooks/", ""),
					function() end
				)
			end
		end
        cb(true)
    end)

    Callbacks:RegisterServerCallback('Admin:CheckShitlord', function(source, data, cb)
		if GlobalState["AntiShitlord"] ~= nil then
			if os.time() > GlobalState["AntiShitlord"] then
				Chat.Send.System:Single(
					source,
					string.format(
						"AntiShitlord: Expired (%s)",
						GetFormattedTimeFromSeconds(GlobalState["AntiShitlord"] - os.time())
					)
				)
			else
				Chat.Send.System:Single(
					source,
					string.format(
						"AntiShitlord: On Cooldown (%s)",
						GetFormattedTimeFromSeconds(GlobalState["AntiShitlord"] - os.time())
					)
				)
			end
		else
			Chat.Send.System:Single(source, "AntiShitlord: Not Yet Triggered")
		end
        cb(true)
    end)

    Callbacks:RegisterServerCallback('', function(source, data, cb)
		GlobalState["AntiShitlord"] = false
        cb(true)
    end)

    Callbacks:RegisterServerCallback('setbillboard', function(source, data, cb)
        local billboardId, billboardUrl = data.id, data.url

        if #billboardUrl <= 10 then
            billboardUrl = false
        end

        Billboards:Set(billboardId, billboardUrl)
    end)

    Callbacks:RegisterServerCallback('Admin:AddCrypto', function(source, data, cb)
        local player = Fetch:Source(tonumber(data.player))
        if player then
            local char = player:GetData("Character")
            if char then
                local coin = data.coin:upper()
                local amount = tonumber(data.amount)

                if allowedCoins[coin] and amount then
                    Crypto.Exchange:Add(coin, char:GetData("CryptoWallet"), amount)
                    Chat.Send.System:Single(source, string.format("Added %d %s (%s) to %s %s (%s)", amount, allowedCoins[coin], coin, char:GetData("First"), char:GetData("Last"), char:GetData("SID")))
                else
                    Chat.Send.System:Single(source, "Error: Invalid coin type or amount. Allowed coins: VRM, PLEB, HEIST.")
                end
            else
                Chat.Send.System:Single(source, "Error: Character not found.")
            end
        else
            Chat.Send.System:Single(source, "Error: Player not found.")
        end
    end)

    -- Callbacks:RegisterServerCallback('Admin:StoreBank', function(source, data, cb)
	-- 	Database.Game:updateOne({
	-- 		collection = "store_bank_accounts",
	-- 		update = {
	-- 			["$set"] = {
	-- 				Shop = tonumber(data.shopId),
	-- 				Account = tonumber(data.accountNumber),
	-- 			},
	-- 		},
	-- 		query = {
	-- 			Shop = tonumber(args[1]),
	-- 		},
	-- 		options = {
	-- 			upsert = true,
	-- 		},
	-- 	}, function(success, result)
	-- 		if success then
	-- 			storeBankAccounts[string.format("shop:%s", tonumber(args[1]))] = tonumber(args[2])
	-- 		end
	-- 	end)
    -- end)

    Callbacks:RegisterServerCallback('Admin:SetPed', function(source, data, cb)
        local target, ped = data.player, data.ped
        if not target or target == 0 or target == nil then target = source end
        TriggerClientEvent("Admin:Client:ChangePed", target, ped)
    end)

    Callbacks:RegisterServerCallback('Admin:jobs', function(source, data, cb)
        Database.Game:find({
            collection = "jobs",
            query = {}
        }, function(isSuccessful, jobs)
            if not isSuccessful then
                cb({})
                return
            end
            local jobIds = {}
            for _, job in ipairs(jobs or {}) do
                if job.Id then
                    table.insert(jobIds, job.Id)
                end
            end
            cb(jobIds)
        end)
    end)    

    Callbacks:RegisterServerCallback('Admin:getWorkplaceforjob', function(source, data, cb)
        if not data or type(data) ~= "string" then
            cb(false)
            return
        end
        Database.Game:find({
            collection = "jobs",
            query = { Name = data }
        }, function(isSuccessful, jobs)
            if not isSuccessful or not jobs or #jobs == 0 then
                cb(false)
                return
            end
            local workplaces = {}
            for _, job in ipairs(jobs) do
                if job.Id then
                    table.insert(workplaces, job.Id)
                end
            end
            cb(workplaces)
        end)
    end)

    Callbacks:RegisterServerCallback('Admin:getGradesforjob', function(source, data, cb)
        if not data or type(data) ~= "string" then
            cb(false)
            return
        end
        Database.Game:find({
            collection = "jobs",
            query = { Name = data }
        }, function(isSuccessful, jobs)
            if not isSuccessful or not jobs or #jobs == 0 then
                cb(false)
                return
            end

            local job = jobs[1]
            local grades = {}
            if job.Grades then
                for _, grade in ipairs(job.Grades) do
                    table.insert(grades, {
                        Id = grade.Id,
                        Name = grade.Name,
                        Level = grade.Level,
                        Permissions = grade.Permissions
                    })
                end
            end
            cb(grades)
        end)
    end)

    Callbacks:RegisterServerCallback('Admin:companies', function(source, data, cb)
        local isther, companies = Database.Game:find({
            collection = "jobs",
            query = { Type = "Company" }
        }) or {}
        local companyIds = {}
        for _, company in ipairs(companies) do
            if company.Id then
                table.insert(companyIds, company.Id)
            end
        end
        cb(companyIds)
    end)

    Callbacks:RegisterServerCallback('Admin:SetEnvironment', function(source, data, cb)
        if data.type then
            Sync.Set:Weather(data.type)
        end
        if data.time then
            Sync.Set:TimeType(data.time)
        end
        cb(true)
    end)

    Callbacks:RegisterServerCallback('Admin:removestress', function(source, data, cb)
        Status.Set:Single(tonumber(data.player),"PLAYER_STRESS", 0)
        cb(true)
    end)

    Callbacks:RegisterServerCallback("Admin:updateAdmin", function(source, data, cb)
        local sourcePlayer = Fetch:Source(source)
        local targetPlayer = Fetch:Source(data.player)
        local role = data.permType
    
        if not sourcePlayer then
            Execute:Client(source, "Notification", "Error", "Unable to fetch your data.")
            return
        end
    
        if not targetPlayer then
            Execute:Client(source, "Notification", "Error", "Player not found.")
            return
        end
    
        if not roleHierarchy[role] then
            Execute:Client(source, "Notification", "Error", "Invalid role selected.")
            return
        end
    
        local sourceIdentifier = GetPlayerIdentifier(source, 0)
        local targetIdentifier = targetPlayer:GetData("Identifier")
        local targetRoles = targetPlayer:GetData("Groups") or {}
        local sourceRoles = sourcePlayer:GetData("Groups") or {}
        local sourceHighestRoleLevel = math.huge
        local targetHighestRoleLevel = math.huge
    
        for _, r in ipairs(sourceRoles) do
            if roleHierarchy[r] and roleHierarchy[r] < sourceHighestRoleLevel then
                sourceHighestRoleLevel = roleHierarchy[r]
            end
        end
    
        for _, r in ipairs(targetRoles) do
            if roleHierarchy[r] and roleHierarchy[r] < targetHighestRoleLevel then
                targetHighestRoleLevel = roleHierarchy[r]
            end
        end
    
        local isDeveloper = false
        for _, r in ipairs(sourceRoles) do
            if r == "Developer" then
                isDeveloper = true
                break
            end
        end
    
        if not isDeveloper and not superAdmins[sourceIdentifier] then
            if roleHierarchy[role] < sourceHighestRoleLevel then
                Execute:Client(source, "Notification", "Error", "You cannot assign a role higher than your own.")
                return
            end
    
            if targetHighestRoleLevel < sourceHighestRoleLevel then
                Execute:Client(source, "Notification", "Error", "You cannot modify someone with a higher or equal role.")
                return
            end
        end
    
        local targetChar = targetPlayer:GetData('Character')
        local targetName = targetChar and (targetChar:GetData("First") .. " " .. targetChar:GetData("Last")) or "Unknown Player"
        local sourceChar = sourcePlayer:GetData('Character')
        local sourceName = sourceChar and (sourceChar:GetData("First") .. " " .. sourceChar:GetData("Last")) or "Unknown Source"
    
        Database.Auth:updateOne({
            collection = "users",
            query = { identifier = targetIdentifier },
            update = { ["$set"] = { groups = { role } } }
        }, function(success, result)
            if success then
                Execute:Client(source, "Notification", "Success", role .. " has been added to " .. tostring(targetIdentifier))
    
                local embed = {
                    {
                        title = "Role Update Notification",
                        description = sourceName .. " (" .. sourceIdentifier .. ") has assigned the role **" .. role .. "** to **" .. targetName .. "** (" .. targetIdentifier .. ").",
                        color = 65280,
                        fields = {
                            { name = "Updated By", value = sourceName .. " (" .. sourceIdentifier .. ")", inline = true },
                            { name = "Target Player", value = targetName, inline = true },
                            { name = "Role Assigned", value = role, inline = true }
                        },
                        footer = { text = "Role Update System" },
                        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
                    }
                }
    
                PerformHttpRequest(webhookUrl, function(err, text, headers)
                    if err ~= 204 then
                        print("[ERROR] Discord Webhook returned: " .. tostring(err))
                    end
                end, "POST", json.encode({
                    username = "Role Update Bot",
                    embeds = embed
                }), { ["Content-Type"] = "application/json" })
            else
                Execute:Client(source, "Notification", "Error", "Failed to update the player's role. Please try again later.")
            end
        end)
    end)

end