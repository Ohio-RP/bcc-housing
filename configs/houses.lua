Houses = {
    -----------------------------------------------------
    -- Near Strawberry and Owanjila
    -----------------------------------------------------
    {
        uniqueName = "house0",                            -- Unique identifier for the house. You can use any name but make sure you don't use duplicates
        houseCoords = vector3(-2175.21, -251.55, 192.82), -- Coordinates of the house
        houseRadiusLimit = 20,                            -- Radius limit for the house
        doors = {
            -- Make sure you add the exact door from doorhashes.lua (you can find that in bcc-doorlocks in the client folder)
            -- Do not copy the entire line from doorhashes
            -- Example if we have this line
            -- [1610014965] = {1610014965,990179346,"p_door_val_bank02",-2371.8505859375,475.1383972168,131.25},
            -- We need to copy only what's between {...}
            -- 1610014965,990179346,"p_door_val_bank02",-2371.8505859375,475.1383972168,131.25
            {
                doorinfo = '[3978905847,-1896437095,"p_doorsgl02x",-2175.6965332031,-248.17004394531,191.82453918457]', locked = true
            },
            -- If the house has more than one door, copy the above same as these below
            -- {
            --     doorinfo = '[1610014965,990179346,"p_door_val_bank02",-2371.8505859375,475.1383972168,131.25]', locked = true
            -- },
        },
        invLimit = 1000,                                 -- Inventory limit for the house
        taxAmount = 380,                                 -- Tax amount for the house
        playerMax = 3,                                   -- Maximum number of players that can own the house
        tpInt = 0,                                       -- TP Interior ID
        tpInstance = 0,                                  -- TP Instance ID
        menuCoords = vector3(-2180.92, -239.25, 191.85), -- House Info (to buy or rent) / Marker location
        menuRadius = 2.0,                                -- Radius for the menu
        price = 3800,                                    -- The price of the house
        sellPrice = 1900,                                -- Amount received when selling the house
        rentalDeposit = 15,                              -- First Rental deposit in gold bars
        rentCharge = 7.5,                                -- Monthly rent in gold bars
        name = "House",                                  -- Name of the house for display
        canSell = true,                                  -- Whether the player can sell the house later
        showmarker = true,                               -- Show marker on the ground for house sale info
        blip = {
            sale = {
                active = true,                -- Show blip for houses for sale
                name = "House",               -- Name of the sale blip on the map
                sprite = 'blip_robbery_home', -- Set sprite of the sale blip
                color = 'WHITE',              -- Set color of the sale blip (see BlipColors in main.lua config)
            },
            owned = {
                active = true,           -- Show blip for owned houses
                name = "Your House",     -- Name of the owned blip on the map
                sprite = 'blip_mp_base', -- Set sprite of the owned blip
                color = 'WHITE',         -- Set color of the owned blip (see BlipColors in main.lua config)
            }
        }
    },

    -----------------------------------------------------
    -- Ranch in the Great Plains
    -----------------------------------------------------
    {
        uniqueName = "house1", -- Unique identifier for the house. You can use any name but make sure you don't use duplicates
        houseCoords = vector3(-2568.88, 348.03, 151.45),
        houseRadiusLimit = 30,
        doors = {
            -- Make sure you add the exact door from doorhashes.lua (you can find that in bcc-doorlocks in the client folder)
            -- Do not copy the entire line from doorhashes
            -- Example if we have this line
            -- [1610014965] = {1610014965,990179346,"p_door_val_bank02",-2371.8505859375,475.1383972168,131.25},
            -- We need to copy only what's between {...}
            -- 1610014965,990179346,"p_door_val_bank02",-2371.8505859375,475.1383972168,131.25
            {
                doorinfo = '[1535511805,-542955242,"p_door04x",-2590.8410644531,-248.17004394531,146.01396179199]', locked = true
            },
            {
                doorinfo = '[3443681973,-1899748000,"p_door45x",-2587.4055175781,407.56143188477,148.00889537402]', locked = true
            },
            {
                doorinfo = '[750242038,-1751819926,"p_gate_cattle01b",-2583.8364257813,413.82153320313,147.99279785156]', locked = true
            },
            {
                doorinfo = '[3074780964,-1335979469,"p_door_prong_mans01x",-2570.5344238281,352.88461303711,150.5400390625]', locked = true
            },
            -- If the house has more than one door, copy the above same as these below
            -- {
            --     doorinfo = '[1610014965,990179346,"p_door_val_bank02",-2371.8505859375,475.1383972168,131.25]', locked = true
            -- },
        },
        invLimit = 5000,                               -- Inventory limit for the house
        taxAmount = 2000,                              -- Tax amount for the house
        playerMax = 10,                                -- Maximum number of players that can own the house
        tpInt = 0,                                     -- TP Interior ID
        tpInstance = 0,                                -- TP Instance ID
        menuCoords = vector3(-2555.92, 474.91, 143.5), -- House Info (to buy or rent) / Marker location
        menuRadius = 2.0,                              -- Radius for the menu
        price = 20000,                                 -- The price of the house
        sellPrice = 10000,                             -- Amount received when selling the house
        rentalDeposit = 50,                            -- First Rental deposit in gold bars
        rentCharge = 25,                               -- Monthly rent in gold bars
        name = "Ranch",                                -- Name of the house for display
        canSell = true,                                -- Whether the player can sell the house later
        showmarker = true,                             -- Show marker on the ground for house sale info
        blip = {
            sale = {
                active = true,                         -- Show blip for houses for sale
                name = "Ranch",                        -- Name of the sale blip on the map
                sprite = 'blip_mp_playlist_adversary', -- Set sprite of the sale blip
                color = 'WHITE',                       -- Set color of the sale blip (see BlipColors in main.lua config)
            },
            owned = {
                active = true,           -- Show blip for owned houses
                name = "Your Ranch",     -- Name of the owned blip on the map
                sprite = 'blip_mp_base', -- Set sprite of the owned blip
                color = 'WHITE',         -- Set color of the owned blip (see BlipColors in main.lua config)
            }
        }
    },

   
}
