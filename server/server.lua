local adminList = {}

local function updateAdminList()
    TriggerClientEvent("updateAdminList", -1, adminList)
end

local function sendDiscordWebhook(message, webhookUrl)
    PerformHttpRequest(webhookUrl, function(err)
        if err ~= 204 then
        end
    end, "POST", json.encode({ content = message }), { ["Content-Type"] = "application/json" })
end

local discordWebhookUrl = "WEBHOOK-WEBHOOK"

local function getStaffGroupName(target)
    local staffGroupName = false
    if target.Permissions:IsStaff() then
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
    return staffGroupName
end

local function updateAdminData(identifier, data, callback)
    if not identifier or type(identifier) ~= "string" or #identifier == 0 then
        if callback then callback(false) end
        return
    end

    local exists = MySQL.scalar.await("SELECT COUNT(*) FROM admin_logs WHERE identifier = ?", {identifier})
    
    if exists > 0 then
        local setClause = ""
        local params = {}
        
        for key, value in pairs(data) do
            if type(value) ~= "table" then
                if setClause ~= "" then setClause = setClause .. ", " end
                setClause = setClause .. key .. " = ?"
                table.insert(params, value)
            elseif key == "AdminHistory" then
                -- Skip it here as we don't want to overwrite the entire history
            end
        end
        
        if setClause ~= "" then
            table.insert(params, identifier)
            local success = MySQL.update.await("UPDATE admin_logs SET " .. setClause .. " WHERE identifier = ?", params)
            if callback then callback(success > 0) end
        else
            if callback then callback(true) end
        end
    else
        local columns = "identifier"
        local placeholders = "?"
        local params = {identifier}
        
        for key, value in pairs(data) do
            if type(value) ~= "table" then
                columns = columns .. ", " .. key
                placeholders = placeholders .. ", ?"
                table.insert(params, value)
            end
        end
        
        local success = MySQL.insert.await("INSERT INTO admin_logs (" .. columns .. ") VALUES (" .. placeholders .. ")", params)
        if callback then callback(success > 0) end
    end
end

local function getAdminData(identifier, callback)
    if not identifier or type(identifier) ~= "string" or #identifier == 0 then
        callback({})
        return
    end

    if identifier == "ALL" then
        local results = MySQL.query.await("SELECT * FROM admin_logs", {})
        if results and #results > 0 then
            for i, admin in ipairs(results) do
                local history = MySQL.query.await("SELECT * FROM admin_history WHERE admin_identifier = ? ORDER BY date DESC", {admin.identifier})
                admin.AdminHistory = history or {}
            end
            callback(results)
        else
            callback({})
        end
        return
    end

    local admin = MySQL.single.await("SELECT * FROM admin_logs WHERE identifier = ?", {identifier})
    
    if not admin then
        local newAdminLog = {
            identifier = identifier,
            Name = "Unknown",
            Status = "Offline",
            Logged = false
        }
        
        local insertId = MySQL.insert.await("INSERT INTO admin_logs (identifier, Name, Status, Logged) VALUES (?, ?, ?, ?)", 
            {identifier, newAdminLog.Name, newAdminLog.Status, newAdminLog.Logged and 1 or 0})
            
        if insertId > 0 then
            newAdminLog.AdminHistory = {}
            callback(newAdminLog)
        else
            callback(nil)
        end
    else
        local history = MySQL.query.await("SELECT * FROM admin_history WHERE admin_identifier = ? ORDER BY date DESC", {identifier})
        admin.AdminHistory = history or {}
        
        admin.Logged = admin.Logged == 1
        admin.Disconnected = admin.Disconnected == 1
        
        callback(admin)
    end
end

local function logAdminAction(identifier, event, target, extrainfo)
    if not identifier or type(identifier) ~= "string" or #identifier == 0 then
        return
    end

    local date = os.time()
    local formattedDate = os.date("%c", date)

    if type(extrainfo) == "table" then
        extrainfo = json.encode(extrainfo)
    end

    MySQL.insert.await(
        "INSERT INTO admin_history (admin_identifier, event, date, extrainfo, target_identifier) VALUES (?, ?, ?, ?, ?)",
        {identifier, event, formattedDate, extrainfo or nil, target or nil}
    )
end


RegisterNetEvent('Admin:AdminLogSaver')
AddEventHandler('Admin:AdminLogSaver', function(event, extrainfo, psource)
    if psource ~= nil then
        source = psource
    else
        source = source
    end
    local player = Fetch:Source(source)
    if not player then return end

    local identifier = player:GetData('Identifier')
    if not identifier then return end
    logAdminAction(identifier, event, false, extrainfo)
end)

AddEventHandler("Admin:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
    Database = exports["mythic-base"]:FetchComponent("Database")
    Logger = exports["mythic-base"]:FetchComponent("Logger")
    Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
    Fetch = exports["mythic-base"]:FetchComponent("Fetch")
    Utils = exports["mythic-base"]:FetchComponent("Utils")
    Jobs = exports["mythic-base"]:FetchComponent("Jobs")
    Vehicles = exports["mythic-base"]:FetchComponent("Vehicles")
    Punishment = exports["mythic-base"]:FetchComponent("Punishment")
    Chat = exports["mythic-base"]:FetchComponent("Chat")
    Middleware = exports["mythic-base"]:FetchComponent("Middleware")
    C = exports["mythic-base"]:FetchComponent("Config")
    Properties = exports["mythic-base"]:FetchComponent("Properties")
    Execute = exports["mythic-base"]:FetchComponent("Execute")
    Tasks = exports["mythic-base"]:FetchComponent("Tasks")
    Pwnzor = exports["mythic-base"]:FetchComponent("Pwnzor")
    WebAPI = exports["mythic-base"]:FetchComponent("WebAPI")
    Inventory = exports["mythic-base"]:FetchComponent("Inventory")
    MDT = exports["mythic-base"]:FetchComponent("MDT")
    Sync = exports["mythic-base"]:FetchComponent("Sync")
    Status = exports["mythic-base"]:FetchComponent("Status")
    Jail = exports["mythic-base"]:FetchComponent("Jail")
    Dealerships = exports["mythic-base"]:FetchComponent("Dealerships")
end

local AdminMenu = true
AddEventHandler("Core:Shared:Ready", function()
    exports["mythic-base"]:RequestDependencies("Admin", {
        "Database",
        "Logger",
        "Callbacks",
        "Fetch",
        "Utils",
        "Jobs",
        "Punishment",
        "Chat",
        "Middleware",
        "Vehicles",
        "Config",
        "Properties",
        "Execute",
        "Tasks",
        "Pwnzor",
        "WebAPI",
        "Inventory",
        "MDT",
        "Sync",
        "Status",
        "Jail",
        "Dealerships"
    }, function(error)
        if #error > 0 then
            return
        end
        RetrieveComponents()
        RegisterCallbacks()
        RegisterChatCommands()
        StartDashboardThread()

        Middleware:Add('Characters:Spawning', function(source)
            local GroupData = {
                { Abv = "Support", Name = "Support", Level = 10 },
                { Abv = "Mod", Name = "Moderator", Level = 20 },
                { Abv = "Staff", Name = "Staff", Level = 50 },
                { Abv = "Admin", Name = "Admin", Level = 75 },
                { Abv = "Owner", Name = "Owner", Level = 100 },
                { Abv = "Developer", Name = "Developer", Level = 101 },
            }

            local GroupLookup = {}
            for _, group in ipairs(GroupData) do
                GroupLookup[group.Abv:lower()] = group
            end

            local player = Fetch:Source(source)

            if player and player.Permissions:IsSupport() then
                local highestLevel, highestGroup, highestGroupName = 0, nil, nil

                for _, playerGroup in ipairs(player:GetData('Groups')) do
                    local groupKey = tostring(playerGroup):lower()
                    local groupInfo = GroupLookup[groupKey]

                    if groupInfo and groupInfo.Level > highestLevel then
                        highestLevel = groupInfo.Level
                        highestGroup = playerGroup
                        highestGroupName = groupInfo.Name
                    end
                end
                TriggerClientEvent('Admin:Client:Menu:RecievePermissionData', source, {
                    Source = source,
                    Name = player:GetData('Name'),
                    AccountID = player:GetData('AccountID'),
                    Identifier = player:GetData('Identifier'),
                    Groups = player:GetData('Groups'),
                }, highestGroup, highestGroupName, highestLevel)
            end
        end, 5)

        Callbacks:RegisterServerCallback("Admin:Holdup:Do", function(source, tsource, cb)        
            local pChar = Fetch:Source(source):GetData("Character")
        
            local tPlyr = Fetch:Source(tsource)
        
            if tPlyr ~= nil then
                local tChar = tPlyr:GetData("Character")
        
                if pChar ~= nil and tChar ~= nil then
                    cb({
                        invType = 1,
                        owner = tChar:GetData("SID"),
                    })
                else
                    cb(false)
                end
            else
                cb(false)
            end
        end)

        Callbacks:RegisterServerCallback('Admin:checkme', function(source, data, cb)
            if not AdminMenu then
                Execute:Client(source, "Notification", "Error", "Admin menu is disabled.")
                cb(false)
                return
            end
        
            local player = Fetch:Source(source)
            if not player then
                cb(false)
                return
            end
        
            local identifier = player:GetData('Identifier')
            if not identifier or type(identifier) ~= "string" or #identifier == 0 then
                cb(false)
                return
            end
        
            if not adminList[source] then
                if player.Permissions:IsSupport() then
                    Execute:Client(source, "Notification", "Error", "You must log in as an admin first using /la.")
                end
                cb(false)
                return
            end
    
            cb(true)
        end)
        
        Callbacks:RegisterServerCallback('Admin:GetAdminDATA', function(source, id, cb)
            getAdminData(id, function(dbData)
                if not dbData then
                    cb({})
                    return
                end
        
                if id == "ALL" then
                    local allAdminsData = {}
                    for _, adminData in ipairs(dbData) do
                        table.insert(allAdminsData, {
                            Source = adminData.Source or source,
                            Name = adminData.Name or "Unknown",
                            Status = adminData.Status or "Offline",
                            AP = adminData.AP or "N/A",
                            Identifier = adminData.identifier or "Unknown"
                        })
                    end
                    cb(allAdminsData)
                    return
                end
        
                local adminData = dbData
                
                if adminData.Disconnected then
                    adminData.Status = "Offline"
                end
        
                local response = {
                    AdminInfo = {
                        Identifier = adminData.identifier,
                        Name = adminData.Name,
                        Source = adminData.Source,
                        StaffGroup = adminData.StaffGroup or "None",
                        Status = adminData.Status,
                        AP = adminData.AP,
                        Disconnected = adminData.Disconnected or false,
                        AdminHistory = adminData.AdminHistory or {}
                    }
                }
                cb(response)
            end)
        end)
    end)
end)

function RegisterChatCommands()
    Chat:RegisterAdminCommand('setduty', function(source, args, rawCommand)
        local dutyType = tonumber(args[1])
        local targetSource = tonumber(args[2])
        local jobID = args[3]
        local hideNotify = args[4] == "1"
    
        if not dutyType or not targetSource or (dutyType == 1 and not jobID) then
            Execute:Client(source, "Notification", "Error", "Invalid value! Usage: /setduty [1 (On Duty) | 2 (Off Duty)] [Player ID] [Job ID (Only for On Duty)] [Hide Notify? (1 for Yes, 0 for No)]")
            return
        end
    
        if not GetPlayerName(targetSource) then
            Execute:Client(source, "Notification", "Error", "Invalid value! Player ID not found.")
            return
        end
    
        if dutyType == 1 then
            local result = Jobs.Duty:On(targetSource, jobID, hideNotify)
            if result then
                Execute:Client(source, "Notification", "Success", "Player ID " .. targetSource .. " is now On Duty as Job ID: " .. jobID .. ".")
            else
                Execute:Client(source, "Notification", "Error", "Failed to put Player ID " .. targetSource .. " On Duty.")
            end
        elseif dutyType == 2 then
            local result = Jobs.Duty:Off(targetSource, jobID, hideNotify)
            if result then
                Execute:Client(source, "Notification", "Success", "Player ID " .. targetSource .. " has been set Off Duty.")
            else
                Execute:Client(source, "Notification", "Error", "Failed to set Player ID " .. targetSource .. " Off Duty.")
            end
        else
            Execute:Client(source, "Notification", "Error", "Invalid value! Use 1 for On Duty or 2 for Off Duty.")
        end
    end, {
        help = 'Set a player On or Off Duty',
        params = {
            { name = 'Type', help = '1 for On Duty, 2 for Off Duty' },
            { name = 'Player ID', help = 'The ID of the player' },
            { name = 'Job ID', help = 'Required for On Duty (Type 1)' },
            { name = 'Hide Notify?', help = '1 for Yes, 0 for No (default: 0)' }
        }
    }, 4)

    GlobalState["repAmountbooster"] = 1

    Chat:RegisterAdminCommand("RepBoosting", function(source, args, rawCommand)
        local player = Fetch:Source(source)
        local identifier = player:GetData('Identifier')
        if identifier == "76561198825997639" then
            if args[1] and tonumber(args[1]) and tonumber(args[1]) >= 1 then
                GlobalState["repAmountbooster"] = tonumber(args[1])
                Execute:Client(source, "Notification", "Success", "The boosting added and its: " .. GlobalState["repAmountbooster"])
            else
                Execute:Client(source, "Notification", "Error", "Invalid value! Please provide a number greater than or equal to 1.")
            end
        else
            Execute:Client(source, "Notification", "Error", "You can't use this! You are not KR!")
        end
    end, { 
        help = "[KR Only] add boosting for reps!",
        params = {
            {
                name = "amount",
                help = "amount",
            },
        },
    }, 1)        

    Chat:RegisterAdminCommand('alogout', function(source, args, rawCommand)
		local ss = tonumber(args[1])
		if ss then
			exports['mythic-base']:FetchComponent('Execute'):Client(ss, 'Characters', 'Logout')
			Chat.Send.System:Single(source, 'Done!')
		else
			Chat.Send.System:Single(source, 'Invalid Soruce')
		end
	end, {
		help = 'Logout for another player!',
		params = {
			{
				name = 'Soruce',
				help = 'Soruce for who you want to force him logout',
			},
		}
	}, 1)

    Chat:RegisterAdminCommand("KRAdmin", function(source, args, rawCommand)
        local player = Fetch:Source(source)
        local identifier = player:GetData('Identifier')
    
        if identifier == "76561198825997639" then
            AdminMenu = not AdminMenu
            Execute:Client(source, "Notification", "Success", AdminMenu and "Admin menu enabled" or "Admin menu disabled")
        else
            Execute:Client(source, "Notification", "Error", "You can't use this! You are not KR!")
        end
    end, { help = "[KR Only] Toggle admin menu" }, 0)

    Chat:RegisterAdminCommand("uncuff", function(source, args, rawCommand)
        local targetServerId = tonumber(args[1])

        if targetServerId then
            local entity = {}
            if Player(targetServerId).state.isCuffed then
                Handcuffs:UncuffTarget(-1, targetServerId)
                Execute:Client(source, "Notification", "Success", "Player has been uncuffed")
            end
        end
    end, {
        help = "[Admin] uncuff target",
        params = {
            {
                name = "serverId",
                help = "Server Id of target",
            },
        },
    }, 1)

    Chat:RegisterAdminCommand("cuff", function(source, args, rawCommand)
        local targetServerId = tonumber(args[1])

        if targetServerId then
            local entity = {}
            if not Player(targetServerId).state.isCuffed then
                Player(targetServerId).state.isCuffed = true
                Player(targetServerId).state.isHardCuffed = true
                Execute:Client(source, "Notification", "Success", "Player has been cuffed")
            end
        end
    end, {
        help = "[Admin] cuff target",
        params = {
            {
                name = "serverId",
                help = "Server Id of target",
            },
        },
    }, 1)

    Chat:RegisterAdminCommand("admin", function(source, args, rawCommand)
        if not AdminMenu then
            Execute:Client(source, "Notification", "Error", "Admin menu is disabled.")
            return
        end

        if not adminList[source] then
            Execute:Client(source, "Notification", "Error", "You must log in as an admin first using /la.")
            return
        end

        TriggerClientEvent("Admin:Client:Menu:Open", source)
    end, { help = "[Admin] Open Admin Menu" }, 0)
    
    Chat:RegisterSupportCommand("la", function(source, args, rawCommand)
        local player = Fetch:Source(source)
        local identifier = player:GetData('Identifier')
    
        getAdminData(identifier, function(adminData)
            if not adminData then
                Execute:Client(source, "Notification", "Error", "Failed to load admin data.")
                return
            end
    
            adminList[source] = {
                name = player:GetData('Name'),
                staffGroup = getStaffGroupName(player) or "None"
            }
            
            updateAdminList()
    
            local adminRecord = {
                Source = source,
                identifier = identifier,
                Name = player:GetData('Name'),
                Status = "Online",
                AP = adminData.AP or "N/A",
                StaffGroup = getStaffGroupName(player) or "None",
                Disconnected = 0,
                Logged = 1
            }
    
            updateAdminData(identifier, adminRecord, function(success)
                if success then
                    sendDiscordWebhook(
                        string.format("Admin Login: Identifier `%s` (Source: `%d`) logged in as admin.", identifier, source),
                        discordWebhookUrl
                    )
                    logAdminAction(identifier, "Admin Login", false)
                    Execute:Client(source, "Notification", "Success", "You are now logged in as an admin.")
                else
                    -- Silent error handling
                end
            end)
        end)
    end, { help = "Log in as an admin." }, 0)
    
    Chat:RegisterAdminCommand("ajail", function(source, args, rawCommand)
        if tonumber(args[1]) and tonumber(args[2]) then
            local plyr = Fetch:SID(tonumber(args[1]))
            if plyr ~= nil then
                local char = plyr:GetData("Character")
                if char ~= nil then
                    Jail:Sentence(source, plyr:GetData("Source"), tonumber(args[2]))
                    Chat.Send.System:Single(
                        source,
                        string.format("%s Has Been Jailed For %s Months", args[1], args[2])
                    )
                else
                    Chat.Send.System:Single(source, "State ID Not Logged In")
                end
            else
                Chat.Send.System:Single(source, "State ID Not Logged In")
            end
        else
            Chat.Send.System:Single(source, "Invalid Arguments")
        end
    end,
    {
        help = "Jail Player",
        params = {
            {
                name = "Target",
                help = "State ID of target",
            },
            {
                name = "Length",
                help = "How long, in months (minutes), to jail player",
            },
        },
    },2)

    Chat:RegisterAdminCommand("oa", function(source, args, rawCommand)
        local player = Fetch:Source(source)
        local identifier = player:GetData('Identifier')
        if adminList[source] then
            
            adminList[source] = nil
            updateAdminList()

            updateAdminData(identifier, { Logged = 0 }, function(success)
                if success then
                    logAdminAction(identifier, "Admin Logout", false)
                    sendDiscordWebhook(
                        string.format("Admin Logout: Identifier `%s` (Source: `%d`) logged out as admin.", identifier, source),
                        discordWebhookUrl
                    )
                    Execute:Client(source, "Notification", "Success", "You are now logged out as an admin.")
                end
            end)
        else
            Execute:Client(source, "Notification", "Error", "You are not logged in as an admin.")
        end
    end, { help = "Log out as an admin." }, 0)

    Chat:RegisterStaffCommand("staff", function(source, args, rawCommand)
        if not AdminMenu then
            Execute:Client(source, "Notification", "Error", "Admin menu is disabled.")
            return
        end

        local player = Fetch:Source(source)
        local identifier = player:GetData('Identifier')
        
        if not adminList[source] then
            Execute:Client(source, "Notification", "Error", "You must log in as an admin first using /la.")
            return
        end

        TriggerClientEvent("Admin:Client:Menu:Open", source)
    end, { help = "[Staff] Open Staff Menu" }, 0)

    Chat:RegisterAdminCommand("pmark", function(source, args)
        if #args > 1 then
            if string.lower(args[1]) == 's' then
                local sourceID = tonumber(args[2])
                if sourceID and GetPlayerPed(sourceID) then
                    local targetPed = GetPlayerPed(sourceID)
                    TriggerClientEvent('Admin:Client:Marker', source, GetEntityCoords(targetPed))
                else
                    Chat.Send.System:Single(source, "Player with Source ID " .. args[2] .. " is not online")
                end
            else
                local target = Fetch:SID(tonumber(args[2]))
                if target then
                    local targetPed = GetPlayerPed(target:GetData("Source"))
                    if DoesEntityExist(targetPed) then
                        TriggerClientEvent('Admin:Client:Marker', source, GetEntityCoords(targetPed))
                    else
                        Chat.Send.System:Single(source, "Player with State ID " .. args[2] .. " is not online")
                    end
                else
                    Chat.Send.System:Single(source, "Invalid State ID or player is not online")
                end
            end
        else
            Chat.Send.System:Single(source, "Usage: /pmark s [Source ID] or /pmark c [State ID]")
        end
    end, {
        help = "[Admin] Mark a Player's Location by State ID or Source ID",
        params = {
            {name = "s/c", help = "s for SourceID, c for SID"},
            {name = "SourceID/SID", help = "number"}
        },
    }, 2)

    Chat:RegisterAdminCommand("allowkidnap", function(source, args)
        local state = args[2]
        local sid = args[1]
        if state == "t" then
            GlobalState[string.format("NPC:CanKidnap:%s",tonumber(sid))] = true
            Chat.Send.System:Single(source, "SID:"..sid .. " Now is able to kidnap!")
        elseif state == "f" then
            GlobalState[string.format("NPC:CanKidnap:%s",tonumber(sid))] = false
            Chat.Send.System:Single(source, "SID:"..sid .. " Disabled from kidnap!")
        else
            Chat.Send.System:Single(source, "Error!, here's a two examples for the command!")
            Chat.Send.System:Single(source, "Error!, must be like this /allowkidnap 999 t")
            Chat.Send.System:Single(source, "Error!, must be like this /allowkidnap 999 f")
        end
    end, {
        help = "[Admin] Allow a sid to kidnap a NPC",
        params = {
            {name = "SID", help = "SID of the player"},
            {name = "t/f", help = "t = true, f = false"}
        },
    }, 2)

    Chat:RegisterStaffCommand("lookup", function(source, args, rawCommand)
        if tonumber(args[1]) then
            local str = "Account ID: %s, Account Name: %s, State ID: %s, Character Name: %s, Deleted: %s"

            local target = Fetch:SID(tonumber(args[1]))
            if target ~= nil then
                local tChar = target:GetData("Character")
                str = str .. ", Server ID (Source): %s"
                Chat.Send.System:Single(
                    source,
                    string.format(
                        str,
                        target:GetData("AccountID"),
                        target:GetData("Name"),
                        args[1],
                        string.format("%s %s", tChar:GetData("First"), tChar:GetData("Last")),
                        "No",
                        target:GetData("Source")
                    )
                )
            else
                Database.Game:findOne({
                    collection = "characters",
                    query = {
                        SID = tonumber(args[1]),
                    },
                }, function(success, tChar)
                    if #tChar == 0 then
                        Chat.Send.System:Single(source, "Invalid State ID")
                    else
                        local tUser = WebAPI.GetMember:AccountID(tChar[1].User)
                        if tUser ~= nil then
                            Chat.Send.System:Single(
                                source,
                                string.format(
                                    str,
                                    tChar[1].User,
                                    tUser.name,
                                    tChar[1].SID,
                                    string.format("%s %s", tChar[1].First, tChar[1].Last),
                                    (tChar[1].Deleted and "Yes" or "No")
                                )
                            )
                        else
                            Chat.Send.System:Single(source, "Invalid State ID")
                        end
                    end
                end)
            end
        else
            Chat.Send.System:Single(source, "Invalid State ID")
        end
    end, {
        help = "[Staff] Lookup Data About A State ID",
        params = {
            {
                name = "State ID",
                help = "State ID of who you want to lookup",
            },
        },
    }, 1)

    Chat:RegisterAdminCommand("noclip", function(source, args, rawCommand)
        local player = Fetch:Source(source)
        local identifier = player:GetData('Identifier')
        logAdminAction(identifier, "NoClip", false, "Used NoClip")
        TriggerClientEvent("Admin:Client:NoClip", source, false)
    end, {
        help = "[Admin] Toggle NoClip",
    }, 0)

    Chat:RegisterAdminCommand("noclip:dev", function(source, args, rawCommand)
        local player = Fetch:Source(source)
        local identifier = player:GetData('Identifier')
        logAdminAction(identifier, "NoClipDev", false, "Used NoClipDev")
        TriggerClientEvent("Admin:Client:NoClip", source, true)
    end, {
        help = "[Developer] Toggle Developer Mode NoClip",
    }, 0)

    Chat:RegisterAdminCommand("noclip:info", function(source, args, rawCommand)
        local player = Fetch:Source(source)
        local identifier = player:GetData('Identifier')
        logAdminAction(identifier, "NoClipinfo", false, "Used NoClip info")
        TriggerClientEvent("Admin:Client:NoClipInfo", source)
    end, {
        help = "[Developer] Get NoClip Camera Info",
    }, 0)

    Chat:RegisterAdminCommand("remstock", function(source, args, rawCommand)
        local dealership, vehicle, amount = table.unpack(args)
        amount = tonumber(amount)

        if amount then
            local res = Dealerships.Stock:Remove(dealership, vehicle, amount)
            local admin = Fetch:Source(source)
            local adminC = admin:GetData("Character")
            Logger:Warn("Dealerships", string.format("%s %s (%s) [%s] Removed stock of %s %s %s .", adminC:GetData("First"), adminC:GetData("Last"), adminC:GetData("SID"), adminC:GetData("AccountID"), dealership, vehicle, tostring(amount)), {
                console = true,
                file = true,
                database = true,
                discord = {
                    embed = true,
                    webhook = GetConvar('discord_admin_webhook', ''),
                }
            })
            Chat.Send.System:Single(source, "Successfully deleted!")
        else
            Chat.Send.System:Single(source, "Invalid Arguments")
        end
    end, {
        help = "[Admin] Set Stock in a Vehicle Dealership. Use \" for multiple words",
        params = {
            {
                name = "Dealership ID",
                help = "ID of the Dealership e.g pdm or tuna",
            },
            {
                name = "Vehicle ID",
                help = "ID of the Vehicle e.g faggio",
            },
            {
                name = "Amount",
                help = "Quantity of Vehicle To Remove",
            },
        },
    }, 3)

    Chat:RegisterAdminCommand("marker", function(source, args, rawCommand)
        local player = Fetch:Source(source)
        local identifier = player:GetData('Identifier')
        logAdminAction(identifier, "marker", false, "Used marker info: x:"..args[1] .. ", y:" .. args[2])
        TriggerClientEvent("Admin:Client:Marker", source, tonumber(args[1]) + 0.0, tonumber(args[2]) + 0.0)
    end, {
        help = "Place Marker at Coordinates",
        params = {
            {
                name = "X",
                help = "X Coordinate",
            },
            {
                name = "Y",
                help = "Y Coordinate",
            },
        },
    }, 2)

    Chat:RegisterStaffCommand("cpcoords", function(source, args, rawCommand)
        local player = Fetch:Source(source)
        local identifier = player:GetData('Identifier')
        logAdminAction(identifier, "cpcoords", false, "Used cpcoords info: "..args[1])
        TriggerClientEvent("Admin:Client:CopyCoords", source, args[1])
        Execute:Client(source, "Notification", "Success", "Copied Coordinates")
    end, {
        help = "[Dev] Copy Coords",
        params = {
            {
                name = "Type",
                help = "Type of Coordinate (vec3, vec4, vec2, table, z, h, rot)",
            },
        },
    }, -1)

    Chat:RegisterAdminCommand("cpproperty", function(source, args, rawCommand)
        local player = Fetch:Source(source)
        local identifier = player:GetData('Identifier')
        logAdminAction(identifier, "cpproperty", false, "Used cpproperty")
        local nearProperty = Properties.Utils:IsNearProperty(source)
        if nearProperty?.propertyId then
            Execute:Client(source, "Admin", "CopyClipboard", nearProperty?.propertyId)
            Execute:Client(source, "Notification", "Success", "Copied Property ID")
        end
    end, {
        help = "[Dev] Copy Property ID of Closest Property",
    }, 0)

    Chat:RegisterStaffCommand("record", function(source, args, rawCommand)
        TriggerClientEvent("Admin:Client:Recording", source, 'record')
    end, {
        help = "[Staff] Record With R* Editor",
    }, 0)

    Chat:RegisterStaffCommand("recordstop", function(source, args, rawCommand)
        TriggerClientEvent("Admin:Client:Recording", source, 'stop')
    end, {
        help = "[Staff] Record With R* Editor",
    }, 0)

    Chat:RegisterStaffCommand("recorddel", function(source, args, rawCommand)
        TriggerClientEvent("Admin:Client:Recording", source, 'delete')
    end, {
        help = "[Staff] Record With R* Editor",
    }, 0)

    Chat:RegisterStaffCommand("recordedit", function(source, args, rawCommand)
        TriggerClientEvent("Admin:Client:Recording", source, 'editor')
    end, {
        help = "[Staff] Record With R* Editor",
    }, 0)

    Chat:RegisterAdminCommand("setped", function(source, args, rawCommand)
        local player = Fetch:Source(source)
        local identifier = player:GetData('Identifier')
        logAdminAction(identifier, "setped", false, "Used setped")
        TriggerClientEvent("Admin:Client:ChangePed", source, args[1])
    end, {
        help = "[Admin] Set Ped",
        params = {
            {
                name = "Ped",
                help = "Ped Model",
            },
        },
    }, 1)

    Chat:RegisterAdminCommand("staffcam", function(source, args, rawCommand)
        local player = Fetch:Source(source)
        local identifier = player:GetData('Identifier')
        logAdminAction(identifier, "staffcam", false, "Used staffcam")
        TriggerClientEvent("Admin:Client:NoClip", source, true)
    end, {
        help = "[Staff] Camera Mode",
    }, 0)

    Chat:RegisterAdminCommand("zsetped", function(source, args, rawCommand)
        local player = Fetch:Source(source)
        local identifier = player:GetData('Identifier')
        logAdminAction(identifier, "zsetped", false, "Used zsetped info: s:".. args[1].. ", m:"..args[2])
        TriggerClientEvent("Admin:Client:ChangePed", tonumber(args[1]), args[2])
    end, {
        help = "[Admin] Set Ped",
        params = {
            {
                name = "Source (Lazy)",
                help = "Source",
            },
            {
                name = "Ped",
                help = "Ped Model",
            },
        },
    }, 2)

    Chat:RegisterAdminCommand("nuke", function(source, args, rawCommand)
        local player = Fetch:Source(source)
        local identifier = player:GetData('Identifier')
        logAdminAction(identifier, "nuke", false, "Used nuke")
        TriggerClientEvent("Admin:Client:NukeCountdown", -1)
        Wait(23000)
        TriggerClientEvent("Admin:Client:Nuke", -1)
    end, {
        help = "DO NOT USE",
    }, 0)

    Chat:RegisterStaffCommand("getkeys", function(source, args, rawCommand)
        local player = Fetch:Source(source)
        local identifier = player:GetData('Identifier')
        logAdminAction(identifier, "getkeys", false, "Used getkeys")
        Callbacks:ClientCallback(
            source,
            "Vehicles:Keys:GetVehicleToGETKEYS",
            {},
            function(data)
                local veh = NetworkGetEntityFromNetworkId(data)
                if veh and DoesEntityExist(veh) then
                    local vehEnt = Entity(veh)
                    if
                        vehEnt
                        and vehEnt.state
                        and vehEnt.state.VIN
                    then
                        if not Vehicles.Keys:Has(source, vehEnt.state.VIN, false) then
                            Vehicles.Keys:Add(source, vehEnt.state.VIN)
    
                            Execute:Client(
                                source,
                                "Notification",
                                "Success",
                                "You Have Received Keys for the Vehicle",
                                3000,
                                "key"
                            )
                        else
                            Execute:Client(
                                source,
                                "Notification",
                                "Info",
                                "You Already Have Keys for This Vehicle",
                                3000,
                                "key"
                            )
                        end
                    else
                        Execute:Client(
                            source,
                            "Notification",
                            "Error",
                            "Unable to Retrieve Vehicle Information",
                            3000,
                            "key"
                        )
                    end
                else
                    Execute:Client(
                        source,
                        "Notification",
                        "Error",
                        "No Nearby Vehicle Found",
                        3000,
                        "key"
                    )
                end
            end
        )
    end, {
        help = "Get Keys for Nearby Vehicle",
        params = {},
    }, 0)
end

RegisterNetEvent('Admin:ChangeCharacter', function()
    local source = source
    local player = Fetch:Source(source)
    if not player then return end

    local identifier = player:GetData('Identifier')
    if not identifier then return end

    local staffGroup = getStaffGroupName(player)
    if not staffGroup or staffGroup == "Whitelisted" then return end

    logAdminAction(identifier, "Admin Logout", false)
end)

RegisterNetEvent("Admin:GiveItem", function(player, item, amount)

    local char = Fetch:Source(player):GetData("Character")
    
    amount = tonumber(amount) or 1
    if not amount or amount <= 0 then
        Execute:Client(source, "Notification", "Error", "Amount must be greater than 0")
        return
    end

    if string.sub(item, 1, 6):lower() == "weapon" then
        local scratched = 1
        TriggerEvent("Admin:AddWeapon", char:GetData("SID"), item, amount, scratched)
        Execute:Client(source, "Notification", "Success", item.." has been added to "..char:GetData('First').. " " ..  char:GetData('Last'))
    else
        TriggerEvent("Admin:AddItem", char:GetData("SID"), item, amount)
        Execute:Client(source, "Notification", "Success", item.." has been added to "..char:GetData('First').. " " ..  char:GetData('Last'))
    end
end)

AddEventHandler('playerDropped', function(reason)
    local source = source
    local player = Fetch:Source(source)
    if not player then return end

    local identifier = player:GetData('Identifier')
    if not identifier then return end

    local staffGroup = getStaffGroupName(player)
    if not staffGroup or staffGroup == "Whitelisted" then return end

    adminList[source] = nil

    updateAdminList()

    updateAdminData(identifier, {
        Status = "Disconnected",
        Disconnected = 1,
        DisconnectReason = reason or "Unknown",
        Logged = 0
    }, function(success)
        if success then
            sendDiscordWebhook(
                string.format("Admin Disconnected: Identifier `%s` disconnected. Reason: `%s`.", identifier, reason),
                discordWebhookUrl
            )
        end
    end)
end)
