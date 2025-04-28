# mythic-admin
A edited version of [mythic-admin](https://github.com/Mythic-Framework/mythic-admin) with 6 different roles!

# How to install
Simple, drag & drop, _**But!**_

make sure to add/replace `[mythic]\mythic-base\core\sv_player.lua` with [sv_player.lua](https://github.com/ISKinGeR/mythic-admin/blob/main/sv_player.lua) and `[mythic]\mythic-base\sv_init.lua` with [sv_init.lua](https://github.com/ISKinGeR/mythic-admin/blob/main/sv_init.lua), if you using sandbox version then you will need see if there anything need to edit in these file and edit it manually

# Credits
[Mythic Framework](https://github.com/Mythic-Framework)

# BUGS
__**IF /la not work:**__
- make sure you imported the SQL database
- make sure you have last update which changed the la command from Support to Staff

__**IF choices for giveitem/giveweapn not loaded?:**__
- go to this file `[mythic]\mythic-inventory\client\startup.lua` in ur inventory resource and add at the bottom of the file
```-- Helper function to extract name and label pairs
local function ExtractItemNamesAndLabels()
    local itemList = {}
    for _, itemGroup in pairs(_itemsSource) do
        for _, item in ipairs(itemGroup) do
            table.insert(itemList, item.name)
        end
    end
    return itemList
end

-- Export the list of item names and labels for other resources
exports("GetItemNamesAndLabels", function()
    return ExtractItemNamesAndLabels()
end)```
