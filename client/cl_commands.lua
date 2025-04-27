Config = Config or {}

Config.WeatherTypes = {
    'EXTRASUNNY',
    'CLEAR',
    'NEUTRAL',
    'SMOG',
    'FOGGY',
    'OVERCAST',
    'CLOUDS',
    'CLEARING',
    'RAIN',
    'THUNDER',
    'SNOW',
    'BLIZZARD',
    'SNOWLIGHT',
    'XMAS',
    'HALLOWEEN',
}

Config.Models = {
    "a_c_boar", "a_c_cat_01", "a_c_chickenhawk", "a_c_chimp", "a_c_chop", "a_c_cormorant", "a_c_cow", "a_c_coyote",
    "a_c_crow", "a_c_deer", "a_c_dolphin", "a_c_fish", "a_c_hen", "a_c_humpback", "a_c_husky", "a_c_killerwhale",
    "a_c_mtlion", "a_c_pig", "a_c_pigeon", "a_c_poodle", "a_c_rabbit_01", "a_c_rat", "a_c_retriever", "a_c_rhesus",
    "a_c_rottweiler", "a_c_seagull", "a_c_sharkhammer", "a_c_sharktiger", "a_c_shepherd", "a_c_westy", "a_f_m_beach_01",
    "a_f_m_bevhills_01", "a_f_m_bevhills_02", "a_f_m_bodybuild_01", "a_f_m_business_02", "a_f_m_downtown_01",
    "a_f_m_eastsa_01", "a_f_m_eastsa_02", "a_f_m_fatbla_01", "a_f_m_fatcult_01", "a_f_m_fatwhite_01", "a_f_m_ktown_01",
    "a_f_m_ktown_02", "a_f_m_prolhost_01", "a_f_m_salton_01", "a_f_m_skidrow_01", "a_f_m_soucent_01", "a_f_m_soucent_02",
    "a_f_m_soucentmc_01", "a_f_m_tourist_01", "a_f_m_tramp_01", "a_f_m_trampbeac_01", "a_f_o_genstreet_01",
    "a_f_o_indian_01", "a_f_o_ktown_01", "a_f_o_salton_01", "a_f_o_soucent_01", "a_f_o_soucent_02", "a_f_y_beach_01",
    "a_f_y_bevhills_01", "a_f_y_bevhills_02", "a_f_y_bevhills_03", "a_f_y_bevhills_04", "a_f_y_business_01",
    "a_f_y_business_02", "a_f_y_business_03", "a_f_y_business_04", "a_f_y_eastsa_01", "a_f_y_eastsa_02",
    "a_f_y_eastsa_03", "a_f_y_epsilon_01", "a_f_y_fitness_01", "a_f_y_fitness_02", "a_f_y_genhot_01", "a_f_y_golfer_01",
    "a_f_y_hiker_01", "a_f_y_hippie_01", "a_f_y_hipster_01", "a_f_y_hipster_02", "a_f_y_hipster_03", "a_f_y_hipster_04",
    "a_f_y_indian_01", "a_f_y_juggalo_01", "a_f_y_runner_01", "a_f_y_rurmeth_01", "a_f_y_scdressy_01", "a_f_y_skater_01",
    "a_f_y_soucent_01", "a_f_y_soucent_02", "a_f_y_soucent_03", "a_f_y_tennis_01", "a_f_y_topless_01", "a_f_y_tourist_01",
    "a_f_y_tourist_02", "a_f_y_vinewood_01", "a_f_y_vinewood_02", "a_f_y_vinewood_03", "a_f_y_vinewood_04",
    "a_f_y_yoga_01", "a_m_m_acult_01", "a_m_m_afriamer_01", "a_m_m_beach_01", "a_m_m_beach_02", "a_m_m_bevhills_01",
    "a_m_m_bevhills_02", "a_m_m_business_01", "a_m_m_eastsa_01", "a_m_m_eastsa_02", "a_m_m_farmer_01",
    "a_m_m_fatlatin_01", "a_m_m_genfat_01", "a_m_m_genfat_02", "a_m_m_golfer_01", "a_m_m_hasjew_01", "a_m_m_hillbilly_01",
    "a_m_m_hillbilly_02", "a_m_m_indian_01", "a_m_m_ktown_01", "a_m_m_malibu_01", "a_m_m_mexcntry_01",
    "a_m_m_mexlabor_01", "a_m_m_og_boss_01", "a_m_m_paparazzi_01", "a_m_m_polynesian_01", "a_m_m_prolhost_01",
    "a_m_m_rurmeth_01", "a_m_m_salton_01", "a_m_m_salton_02", "a_m_m_salton_03", "a_m_m_salton_04", "a_m_m_skater_01",
    "a_m_m_skidrow_01", "a_m_m_socenlat_01", "a_m_m_soucent_01", "a_m_m_soucent_02", "a_m_m_soucent_03",
    "a_m_m_soucent_04", "a_m_m_stlat_02", "a_m_m_tennis_01", "a_m_m_tourist_01", "a_m_m_tramp_01", "a_m_m_trampbeac_01",
    "a_m_m_tranvest_01", "a_m_m_tranvest_02", "a_m_o_acult_01", "a_m_o_acult_02", "a_m_o_beach_01", "a_m_o_genstreet_01",
    "a_m_o_ktown_01", "a_m_o_salton_01", "a_m_o_soucent_01", "a_m_o_soucent_02", "a_m_o_soucent_03", "a_m_o_tramp_01",
    "a_m_y_acult_01", "a_m_y_acult_02", "a_m_y_beach_01", "a_m_y_beach_02", "a_m_y_beach_03", "a_m_y_beachvesp_01",
    "a_m_y_beachvesp_02", "a_m_y_bevhills_01", "a_m_y_bevhills_02", "a_m_y_breakdance_01", "a_m_y_busicas_01",
    "a_m_y_business_01", "a_m_y_business_02", "a_m_y_business_03", "a_m_y_cyclist_01", "a_m_y_dhill_01",
    "a_m_y_downtown_01", "a_m_y_eastsa_01", "a_m_y_eastsa_02", "a_m_y_epsilon_01", "a_m_y_epsilon_02", "a_m_y_gay_01",
    "a_m_y_gay_02", "a_m_y_genstreet_01", "a_m_y_genstreet_02", "a_m_y_golfer_01", "a_m_y_hasjew_01", "a_m_y_hiker_01",
    "a_m_y_hippy_01", "a_m_y_hipster_01", "a_m_y_hipster_02", "a_m_y_hipster_03", "a_m_y_indian_01", "a_m_y_jetski_01",
    "a_m_y_juggalo_01", "a_m_y_ktown_01", "a_m_y_ktown_02", "a_m_y_latino_01", "a_m_y_methhead_01", "a_m_y_mexthug_01",
    "a_m_y_motox_01", "a_m_y_motox_02", "a_m_y_musclbeac_01", "a_m_y_musclbeac_02", "a_m_y_polynesian_01",
    "a_m_y_roadcyc_01", "a_m_y_runner_01", "a_m_y_runner_02", "a_m_y_salton_01", "a_m_y_skater_01", "a_m_y_skater_02",
    "a_m_y_soucent_01", "a_m_y_soucent_02", "a_m_y_soucent_03", "a_m_y_soucent_04", "a_m_y_stbla_01", "a_m_y_stbla_02",
    "a_m_y_stlat_01", "a_m_y_stwhi_01", "a_m_y_stwhi_02", "a_m_y_sunbathe_01", "a_m_y_surfer_01", "a_m_y_vindouche_01",
    "a_m_y_vinewood_01", "a_m_y_vinewood_02", "a_m_y_vinewood_03", "a_m_y_vinewood_04", "a_m_y_yoga_01",
    "cs_amandatownley", "cs_andreas", "cs_ashley", "cs_bankman", "cs_barry", "cs_beverly", "cs_brad", "cs_bradcadaver",
    "cs_carbuyer", "cs_casey", "cs_chengsr", "cs_chrisformage", "cs_clay", "cs_dale", "cs_davenorton", "cs_debra",
    "cs_denise", "cs_devin", "cs_dom", "cs_dreyfuss", "cs_drfriedlander", "cs_fabien", "cs_fbisuit_01", "cs_floyd",
    "cs_guadalope", "cs_gurk", "cs_hunter", "cs_janet", "cs_jewelass", "cs_jimmyboston", "cs_jimmydisanto",
    "cs_joeminuteman", "cs_johnnyklebitz", "cs_josef", "cs_josh", "cs_lamardavis", "cs_lazlow", "cs_lestercrest",
    "cs_lifeinvad_01", "cs_magenta", "cs_manuel", "cs_marnie", "cs_martinmadrazo", "cs_maryann", "cs_michelle",
    "cs_milton", "cs_molly", "cs_movpremf_01", "cs_movpremmale", "cs_mrk", "cs_mrs_thornhill", "cs_mrsphillips",
    "cs_natalia", "cs_nervousron", "cs_nigel", "cs_old_man1a", "cs_old_man2", "cs_omega", "cs_orleans", "cs_paper",
    "cs_patricia", "cs_priest", "cs_prolsec_02", "cs_russiandrunk", "cs_siemonyetarian", "cs_solomon", "cs_stevehains",
    "cs_stretch", "cs_tanisha", "cs_taocheng", "cs_taostranslator", "cs_tenniscoach", "cs_terry", "cs_tom",
    "cs_tomepsilon", "cs_tracydisanto", "cs_wade", "cs_zimbor", "csb_abigail", "csb_anita", "csb_anton", "csb_ballasog",
    "csb_bride", "csb_burgerdrug", "csb_car3guy1", "csb_car3guy2", "csb_chef", "csb_chin_goon", "csb_cletus", "csb_cop",
    "csb_customer", "csb_denise_friend", "csb_fos_rep", "csb_g", "csb_groom", "csb_grove_str_dlr", "csb_hao", "csb_hugh",
    "csb_imran", "csb_janitor", "csb_maude", "csb_mweather", "csb_ortega", "csb_oscar", "csb_porndudes",
    "csb_prologuedriver", "csb_prolsec", "csb_ramp_gang", "csb_ramp_hic", "csb_ramp_hipster", "csb_ramp_marine",
    "csb_ramp_mex", "csb_reporter", "csb_roccopelosi", "csb_screen_writer", "csb_stripper_01", "csb_stripper_02",
    "csb_tonya", "csb_trafficwarden", "csb_vagspeak", "g_f_importexport_01", "g_f_y_ballas_01", "g_f_y_families_01",
    "g_f_y_lost_01", "g_f_y_vagos_01", "g_m_importexport_01", "g_m_m_armboss_01", "g_m_m_armgoon_01", "g_m_m_armlieut_01",
    "g_m_m_chemwork_01", "g_m_m_chiboss_01", "g_m_m_chicold_01", "g_m_m_chigoon_01", "g_m_m_chigoon_02",
    "g_m_m_korboss_01", "g_m_m_mexboss_01", "g_m_m_mexboss_02", "g_m_y_armgoon_02", "g_m_y_azteca_01",
    "g_m_y_ballaeast_01", "g_m_y_ballaorig_01", "g_m_y_ballasout_01", "g_m_y_famca_01", "g_m_y_famdnf_01",
    "g_m_y_famfor_01", "g_m_y_korean_01", "g_m_y_korean_02", "g_m_y_korlieut_01", "g_m_y_lost_01", "g_m_y_lost_02",
    "g_m_y_lost_03", "g_m_y_mexgang_01", "g_m_y_mexgoon_01", "g_m_y_mexgoon_02", "g_m_y_mexgoon_03", "g_m_y_pologoon_01",
    "g_m_y_pologoon_02", "g_m_y_salvaboss_01", "g_m_y_salvagoon_01", "g_m_y_salvagoon_02", "g_m_y_salvagoon_03",
    "g_m_y_strpunk_01", "g_m_y_strpunk_02", "hc_driver", "hc_gunman", "hc_hacker", "ig_abigail", "ig_amandatownley",
    "ig_andreas", "ig_ashley", "ig_ballasog", "ig_bankman", "ig_barry", "ig_benny", "ig_bestmen", "ig_beverly", "ig_brad",
    "ig_bride", "ig_car3guy1", "ig_car3guy2", "ig_casey", "ig_chef", "ig_chengsr", "ig_chrisformage", "ig_clay",
    "ig_claypain", "ig_cletus", "ig_dale", "ig_davenorton", "ig_denise", "ig_devin", "ig_dom", "ig_dreyfuss",
    "ig_drfriedlander", "ig_fabien", "ig_fbisuit_01", "ig_floyd", "ig_g", "ig_groom", "ig_hao", "ig_hunter", "ig_janet",
    "ig_jay_norris", "ig_jewelass", "ig_jimmyboston", "ig_jimmydisanto", "ig_joeminuteman", "ig_johnnyklebitz",
    "ig_josef", "ig_josh", "ig_kerrymcintosh", "ig_lamardavis", "ig_lazlow", "ig_lestercrest", "ig_lifeinvad_01",
    "ig_lifeinvad_02", "ig_magenta", "ig_malc", "ig_manuel", "ig_marnie", "ig_maryann", "ig_maude", "ig_michelle",
    "ig_milton", "ig_molly", "ig_mrk", "ig_mrs_thornhill", "ig_mrsphillips", "ig_natalia", "ig_nervousron", "ig_nigel",
    "ig_old_man1a", "ig_old_man2", "ig_omega", "ig_oneil", "ig_orleans", "ig_ortega", "ig_paper", "ig_patricia",
    "ig_priest", "ig_prolsec_02", "ig_ramp_gang", "ig_ramp_hic", "ig_ramp_hipster", "ig_ramp_mex", "ig_roccopelosi",
    "ig_russiandrunk", "ig_screen_writer", "ig_siemonyetarian", "ig_solomon", "ig_stevehains", "ig_stretch", "ig_talina",
    "ig_tanisha", "ig_taocheng", "ig_taostranslator", "ig_tenniscoach", "ig_terry", "ig_tomepsilon", "ig_tonya",
    "ig_tracydisanto", "ig_trafficwarden", "ig_tylerdix", "ig_vagspeak", "ig_wade", "ig_zimbor", "mp_f_boatstaff_01",
    "mp_f_cardesign_01", "mp_f_chbar_01", "mp_f_cocaine_01", "mp_f_counterfeit_01", "mp_f_deadhooker", "mp_f_execpa_01",
    "mp_f_forgery_01", "mp_f_freemode_01", "mp_f_helistaff_01", "mp_f_meth_01", "mp_f_misty_01", "mp_f_stripperlite",
    "mp_f_weed_01", "mp_g_m_pros_01", "mp_headtargets", "mp_m_boatstaff_01", "mp_m_claude_01", "mp_m_cocaine_01",
    "mp_m_counterfeit_01", "mp_m_exarmy_01", "mp_m_execpa_01", "mp_m_famdd_01", "mp_m_fibsec_01", "mp_m_forgery_01",
    "mp_m_freemode_01", "mp_m_g_vagfun_01", "mp_m_marston_01", "mp_m_meth_01", "mp_m_niko_01", "mp_m_securoguard_01",
    "mp_m_shopkeep_01", "mp_m_waremech_01", "mp_m_weed_01", "mp_s_m_armoured_01", "player_one", "player_two",
    "player_zero", "s_f_m_fembarber", "s_f_m_maid_01", "s_f_m_shop_high", "s_f_m_sweatshop_01", "s_f_y_airhostess_01",
    "s_f_y_bartender_01", "s_f_y_baywatch_01", "s_f_y_cop_01", "s_f_y_factory_01", "s_f_y_hooker_01", "s_f_y_hooker_02",
    "s_f_y_hooker_03", "s_f_y_migrant_01", "s_f_y_movprem_01", "s_f_y_ranger_01", "s_f_y_scrubs_01", "s_f_y_sheriff_01",
    "s_f_y_shop_low", "s_f_y_shop_mid", "s_f_y_stripper_01", "s_f_y_stripper_02", "s_f_y_stripperlite",
    "s_f_y_sweatshop_01", "s_m_m_ammucountry", "s_m_m_armoured_01", "s_m_m_armoured_02", "s_m_m_autoshop_01",
    "s_m_m_autoshop_02", "s_m_m_bouncer_01", "s_m_m_chemsec_01", "s_m_m_ciasec_01", "s_m_m_cntrybar_01",
    "s_m_m_dockwork_01", "s_m_m_doctor_01", "s_m_m_fiboffice_01", "s_m_m_fiboffice_02", "s_m_m_gaffer_01",
    "s_m_m_gardener_01", "s_m_m_gentransport", "s_m_m_hairdress_01", "s_m_m_highsec_01", "s_m_m_highsec_02",
    "s_m_m_janitor", "s_m_m_lathandy_01", "s_m_m_lifeinvad_01", "s_m_m_linecook", "s_m_m_lsmetro_01", "s_m_m_mariachi_01",
    "s_m_m_marine_01", "s_m_m_marine_02", "s_m_m_migrant_01", "s_m_m_movalien_01", "s_m_m_movprem_01",
    "s_m_m_movspace_01", "s_m_m_paramedic_01", "s_m_m_pilot_01", "s_m_m_pilot_02", "s_m_m_postal_01", "s_m_m_postal_02",
    "s_m_m_prisguard_01", "s_m_m_scientist_01", "s_m_m_security_01", "s_m_m_snowcop_01", "s_m_m_strperf_01",
    "s_m_m_strpreach_01", "s_m_m_strvend_01", "s_m_m_trucker_01", "s_m_m_ups_01", "s_m_m_ups_02", "s_m_o_busker_01",
    "s_m_y_airworker", "s_m_y_ammucity_01", "s_m_y_armymech_01", "s_m_y_autopsy_01", "s_m_y_barman_01",
    "s_m_y_baywatch_01", "s_m_y_blackops_01", "s_m_y_blackops_02", "s_m_y_busboy_01", "s_m_y_chef_01", "s_m_y_clown_01",
    "s_m_y_construct_01", "s_m_y_construct_02", "s_m_y_cop_01", "s_m_y_dealer_01", "s_m_y_devinsec_01",
    "s_m_y_dockwork_01", "s_m_y_doorman_01", "s_m_y_dwservice_01", "s_m_y_dwservice_02", "s_m_y_factory_01",
    "s_m_y_fireman_01", "s_m_y_garbage", "s_m_y_grip_01", "s_m_y_hwaycop_01", "s_m_y_marine_01", "s_m_y_marine_02",
    "s_m_y_marine_03", "s_m_y_mime", "s_m_y_pestcont_01", "s_m_y_pilot_01", "s_m_y_prismuscl_01", "s_m_y_prisoner_01",
    "s_m_y_ranger_01", "s_m_y_robber_01", "s_m_y_sheriff_01", "s_m_y_shop_mask", "s_m_y_strvend_01", "s_m_y_swat_01",
    "s_m_y_uscg_01", "s_m_y_valet_01", "s_m_y_waiter_01", "s_m_y_winclean_01", "s_m_y_xmech_01", "s_m_y_xmech_02",
    "s_m_y_xmech_02_mp", "u_f_m_corpse_01", "u_f_m_miranda", "u_f_m_promourn_01", "u_f_o_moviestar", "u_f_o_prolhost_01",
    "u_f_y_bikerchic", "u_f_y_comjane", "u_f_y_corpse_01", "u_f_y_corpse_02", "u_f_y_hotposh_01", "u_f_y_jewelass_01",
    "u_f_y_mistress", "u_f_y_poppymich", "u_f_y_princess", "u_f_y_spyactress", "u_m_m_aldinapoli", "u_m_m_bankman",
    "u_m_m_bikehire_01", "u_m_m_fibarchitect", "u_m_m_filmdirector", "u_m_m_glenstank_01", "u_m_m_griff_01",
    "u_m_m_jesus_01", "u_m_m_jewelsec_01", "u_m_m_jewelthief", "u_m_m_markfost", "u_m_m_partytarget", "u_m_m_prolsec_01",
    "u_m_m_promourn_01", "u_m_m_rivalpap", "u_m_m_spyactor", "u_m_m_willyfist", "u_m_o_finguru_01", "u_m_o_taphillbilly",
    "u_m_o_tramp_01", "u_m_y_abner", "u_m_y_antonb", "u_m_y_babyd", "u_m_y_baygor", "u_m_y_burgerdrug_01", "u_m_y_chip",
    "u_m_y_cyclist_01", "u_m_y_fibmugger_01", "u_m_y_guido_01", "u_m_y_gunvend_01", "u_m_y_hippie_01", "u_m_y_imporage",
    "u_m_y_justin", "u_m_y_mani", "u_m_y_militarybum", "u_m_y_paparazzi", "u_m_y_party_01", "u_m_y_pogo_01",
    "u_m_y_prisoner_01", "u_m_y_proldriver_01", "u_m_y_rsranger_01", "u_m_y_sbike", "u_m_y_staggrm_01", "u_m_y_tattoo_01",
    "u_m_y_zombie_01"
}

RegisterNUICallback('updateperm', function(data, cb)
    Callbacks:ServerCallback('Admin:updateAdmin', data, cb)
end)

RegisterNUICallback('updateperm:choices:permType', function(data, cb)
    local permTypes = {
        "Developer",
        "Owner",
        "Admin",
        "Staff",
        "Mod",
        "Support",
        "Whitelisted"
    }
    cb(permTypes)
end)

RegisterNUICallback('god', function(data, cb)
    Callbacks:ServerCallback('Admin:ToggleGod', data, cb)
end)

RegisterNUICallback('GetPlayerPermission', function(data, cb)
    Callbacks:ServerCallback('Admin:GetPlayerPermission', data, cb)
end)

RegisterNUICallback('die', function(data, cb)
    Callbacks:ServerCallback('Admin:Die', data, cb)
end)

RegisterNetEvent("SetPlayerHealthToZero", function()
    local playerPed = PlayerPedId()
    SetEntityHealth(playerPed, 0)
end)


RegisterNUICallback('addcash', function(data, cb)
    Callbacks:ServerCallback('Admin:AddCash', data, cb)
end)

RegisterNUICallback('addstate', function(data, cb)
    Callbacks:ServerCallback('Admin:AddState', data, cb)
end)

RegisterNUICallback('zsetped', function(data, cb)
    Callbacks:ServerCallback('Admin:SetPed', data, cb)
end)

RegisterNUICallback('zsetped:choices:ped', function(data, cb)
    cb(Config.Models)
end)

-- Item Commands
RegisterNUICallback('giveweapon:choices:weaponName', function(data, cb)
    local items = exports["mythic-inventory"]:GetItemNamesAndLabels() or {}
    local filteredItems = {}
    for _, itemName in ipairs(items) do
        local upperName = string.upper(itemName)
        if string.match(upperName, "^WEAPON_") then
            table.insert(filteredItems, itemName)
        end
    end
    cb(filteredItems)
end)

RegisterNUICallback('giveitem:choices:itemName', function(data, cb)
    local items = exports["mythic-inventory"]:GetItemNamesAndLabels() or {}
    local filteredItems = {}
    for _, itemName in ipairs(items) do
        local upperName = string.upper(itemName)
        if not string.match(upperName, "^WEAPON_") then
            table.insert(filteredItems, itemName)
        end
    end
    cb(filteredItems)
end)

RegisterNUICallback('giveitem', function(data, cb)
    Callbacks:ServerCallback('Admin:GiveItem', data, cb)
end)

RegisterNUICallback('giveweapon', function(data, cb)
    Callbacks:ServerCallback('Admin:GiveWeapon', data, cb)
end)

RegisterNUICallback('openinventory', function(data, cb)
    Callbacks:ServerCallback('Admin:OpenInventory', data, cb)
end)

RegisterNUICallback('openstash', function(data, cb)
    Callbacks:ServerCallback('Admin:OpenStash', data, cb)
end)

RegisterNUICallback('opentrunk', function(data, cb)
    Callbacks:ServerCallback('Admin:OpenTrunk', data, cb)
end)

RegisterNUICallback('clearinventory', function(data, cb)
    Callbacks:ServerCallback('Admin:ClearInventory', data, cb)
end)

RegisterNUICallback('clearinventory2', function(data, cb)
    Callbacks:ServerCallback('Admin:ClearInventory2', data, cb)
end)

-- Heist Commands
RegisterNUICallback('resetheist', function(data, cb)
    Callbacks:ServerCallback('Admin:ResetHeist', data, cb)
end)

RegisterNUICallback('disablepower', function(data, cb)
    Callbacks:ServerCallback('Admin:DisablePower', data, cb)
end)

RegisterNUICallback('checkheist', function(data, cb)
    Callbacks:ServerCallback('Admin:CheckHeist', data, cb)
end)

-- Job Commands
RegisterNUICallback('givejob', function(data, cb)
    Callbacks:ServerCallback('Admin:GiveJob', data, cb)
end)

RegisterNUICallback('removejob', function(data, cb)
    Callbacks:ServerCallback('Admin:RemoveJob', data, cb)
end)

RegisterNUICallback('setowner', function(data, cb)
    Callbacks:ServerCallback('Admin:SetOwner', data, cb)
end)

-- Storage Unit Commands
RegisterNUICallback('unitadd', function(data, cb)
    Callbacks:ServerCallback('Admin:UnitAdd', data, cb)
end)

RegisterNUICallback('unitcopy', function(data, cb)
    Callbacks:ServerCallback('Admin:UnitCopy', data, cb)
end)

RegisterNUICallback('unitdelete', function(data, cb)
    Callbacks:ServerCallback('Admin:UnitDelete', data, cb)
end)

RegisterNUICallback('unitown', function(data, cb)
    Callbacks:ServerCallback('Admin:UnitOwn', data, cb)
end)

-- MDT Commands
RegisterNUICallback('setcallsign', function(data, cb)
    Callbacks:ServerCallback('Admin:SetCallsign', data, cb)
end)

RegisterNUICallback('reclaimcallsign', function(data, cb)
    Callbacks:ServerCallback('Admin:ReclaimCallsign', data, cb)
end)

RegisterNUICallback('addmdtsysadmin', function(data, cb)
    Callbacks:ServerCallback('Admin:AddMDTSysAdmin', data, cb)
end)

RegisterNUICallback('removemdtsysadmin', function(data, cb)
    Callbacks:ServerCallback('Admin:RemoveMDTSysAdmin', data, cb)
end)

-- Message Commands
RegisterNUICallback('server', function(data, cb)
    Callbacks:ServerCallback('Admin:ServerMessage', data, cb)
end)

RegisterNUICallback('system', function(data, cb)
    Callbacks:ServerCallback('Admin:SystemMessage', data, cb)
end)

RegisterNUICallback('broadcast', function(data, cb)
    Callbacks:ServerCallback('Admin:Broadcast', data, cb)
end)

RegisterNUICallback('email', function(data, cb)
    Callbacks:ServerCallback('Admin:SendEmail', data, cb)
end)

-- App Permission Commands
RegisterNUICallback('phoneperm', function(data, cb)
    Callbacks:ServerCallback('Admin:PhonePerm', data, cb)
end)

RegisterNUICallback('laptopperm', function(data, cb)
    Callbacks:ServerCallback('Admin:LaptopPerm', data, cb)
end)

RegisterNUICallback('bizwizset', function(data, cb)
    Callbacks:ServerCallback('Admin:BizWizSet', data, cb)
end)

RegisterNUICallback('bizwizlogo', function(data, cb)
    Callbacks:ServerCallback('Admin:BizWizLogo', data, cb)
end)

RegisterNUICallback('clearalias', function(data, cb)
    Callbacks:ServerCallback('Admin:ClearAlias', data, cb)
end)

RegisterNUICallback('setenvironment', function(data, cb)
    Callbacks:ServerCallback('Admin:SetEnvironment', data, cb)
end)

RegisterNUICallback('setenvironment:choices:type', function(data, cb)
    local AvailableWeatherTypes = {
        "EXTRASUNNY",
        "CLEAR",
        "SMOG",
        "FOGGY",
        "OVERCAST",
        "CLOUDS",
        "CLEARING",
        "RAIN",
        "THUNDER",
        -- Non Regular Weather Types
        "NEUTRAL",
        "HALLOWEEN",
        "SNOW",
        "BLIZZARD",
        "SNOWLIGHT",
        "XMAS"
    }
    cb(AvailableWeatherTypes)
end)

RegisterNUICallback('setenvironment:choices:time', function(data, cb)
    local timesss = {
        "MORNING",
        "NOON",
        "EVENING",
        "NIGHT"
    }
    cb(timesss)
end)

-- Dealership Commands
RegisterNUICallback('setstock', function(data, cb)
    Callbacks:ServerCallback('Admin:SetStock', data, cb)
end)

RegisterNUICallback('incstock', function(data, cb)
    Callbacks:ServerCallback('Admin:IncStock', data, cb)
end)

RegisterNUICallback('setstockprice', function(data, cb)
    Callbacks:ServerCallback('Admin:SetStockPrice', data, cb)
end)

RegisterNUICallback('setstockname', function(data, cb)
    Callbacks:ServerCallback('Admin:SetStockName', data, cb)
end)

-- RegisterNUICallback('setstockclass', function(data, cb)
--     Callbacks:ServerCallback('Admin:SetStockClass', data, cb)
-- end)

-- Reputation Commands
RegisterNUICallback('addrep', function(data, cb)
    Callbacks:ServerCallback('Admin:AddRep', data, cb)
end)

RegisterNUICallback('remrep', function(data, cb)
    Callbacks:ServerCallback('Admin:RemRep', data, cb)
end)

-- Misc Commands
RegisterNUICallback('screenshot', function(data, cb)
    Callbacks:ServerCallback('Admin:Screenshot', data, cb)
end)

RegisterNUICallback('wardrobe', function(data, cb)
    print(json.encode(data))
    Callbacks:ServerCallback('Admin:Wardrobe', data, cb)
end)

RegisterNUICallback('wardrobe:choices:wardrobeType', function(data, cb)
    local wardrobeChoices = {
        'barber',
        'clothing',
        'tattoo',
        'surgery'
    }
    cb(wardrobeChoices)
end)

RegisterNUICallback('checkheist:choices:heistId', function(data, cb)
    Callbacks:ServerCallback('Admin:GetBanks', data, cb)
end)

RegisterNUICallback('setstock:choices:dealershipId', function(data, cb)
    local dealershipId = {
        'pdm',
        'tuna',
        'redline'
    }
    cb(dealershipId)
end)

RegisterNUICallback('incstock:choices:dealershipId', function(data, cb)
    local dealershipId = {
        'pdm',
        'tuna',
        'redline'
    }
    cb(dealershipId)
end)

RegisterNUICallback('setstockprice:choices:dealershipId', function(data, cb)
    local dealershipId = {
        'pdm',
        'tuna',
        'redline'
    }
    cb(dealershipId)
end)

RegisterNUICallback('setstockname:choices:dealershipId', function(data, cb)
    local dealershipId = {
        'pdm',
        'tuna',
        'redline'
    }
    cb(dealershipId)
end)

RegisterNUICallback('addcrypto:choices:coin', function(data, cb)
    local coins = {
        'VRM',
        'PLEB',
        'HEIST'
    }
    cb(coins)
end)

RegisterNUICallback('disablepower:choices:heistId', function(data, cb)
    local heistId = {
        'mazebank',
        'lombank',
        'paleto'
    }
    cb(heistId)
end)

RegisterNUICallback('resetheist:choices:heistId', function(data, cb)
    Callbacks:ServerCallback('Admin:GetBanks', data, cb)
end)

RegisterNUICallback('givejob:choices:jobId', function(data, cb)
    Callbacks:ServerCallback('Admin:jobs', data, cb)
end)

RegisterNUICallback('givejob:choicesWithPARAM:workplaceId', function(data, cb)
    Callbacks:ServerCallback('Admin:getWorkplaceforjob', data, cb)
end)

RegisterNUICallback('givejob:choicesWithPARAM:gradeId', function(data, cb)
    Callbacks:ServerCallback('Admin:getGradesforjob', data, cb)
end)

RegisterNUICallback('setowner:choices:jobId', function(data, cb)
    Callbacks:ServerCallback('Admin:jobs', data, cb)
end)

RegisterNUICallback('unitadd:choices:managingBusiness', function(data, cb)
    Callbacks:ServerCallback('Admin:companies', data, cb)
end)

RegisterNUICallback('togglerobbery', function(data, cb)
    Callbacks:ServerCallback('Admin:ToggleRobbery', data, cb)
end)

RegisterNUICallback('checkshitlord', function(data, cb)
    Callbacks:ServerCallback('Admin:CheckShitlord', data, cb)
end)

RegisterNUICallback('resetshitlord', function(data, cb)
    Callbacks:ServerCallback('Admin:ResetShitlord', data, cb)
end)

RegisterNUICallback('setbillboard', function(data, cb)
    Callbacks:ServerCallback('Admin:SetBillboard', data, cb)
end)

RegisterNUICallback('addcrypto', function(data, cb)
    Callbacks:ServerCallback('Admin:AddCrypto', data, cb)
end)

-- RegisterNUICallback('clearbeds', function(data, cb)
--     Callbacks:ServerCallback('Admin:ClearBeds', data, cb)
-- end)

-- RegisterNUICallback('addoxyrun', function(data, cb)
--     Callbacks:ServerCallback('Admin:AddOxyRun', data, cb)
-- end)

-- RegisterNUICallback('boostingevent', function(data, cb)
--     Callbacks:ServerCallback('Admin:BoostingEvent', data, cb)
-- end)

RegisterNUICallback('removestress', function(data, cb)
    Callbacks:ServerCallback('Admin:removestress', data, cb)
end)

RegisterNUICallback('storebank', function(data, cb)
    Callbacks:ServerCallback('Admin:StoreBank', data, cb)
end)

RegisterNUICallback('disablelockdown', function(data, cb)
    Callbacks:ServerCallback('Admin:DisableLockdown', data, cb)
end)

-- Client Event Handlers
RegisterNetEvent('Admin:Client:Invisible')
AddEventHandler('Admin:Client:Invisible', function()
    isInvisible = not isInvisible
    SetEntityVisible(PlayerPedId(), not isInvisible, 0)
end)

-- GodMode Fix
local notfiysend = false
CreateThread(function()
    while true do
        if LocalPlayer.state.isGodmode then
            SetEntityInvincible(PlayerPedId(), true)
            SetEntityProofs(PlayerPedId(), true, true, true, true, true, true, true, true)
            ResetPedVisibleDamage(PlayerPedId())
            ClearPedBloodDamage(PlayerPedId())
            if not notfiysend then
                notfiysend = not notfiysend
                print("God Mode Enabled", LocalPlayer.state.isGodmode)
            end
        else
            if notfiysend then
                notfiysend = not notfiysend
                print("God Mode Enabled", LocalPlayer.state.isGodmode)
            end
            SetEntityInvincible(PlayerPedId(), false)
            SetEntityProofs(PlayerPedId(), false, false, false, false, false, false, false, false)
        end
        Wait(10)
    end
end)

RegisterNetEvent('Admin:ReceiveItems', function(items)
    SendNUIMessage({
        type = 'updateItems',
        items = items
    })
end)

RegisterNetEvent('Admin:Client:ChangePed')
AddEventHandler('Admin:Client:ChangePed', function(model)
    if not model then return end
    
    local hash = GetHashKey(model)
    if not IsModelValid(hash) then
        TriggerEvent('Notification:New', 'error', 'Invalid model')
        return
    end
    
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(1)
    end
    
    SetPlayerModel(PlayerId(), hash)
    SetPedDefaultComponentVariation(PlayerPedId())
    SetModelAsNoLongerNeeded(hash)
end)

local fromList = {
    barber = true,
    clothing = true,
    tattoo = true,
    surgery = true
}

RegisterNetEvent("Admin:Wardrobe:Reciver", function(wardrobeType)
    CloseMenu()
    print(wardrobeTypem, not fromList[wardrobeType])
    if not fromList[wardrobeType] then return end

    if LocalPlayer and LocalPlayer.state and LocalPlayer.state.loggedIn then
        local shopType = wardrobeType == 'clothing' and 'SHOP' or string.upper(wardrobeType)

        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)

        Ped.Customization:Show(shopType, {
            x = coords.x,
            y = coords.y,
            z = coords.z,
            h = 326.637,
        })
    end
end)


RegisterNUICallback('AdminLogSaver', function(data, cb)
    cb(true)
    local event = data.command
    local params = data.params or {}
    if event then
        TriggerServerEvent('Admin:AdminLogSaver', event, params)
    end
end)


local adminList = {}

RegisterNetEvent("updateAdminList")
AddEventHandler("updateAdminList", function(admins)
    adminList = admins
end)
local test = true
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if _IsAdmin and test then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            for serverId, info in pairs(adminList) do
                local targetPlayer = GetPlayerFromServerId(tonumber(serverId))
                local targetPed = GetPlayerPed(targetPlayer)

                if targetPed ~= 0 and targetPlayer ~= -1 then
                    local targetCoords = GetEntityCoords(targetPed)
                    local distance = #(playerCoords - targetCoords)

                    if distance < 20.0 then
                        DrawText3D(targetCoords.x, targetCoords.y, targetCoords.z + 1.2, info.name .. " - " .. info.staffGroup)
                    end
                end
            end
        end
    end
end)

RegisterNUICallback('getCurrentPedModel', function(data, cb)
    cb(GetEntityModel(PlayerPedId()))
end)

RegisterCommand("DisableDevView", function(source, args, rawCommand)
    test = not test
end, false)

-- Function to draw 3D text
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 0, 0, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end
