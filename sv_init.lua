AddEventHandler("Core:Shared:Ready", function()
    COMPONENTS.Default:AddAuth('roles', 1736789293, {
        {
            Abv = "Whitelisted",
            Name = "Whitelisted",
            Queue = { Priority = 0 },
            Permission = { Level = 0, Group = "" },
        },
        {
            Abv = "Support",
            Name = "Support",
            Queue = { Priority = 0 },
            Permission = { Level = 10, Group = "support" },
        },
        {
            Abv = "Moderator",
            Name = "Moderator",
            Queue = { Priority = 0 },
            Permission = { Level = 20, Group = "moderator" },
        },
        {
            Abv = "Staff",
            Name = "Staff",
            Queue = { Priority = 0 },
            Permission = { Level = 50, Group = "staff" },
        },
        {
            Abv = "Admin",
            Name = "Admin",
            Queue = { Priority = 0 },
            Permission = { Level = 75, Group = "admin" },
        },
        {
            Abv = "Owner",
            Name = "Owner",
            Queue = { Priority = 90 },
            Permission = { Level = 100, Group = "owner" },
        },
        {
            Abv = "Developer",
            Name = "Developer",
            Queue = { Priority = 90 },
            Permission = { Level = 101, Group = "developer" },
        },
    })

    Wait(5000) -- Ensure `AddAuth` finishes

    COMPONENTS.Database.Auth:find({
        collection = "roles",
        query = {},
    }, function(success, results)
        if not success or #results <= 0 then
            COMPONENTS.Logger:Critical("Core", "Failed to Load User Groups. Attempting to recreate defaults.", {
                console = true,
                file = true,
            })

			COMPONENTS.Default:AddAuth('roles', 1736787293, {
				{
					Abv = "Whitelisted",
					Name = "Whitelisted",
					Queue = { Priority = 0 },
					Permission = { Level = 0, Group = "" },
				},
				{
					Abv = "Support",
					Name = "Support",
					Queue = { Priority = 0 },
					Permission = { Level = 10, Group = "support" },
				},
				{
					Abv = "Moderator",
					Name = "Moderator",
					Queue = { Priority = 0 },
					Permission = { Level = 20, Group = "Moderator" },
				},
				{
					Abv = "Staff",
					Name = "Staff",
					Queue = { Priority = 0 },
					Permission = { Level = 50, Group = "staff" },
				},
				{
					Abv = "Admin",
					Name = "Admin",
					Queue = { Priority = 0 },
					Permission = { Level = 75, Group = "admin" },
				},
				{
					Abv = "Owner",
					Name = "Owner",
					Queue = { Priority = 90 },
					Permission = { Level = 100, Group = "owner" },
				},
				{
					Abv = "Developer",
					Name = "Developer",
					Queue = { Priority = 90 },
					Permission = { Level = 101, Group = "developer" },
				},
			})
            return
        end

        COMPONENTS.Config.Groups = {}

        for k, v in ipairs(results) do
            COMPONENTS.Config.Groups[v.Abv] = v
        end

        COMPONENTS.Logger:Warn("Core", string.format("Loaded %s User Groups", #results), {
            console = true,
        })
    end)
end)
