export const commandCategories = {
    Player: {
        label: 'Player Management',
        commands: [
            {
                name: 'Update Player PERMEISSIONS',
                action: 'updateperm',
                description: 'Toggle God Mode',
                category: 'Player',
                params: [
                    { name: 'player', help: 'Choose a player', parmasType: 'choices' },
                    { name: 'permType', help: 'Choose a role', parmasType: 'choices' },
                ],
                isToggle: true,
                roles: ['Owner', 'Developer']                
                
            },
            {
                name: 'God Mode',
                action: 'god',
                description: 'Toggle God Mode',
                category: 'Player',
                params: [],
                isToggle: true,
                roles: ['Owner', 'Developer']                
                
            },
            {
                name: 'Die',
                action: 'die',
                description: 'Kill A Player',
                category: 'Player',
                params: [
                    { name: 'player', help: 'Choose a player', parmasType: 'choices' },
                ],
                isToggle: false,
                roles: ['Admin', 'Owner', 'Developer']                
            },
            {
                name: 'Set Ped',
                action: 'zsetped',
                description: '[Admin] Set player ped model',
                category: 'Player',
                params: [
                    { name: 'player', help: 'Choose a player', parmasType: 'choices' },
                    { name: 'ped', help: 'Ped Model', parmasType: 'choices' }
                ],
                roles: ['Owner', 'Developer']                
            },
            {
                name: 'Add Cash',
                action: 'addcash',
                description: 'Give Cash To Yourself',
                category: 'Player',
                params: [
                    { name: 'amount', help: 'Amount of cash to give', parmasType: 'text' }
                ],
                roles: ['Owner', 'Developer']                
            },
            // {
            //     name: 'Add State',
            //     action: 'addstate',
            //     description: 'Add A State To Yourself',
            //     category: 'Player',
            //     params: [
            //         { name: 'state', help: 'The State You Want To Add', parmasType: 'choices' }
            //     ],
            //     roles: ['Developer']
            // },
            {
                name: 'Screenshot',
                action: 'screenshot',
                description: 'Take a Screenshot of Player',
                category: 'Player',
                params: [
                    { name: 'player', help: 'Choose a player', parmasType: 'choices' },
                ],
                roles: ['Support', 'Mod', 'Admin', 'Owner', 'Developer']                
            },
            {
                name: 'Remove Stress',
                action: 'removestress',
                description: 'Remove Stress from Player',
                category: 'Player',
                params: [
                    { name: 'player', help: 'Choose a player', parmasType: 'choices' },
                ],
                roles: ['Support', 'Mod', 'Admin', 'Owner', 'Developer']                
            },
            {
                name: 'Wardrobe',
                action: 'wardrobe',
                description: 'Open Wardrobe Menu',
                category: 'Player',
                params: [
                    { name: 'player', help: 'Choose a player', parmasType: 'choices' },
                    { name: 'wardrobeType', help: 'Type', parmasType: 'choices' }
                    
                ],
                roles: ['Support', 'Mod', 'Admin', 'Owner', 'Developer']
            }
        ]
    },
    Items: {
        label: 'Items & Inventory',
        commands: [
            {
                name: 'Give Item',
                action: 'giveitem',
                description: 'Give Item to Player',
                category: 'Items',
                params: [
                    { name: 'player', help: 'Choose a player', parmasType: 'choices' },
                    { name: 'itemName', help: 'The name of the Item', parmasType: 'choices'
                    },
                    { name: 'itemCount', help: 'The count of the Item', parmasType: 'text' }
                ],
                roles: ['Admin', 'Owner', 'Developer']                
            },
            {
                name: 'Give Weapon',
                action: 'giveweapon',
                description: 'Give Weapon to Player',
                category: 'Items',
                params: [
                    { name: 'player', help: 'Choose a player', parmasType: 'choices' },
                    { name: 'weaponName', help: 'The name of the Weapon', parmasType: 'choices'},
                    { name: 'ammo', help: 'The amount of ammo with the weapon', parmasType: 'text' },
                    { name: 'scratched', help: 'Whether to spawn with a normal serial number (1 = true, 0 = false)', parmasType: 'text' }
                ],
                roles: ['Owner', 'Developer']                
            },
            // {
            //     name: 'Open Inventory',
            //     action: 'openinventory',
            //     description: 'Open Player Inventory',
            //     category: 'Items',
            //     params: [
            //         { name: 'player', help: 'Choose a player', parmasType: 'choices' },
            //     ],
            //     roles: ['Developer']
            // },
            {
                name: 'Open Stash',
                action: 'openstash',
                description: 'Open a Stash',
                category: 'Items',
                params: [
                    { name: 'stashId', help: 'ID of the stash to open', parmasType: 'text' }
                ],
                roles: ['Admin', 'Owner', 'Developer']                
            },
            {
                name: 'Open Trunk',
                action: 'opentrunk',
                description: 'Open Vehicle Trunk',
                category: 'Items',
                params: [
                    { name: 'vin', help: 'Vehicle VIN', parmasType: 'text' }
                ],
                roles: ['Admin', 'Owner', 'Developer']                
            },
            // {
            //     name: 'Clear Inventory',
            //     action: 'clearinventory',
            //     description: 'Clear Player Inventory',
            //     category: 'Items',
            //     params: [
            //         { name: 'player', help: 'Choose a player', parmasType: 'choices' },
            //     ],
            //     roles: ['Developer']
            // },
            // {
            //     name: 'Clear Inventory (Advanced)',
            //     action: 'clearinventory2',
            //     description: 'Clear Inventory by Owner and Type',
            //     category: 'Items',
            //     params: [
            //         { name: 'owner', help: 'Inventory Owner', parmasType: 'text' },
            //         { name: 'type', help: 'Inventory Type', parmasType: 'text' }
            //     ],
            //     roles: ['Developer']
            // }
        ]
    },
    Heists: {
        label: 'Heist Management',
        commands: [
            {
                name: 'Reset Heist',
                action: 'resetheist',
                description: 'Force Reset Heist',
                category: 'Heists',
                params: [
                    { name: 'heistId', help: 'ID of what heist to reset (paleto, lombank, mazebank, bobcat, fleeca_*)', parmasType: 'choices' }
                ],
                roles: ['Admin', 'Owner', 'Developer']                
            },
            {
                name: 'Disable Power',
                action: 'disablepower',
                description: 'Force Disable Power For Heist',
                category: 'Heists',
                params: [
                    { name: 'heistId', help: 'ID of heist to disable power for (mazebank, lombank, paleto)', parmasType: 'choices' }
                ],
                roles: ['Admin', 'Owner', 'Developer']                
            },
            {
                name: 'Check Heist',
                action: 'checkheist',
                description: 'Check Heist Cooldown',
                category: 'Heists',
                params: [
                    { name: 'heistId', help: 'Optional: ID of heist to check cooldown timer', parmasType: 'choices' }
                ],
                roles: ['Support', 'Mod', 'Admin', 'Owner', 'Developer']                
            }
        ]
    },
    Jobs: {
        label: 'Job Management',
        commands: [
            {
                name: 'Give Job',
                action: 'givejob',
                description: 'Give Player a Job',
                category: 'Jobs',
                params: [
                    { name: 'player', help: 'Choose a player', parmasType: 'choices' },
                    { name: 'jobId', help: 'Job (e.g. police)', parmasType: 'choices' },
                    { name: 'workplaceId', help: 'Workplace (e.g lspd)', parmasType: 'choicesWithBefore' },
                    { name: 'gradeId', help: 'Grade (e.g. chief)', parmasType: 'choicesWithBefore2' }
                ],
                roles: ['Mod', 'Admin', 'Owner', 'Developer']                
            },
            {
                name: 'Remove Job',
                action: 'removejob',
                description: 'Remove A Job From a Character',
                category: 'Jobs',
                params: [
                    { name: 'player', help: 'Choose a player', parmasType: 'choices' },
                    { name: 'jobId', help: 'Job ID (e.g. Police)', parmasType: 'text' }
                ],
                roles: ['Mod', 'Admin', 'Owner', 'Developer']                
            },
            {
                name: 'Set Owner',
                action: 'setowner',
                description: 'Sets the Owner of a Company',
                category: 'Jobs',
                params: [
                    { name: 'jobId', help: 'Job (e.g. burgershot)', parmasType: 'choices' },
                    { name: 'player', help: 'Choose a player', parmasType: 'choices' },
                ],
                roles: ['Mod', 'Admin', 'Owner', 'Developer']                
            }
        ]
    },
    Storage: {
        label: 'Storage Units',
        commands: [
            {
                name: 'Add Storage Unit',
                action: 'unitadd',
                description: 'Add New Storage Unit To Database',
                category: 'Storage',
                params: [
                    { name: 'unitLevel', help: 'Storage Unit Level 1-3', parmasType: 'text' },
                    { name: 'unitLabel', help: 'Name for the storage unit', parmasType: 'text' },
                    { name: 'managingBusiness', help: 'Business who will manage this', parmasType: 'text' }
                ],
                roles: ['Developer']
            },
            {
                name: 'Copy Unit ID',
                action: 'unitcopy',
                description: 'Copy ID of Closest Storage Unit',
                category: 'Storage',
                params: [],
                roles: ['Developer']
            },
            {
                name: 'Delete Unit',
                action: 'unitdelete',
                description: 'Delete Storage Unit',
                category: 'Storage',
                params: [
                    { name: 'unitId', help: 'Storage Unit ID', parmasType: 'text' }
                ],
                roles: ['Developer']
            },
            {
                name: 'Own Unit',
                action: 'unitown',
                description: 'Own Storage Unit',
                category: 'Storage',
                params: [
                    { name: 'unitId', help: 'Storage Unit ID', parmasType: 'text' }
                ],
                roles: ['Developer']
            }
        ]
    },
    MDT: {
        label: 'MDT Management',
        commands: [
            {
                name: 'Set Callsign',
                action: 'setcallsign',
                description: 'Assign a callsign to an emergency worker',
                category: 'MDT',
                params: [
                    { name: 'player', help: 'Choose a player', parmasType: 'choices' },
                    { name: 'callsign', help: 'The callsign you want to assign', parmasType: 'text' }
                ],
                roles: ['Support', 'Mod', 'Admin', 'Owner', 'Developer']                
            },
            {
                name: 'Reclaim Callsign',
                action: 'reclaimcallsign',
                description: 'Force Reclaim a Callsign',
                category: 'MDT',
                params: [
                    { name: 'callsign', help: 'The callsign you want to reclaim', parmasType: 'text' }
                ],
                roles: ['Support', 'Mod', 'Admin', 'Owner', 'Developer']                
            },
            {
                name: 'Add MDT SysAdmin',
                action: 'addmdtsysadmin',
                description: 'Grant MDT System Admin',
                category: 'MDT',
                params: [
                    { name: 'player', help: 'Choose a player', parmasType: 'choices' },
                ],
                roles: ['Admin', 'Owner', 'Developer']                
            },
            {
                name: 'Remove MDT SysAdmin',
                action: 'removemdtsysadmin',
                description: 'Revoke MDT System Admin',
                category: 'MDT',
                params: [
                    { name: 'player', help: 'Choose a player', parmasType: 'choices' },
                ],
                roles: ['Admin', 'Owner', 'Developer']                
            }
        ]
    },
    Dealership: {
        label: 'Dealership Management',
        commands: [
            {
                name: 'Set Stock',
                action: 'setstock',
                description: '[Admin] Set Stock in a Vehicle Dealership',
                category: 'Dealership',
                params: [
                    { name: 'dealershipId', help: 'ID of the Dealership e.g pdm, tuna or redline', parmasType: 'text' },
                    { name: 'vehicleId', help: 'ID of the Vehicle e.g faggio', parmasType: 'text' },
                    { name: 'modelType', help: 'E.g automobile, bike, boat', parmasType: 'text' },
                    { name: 'amount', help: 'Quantity of Vehicle To Add', parmasType: 'text' },
                    { name: 'price', help: 'Price of Vehicle (Before commission)', parmasType: 'text' },
                    { name: 'class', help: 'Class e.g B', parmasType: 'text' },
                    { name: 'make', help: 'Make e.g Pegassi', parmasType: 'text' },
                    { name: 'model', help: 'Model e.g Faggio', parmasType: 'text' },
                    { name: 'category', help: 'Category e.g. import, drift, coupe', parmasType: 'text' }
                ],
                roles: ['Admin', 'Owner', 'Developer']                
            },
            {
                name: 'Increase Stock',
                action: 'incstock',
                description: 'Increase Vehicle Stock',
                category: 'Dealership',
                params: [
                    { name: 'dealershipId', help: 'ID of the Dealership', parmasType: 'text' },
                    { name: 'vehicleId', help: 'ID of the Vehicle', parmasType: 'text' },
                    { name: 'amount', help: 'Amount to add', parmasType: 'text' }
                ],
                roles: ['Admin', 'Owner', 'Developer']                
            },
            {
                name: 'Set Stock Price',
                action: 'setstockprice',
                description: 'Set Vehicle Price',
                category: 'Dealership',
                params: [
                    { name: 'dealershipId', help: 'ID of the Dealership', parmasType: 'text' },
                    { name: 'vehicleId', help: 'ID of the Vehicle', parmasType: 'text' },
                    { name: 'price', help: 'New price', parmasType: 'text' }
                ],
                roles: ['Admin', 'Owner', 'Developer']                
            },
            {
                name: 'Set Stock Name',
                action: 'setstockname',
                description: 'Set Vehicle Make/Model/class',
                category: 'Dealership',
                params: [
                    { name: 'dealershipId', help: 'ID of the Dealership', parmasType: 'text' },
                    { name: 'vehicleId', help: 'ID of the Vehicle', parmasType: 'text' },
                    { name: 'make', help: 'Make name', parmasType: 'text' },
                    { name: 'model', help: 'Model name', parmasType: 'text' },
                    { name: 'class', help: 'Class name (if u wanna change it)', parmasType: 'text' }
                ],
                roles: ['Admin', 'Owner', 'Developer']                
            },
        ]
    },
    Messages: {
        label: 'Messages & Communication',
        commands: [
            {
                name: 'Server Message',
                action: 'server',
                description: 'Send Server Message To All Players',
                category: 'Messages',
                params: [
                    { name: 'message', help: 'Message to send', parmasType: 'text' }
                ],
                roles: ['Owner', 'Developer']                
            },
            {
                name: 'System Message',
                action: 'system',
                description: 'Send System Message To All Players',
                category: 'Messages',
                params: [
                    { name: 'message', help: 'Message to send', parmasType: 'text' }
                ],
                roles: ['Admin', 'Owner', 'Developer']                
            },
            {
                name: 'Broadcast',
                action: 'broadcast',
                description: 'Make A Broadcast To All Players',
                category: 'Messages',
                params: [
                    { name: 'message', help: 'Message to broadcast', parmasType: 'text' }
                ],
                roles: ['Mod', 'Admin', 'Owner', 'Developer']                
            },
            {
                name: 'Email',
                action: 'email',
                description: 'Send Email To Player',
                category: 'Messages',
                params: [
                    { name: 'player', help: 'Choose a player', parmasType: 'choices' },
                    { name: 'senderEmail', help: 'Email To Show As Sender', parmasType: 'text' },
                    { name: 'subject', help: 'Subject Line Of Email', parmasType: 'text' },
                    { name: 'body', help: 'Body of email to send', parmasType: 'text' }
                ],
                roles: ['Mod', 'Admin', 'Owner', 'Developer']                
            }
        ]
    },
    Apps: {
        label: 'App Management',
        commands: [
            {
                name: 'Phone Permission',
                action: 'phoneperm',
                description: 'Add Specified App Permission',
                category: 'Apps',
                params: [
                    { name: 'player', help: 'Choose a player', parmasType: 'choices' },
                    { name: 'appId', help: 'ID of the app', parmasType: 'text' },
                    { name: 'permId', help: 'Permission', parmasType: 'text' }
                ],
                roles: ['Owner', 'Developer']                
            },
            {
                name: 'Laptop Permission',
                action: 'laptopperm',
                description: 'Add Specified Laptop App Permission',
                category: 'Apps',
                params: [
                    { name: 'player', help: 'Choose a player', parmasType: 'choices' },
                    { name: 'appId', help: 'ID of the app', parmasType: 'text' },
                    { name: 'permId', help: 'Permission', parmasType: 'text' }
                ],
                roles: ['Owner', 'Developer']                
            },
            {
                name: 'BizWiz Access',
                action: 'bizwizset',
                description: 'Grant BizWiz Access',
                category: 'Apps',
                params: [
                    { name: 'jobId', help: 'Job ID', parmasType: 'text' },
                    { name: 'bizWizType', help: 'e.g. default, mechanic (false to remove)', parmasType: 'text' }
                ],
                roles: ['Owner', 'Developer']                
            },
            {
                name: 'BizWiz Logo',
                action: 'bizwizlogo',
                description: 'Set BizWiz Logo',
                category: 'Apps',
                params: [
                    { name: 'jobId', help: 'Job ID', parmasType: 'text' },
                    { name: 'logoUrl', help: 'BizWiz Logo Link (imgur) (false to remove)', parmasType: 'text' }
                ],
                roles: ['Owner', 'Developer']                
            },
            {
                name: 'Clear Alias',
                action: 'clearalias',
                description: 'Clear Player App Alias',
                category: 'Apps',
                params: [
                    { name: 'player', help: 'Choose a player', parmasType: 'choices' },
                    { name: 'appId', help: 'App ID to reset the players alias for', parmasType: 'text' }
                ],
                roles: ['Support', 'Mod', 'Admin', 'Owner', 'Developer']                
            }
        ]
    },
    Reputation: {
        label: 'Reputation Management',
        commands: [
            {
                name: 'Add Reputation',
                action: 'addrep',
                description: 'Add Specified Reputation To Player',
                category: 'Reputation',
                params: [
                    { name: 'player', help: 'Choose a player', parmasType: 'choices' },
                    { name: 'repId', help: 'ID of the reputation you want to give', parmasType: 'text' },
                    { name: 'amount', help: 'Amount of reputation to give', parmasType: 'text' }
                ],
                roles: ['Owner', 'Developer']                
            },
            {
                name: 'Remove Reputation',
                action: 'remrep',
                description: 'Remove Specified Reputation From Player',
                category: 'Reputation',
                params: [
                    { name: 'player', help: 'Choose a player', parmasType: 'choices' },
                    { name: 'repId', help: 'ID of the reputation you want to take', parmasType: 'text' },
                    { name: 'amount', help: 'Amount of reputation to take', parmasType: 'text' }
                ],
                roles: ['Owner', 'Developer']                
            }
        ]
    },
    Crypto: {
        label: 'Cryptocurrency',
        commands: [
            {
                name: 'Add Crypto',
                action: 'addcrypto',
                description: 'Give cryptocurrency to a character',
                category: 'Crypto',
                params: [
                    { name: 'player', help: 'Choose a player', parmasType: 'choices' },
                    { name: 'coin', help: 'Type of cryptocurrency to give (VRM, PLEB or HEIST)', parmasType: 'choices' },
                    { name: 'amount', help: 'Amount of cryptocurrency to give', parmasType: 'text' }
                ],
                roles: ['Owner', 'Developer']                
            }
        ]
    },
    Misc: {
        label: 'Miscellaneous',
        commands: [
            {
                name: 'Set Billboard',
                action: 'setbillboard',
                description: 'Set a Billboard URL',
                category: 'Misc',
                params: [
                    { name: 'id', help: 'Billboard ID', parmasType: 'text' },
                    { name: 'url', help: 'Billboard URL', parmasType: 'text' }
                ],
                roles: ['Developer']
            },
            {
                name: 'Set Environment',
                action: 'setenvironment',
                description: 'Change Weather/Time',
                category: 'Misc',
                params: [
                    { name: 'type', help: 'Weather type: clear, rain, foggy, thunder, etc', parmasType: 'choices' },
                    { name: 'time', help: 'noon, night, etc', parmasType: 'choices' }
                ],
                roles: ['Support', 'Mod', 'Admin', 'Owner', 'Developer']                
            },
            {
                name: 'Toggle Robbery',
                action: 'togglerobbery',
                description: 'Enables/Disables Robberies',
                category: 'Misc',
                params: [],
                isToggle: true,
                roles: ['Admin', 'Owner', 'Developer']                
            },
            {
                name: 'Check Shitlord',
                action: 'checkshitlord',
                description: 'Display AntiShitlord Cooldown Timer',
                category: 'Misc',
                params: [],
                roles: ['Developer']
            },
            {
                name: 'Reset Shitlord',
                action: 'resetshitlord',
                description: 'Reset AntiShitlord Cooldown Timer',
                category: 'Misc',
                params: [],
                roles: ['Owner', 'Developer']                
            },
            // {
            //     name: 'Clear Beds',
            //     action: 'clearbeds',
            //     description: 'Force Clear All Hospital Beds',
            //     category: 'Misc',
            //     params: [],
            //     roles: ['Developer']
            // },
            {
                name: 'Print Queue',
                action: 'printqueue',
                description: 'Prints Players In Specified Waitlist',
                category: 'Misc',
                params: [
                    { name: 'id', help: 'ID of the Waitlist to print', parmasType: 'text' }
                ],
                roles: ['Developer']
            },
            // {
            //     name: 'Add Oxy Run',
            //     action: 'addoxyrun',
            //     description: 'Add Available Oxy Runs',
            //     category: 'Misc',
            //     params: [
            //         { name: 'number', help: 'Number of Oxy Runs To Add To Available Pool', parmasType: 'text' }
            //     ],
            //     roles: ['Developer']
            // },
            // {
            //     name: 'Boosting Event',
            //     action: 'boostingevent',
            //     description: 'Toggle Boosting Event Mode',
            //     category: 'Misc',
            //     params: [],
            //     isToggle: true,
            //     roles: ['Developer']
            // },
            {
                name: 'Get Alias',
                action: 'getalias',
                description: 'Get Racing Alias',
                category: 'Misc',
                params: [
                    { name: 'player', help: 'Choose a player', parmasType: 'choices' },
                ],
                roles: ['Support', 'Mod', 'Admin', 'Owner', 'Developer']                
            },
            // {
            //     name: 'Store Bank',
            //     action: 'storebank',
            //     description: 'Link Bank Account To Shop',
            //     category: 'Misc',
            //     params: [
            //         { name: 'shopId', help: 'Shop ID To Attach Bank Account To', parmasType: 'text' },
            //         { name: 'accountNumber', help: 'Account Number To Attach Bank Account To', parmasType: 'text' }
            //     ],
            //     roles: ['Developer']
            // },
            {
                name: 'Disable Lockdown',
                action: 'disablelockdown',
                description: 'Disable Restart Lockdown',
                category: 'Misc',
                params: [],
                isToggle: true,
                roles: ['Owner', 'Developer']                
            }
        ]
    }
};

export default commandCategories;