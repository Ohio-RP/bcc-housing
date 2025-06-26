-- Script de migração simplificado e mais robusto
RegisterCommand('migratehouses', function(source, args)
    local _source = source
    
    -- Só permitir do console do servidor
    if _source > 0 then
        print("This command can only be run from the server console")
        return
    end
    
    print("^3[BCC-Housing Migration]^7 Starting house migration from config file to database...")
    
    -- Tentar carregar o arquivo houses.lua original
    local housesFile = LoadResourceFile(GetCurrentResourceName(), 'configs/houses.lua')
    if not housesFile then
        print("^1[BCC-Housing Migration]^7 Could not find configs/houses.lua!")
        return
    end
    
    -- Salvar o Houses atual (se existir)
    local oldHouses = Houses
    
    -- Executar o arquivo houses.lua
    local executeSuccess, executeError = pcall(function()
        assert(load(housesFile))()
    end)
    
    if not executeSuccess then
        print("^1[BCC-Housing Migration]^7 Error loading houses.lua: " .. tostring(executeError))
        Houses = oldHouses -- Restaurar Houses anterior
        return
    end
    
    -- Verificar se Houses foi carregado
    if not Houses or type(Houses) ~= "table" or #Houses == 0 then
        print("^1[BCC-Housing Migration]^7 No houses found in config file!")
        Houses = oldHouses -- Restaurar Houses anterior
        return
    end
    
    print("^2[BCC-Housing Migration]^7 Found " .. #Houses .. " houses to migrate")
    
    local migratedCount = 0
    local skippedCount = 0
    local errorCount = 0
    
    -- Migrar cada casa
    for i, house in ipairs(Houses) do
        if not house.uniqueName then
            print("^1[BCC-Housing Migration]^7 House #" .. i .. " missing uniqueName, skipping...")
            errorCount = errorCount + 1
        else
            -- Verificar se já existe
            local existing = MySQL.query.await("SELECT id FROM bcchousing_config WHERE unique_name = ?", {house.uniqueName})
            
            if existing and #existing > 0 then
                print("^3[BCC-Housing Migration]^7 House '" .. house.uniqueName .. "' already exists, skipping...")
                skippedCount = skippedCount + 1
            else
                -- Preparar dados da casa
                local houseCoords = house.houseCoords or vector3(0,0,0)
                local menuCoords = house.menuCoords or house.houseCoords or vector3(0,0,0)
                
                -- Inserir casa
                local success, error = pcall(function()
                    local houseId = MySQL.insert.await([[
                        INSERT INTO bcchousing_config (
                            unique_name, name, coords_x, coords_y, coords_z, radius_limit, 
                            inv_limit, tax_amount, player_max, tp_int, tp_instance,
                            menu_coords_x, menu_coords_y, menu_coords_z, menu_radius,
                            price, sell_price, rental_deposit, rent_charge,
                            can_sell, can_buy, can_rent,
                            blip_owned_active, blip_owned_name, blip_owned_sprite, blip_owned_color,
                            blip_forsale_active, blip_forsale_name, blip_forsale_sprite, blip_forsale_color
                        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                    ]], {
                        house.uniqueName,
                        house.name or "House",
                        houseCoords.x,
                        houseCoords.y,
                        houseCoords.z,
                        house.houseRadiusLimit or 20,
                        house.invLimit or 1000,
                        house.taxAmount or 0,
                        house.playerMax or 3,
                        house.tpInt or 0,
                        house.tpInstance or 0,
                        menuCoords.x,
                        menuCoords.y,
                        menuCoords.z,
                        house.menuRadius or 2.0,
                        house.price or 0,
                        house.sellPrice or 0,
                        house.rentalDeposit or 0,
                        house.rentCharge or 0,
                        (house.canSell ~= false) and 1 or 0,
                        (house.canBuy ~= false) and 1 or 0,
                        house.canRent and 1 or 0,
                        (not house.blip or not house.blip.owned or house.blip.owned.active ~= false) and 1 or 0,
                        (house.blip and house.blip.owned and house.blip.owned.name) or "My House",
                        (house.blip and house.blip.owned and house.blip.owned.sprite) or "blip_ambient_delivery",
                        (house.blip and house.blip.owned and house.blip.owned.color) or "BLIP_MODIFIER_MP_COLOR_21",
                        (not house.blip or not house.blip.forSale or house.blip.forSale.active ~= false) and 1 or 0,
                        (house.blip and house.blip.forSale and house.blip.forSale.name) or "House for Sale",
                        (house.blip and house.blip.forSale and house.blip.forSale.sprite) or "blip_ambient_delivery",
                        (house.blip and house.blip.forSale and house.blip.forSale.color) or "BLIP_MODIFIER_MP_COLOR_16"
                    })
                    
                    -- Inserir portas se houver
                    if house.doors and type(house.doors) == "table" and #house.doors > 0 then
                        for _, door in ipairs(house.doors) do
                            if door.doorinfo then
                                MySQL.insert.await([[
                                    INSERT INTO bcchousing_config_doors (house_config_id, doorinfo, locked)
                                    VALUES (?, ?, ?)
                                ]], {
                                    houseId, 
                                    door.doorinfo, 
                                    (door.locked ~= false) and 1 or 0
                                })
                            end
                        end
                    end
                    
                    print("^2[BCC-Housing Migration]^7 Successfully migrated: " .. house.uniqueName)
                    migratedCount = migratedCount + 1
                end)
                
                if not success then
                    print("^1[BCC-Housing Migration]^7 Error migrating '" .. house.uniqueName .. "': " .. tostring(error))
                    errorCount = errorCount + 1
                end
            end
        end
    end
    
    -- Restaurar Houses original ou recarregar do banco
    Houses = oldHouses or {}
    
    -- Sumário
    print("")
    print("^2[BCC-Housing Migration]^7 =====================================")
    print("^2[BCC-Housing Migration]^7 Migration Complete!")
    print("^2[BCC-Housing Migration]^7 Successfully migrated: " .. migratedCount .. " houses")
    print("^3[BCC-Housing Migration]^7 Skipped (already exist): " .. skippedCount .. " houses")
    if errorCount > 0 then
        print("^1[BCC-Housing Migration]^7 Errors: " .. errorCount .. " houses")
    end
    print("^2[BCC-Housing Migration]^7 =====================================")
    print("")
    print("^3[BCC-Housing Migration]^7 IMPORTANT NEXT STEPS:")
    print("^3[BCC-Housing Migration]^7 1. Restart the resource to load houses from database")
    print("^3[BCC-Housing Migration]^7 2. Rename configs/houses.lua to configs/houses.lua.backup")
    print("^3[BCC-Housing Migration]^7 3. The system will now use the database for all houses")
    
    -- Fazer backup automático se a migração foi bem-sucedida
    if migratedCount > 0 then
        print("")
        print("^3[BCC-Housing Migration]^7 Creating automatic backup...")
        
        local housesFile = LoadResourceFile(GetCurrentResourceName(), 'configs/houses.lua')
        if housesFile then
            local timestamp = os.date("%Y%m%d_%H%M%S")
            local backupName = 'configs/houses_backup_migration_' .. timestamp .. '.lua'
            
            SaveResourceFile(GetCurrentResourceName(), backupName, housesFile, -1)
            
            -- Criar arquivo vazio
            local emptyHouses = [[-- Este arquivo foi migrado para o banco de dados
-- As casas agora são carregadas de bcchousing_config
-- Backup original salvo como: ]] .. backupName .. [[
-- Migração realizada em: ]] .. os.date("%Y-%m-%d %H:%M:%S") .. [[
-- Casas migradas: ]] .. migratedCount .. [[

-- NÃO ADICIONE CASAS AQUI! Use o comando /addhouse in-game
Houses = {}
]]
            
            SaveResourceFile(GetCurrentResourceName(), 'configs/houses.lua', emptyHouses, -1)
            
            print("^2[BCC-Housing Migration]^7 Backup created: " .. backupName)
            print("^2[BCC-Housing Migration]^7 Original houses.lua has been replaced")
            print("^2[BCC-Housing Migration]^7 Please restart the resource now!")
        end
    end
    
end, true)