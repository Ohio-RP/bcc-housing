-- Tabela global para armazenar as casas carregadas do banco
Houses = {}
-- Flag para indicar se as casas foram carregadas do banco
local HousesLoadedFromDB = false

-- Função para carregar as casas do banco de dados
function LoadHousesFromDatabase()
    -- Aguardar o banco de dados ser atualizado
    while not DbUpdated do
        Wait(100)
    end

    -- Buscar todas as casas configuradas no banco
    local houses = MySQL.query.await("SELECT * FROM bcchousing_config ORDER BY id")
    
    if houses and #houses > 0 then
        -- Limpar a tabela Houses apenas se vamos carregar do banco
        Houses = {}
        
        for _, house in ipairs(houses) do
            -- Buscar as portas desta casa
            local doors = MySQL.query.await("SELECT * FROM bcchousing_config_doors WHERE house_config_id = ?", {house.id})
            
            local doorData = {}
            if doors and #doors > 0 then
                for _, door in ipairs(doors) do
                    table.insert(doorData, {
                        doorinfo = door.doorinfo,
                        locked = door.locked == 1
                    })
                end
            end
            
            -- Montar a estrutura da casa
            local houseConfig = {
                uniqueName = house.unique_name,
                name = house.name,
                houseCoords = vector3(house.coords_x, house.coords_y, house.coords_z),
                houseRadiusLimit = house.radius_limit,
                doors = doorData,
                invLimit = house.inv_limit,
                taxAmount = house.tax_amount,
                playerMax = house.player_max,
                tpInt = house.tp_int,
                tpInstance = house.tp_instance,
                menuCoords = vector3(house.menu_coords_x, house.menu_coords_y, house.menu_coords_z),
                menuRadius = house.menu_radius,
                price = house.price,
                sellPrice = house.sell_price,
                rentalDeposit = house.rental_deposit,
                rentCharge = house.rent_charge,
                canSell = house.can_sell == 1,
                canBuy = house.can_buy == 1,
                canRent = house.can_rent == 1,
                blip = {
                    owned = {
                        active = house.blip_owned_active == 1,
                        name = house.blip_owned_name,
                        sprite = house.blip_owned_sprite,
                        color = house.blip_owned_color
                    },
                    forSale = {
                        active = house.blip_forsale_active == 1,
                        name = house.blip_forsale_name,
                        sprite = house.blip_forsale_sprite,
                        color = house.blip_forsale_color
                    }
                }
            }
            
            table.insert(Houses, houseConfig)
        end
        
        HousesLoadedFromDB = true
        print("^2[BCC-Housing]^7 Loaded ^3" .. #Houses .. "^7 houses from database")
    else
        -- Se não há casas no banco, verificar se há casas do arquivo de config
        if Houses and #Houses > 0 then
            print("^3[BCC-Housing]^7 No houses in database. Using " .. #Houses .. " houses from config file.")
            print("^3[BCC-Housing]^7 Run 'migratehouses' in console to migrate them to database.")
        else
            print("^3[BCC-Housing]^7 No houses found. Add houses using /addhouse command.")
        end
    end
end

-- Carregar as casas quando o resource iniciar
CreateThread(function()
    -- Aguardar um pouco para garantir que tudo esteja carregado
    Wait(1000)
    -- Verificar se devemos carregar do banco
    local checkDB = MySQL.query.await("SELECT COUNT(*) as count FROM bcchousing_config")
    if checkDB and checkDB[1] and checkDB[1].count > 0 then
        -- Há casas no banco, carregar do banco
        LoadHousesFromDatabase()
    else
        -- Não há casas no banco, manter as do arquivo (se houver)
        if Houses and #Houses > 0 then
            print("^3[BCC-Housing]^7 Using houses from config file. Run 'migratehouses' to migrate to database.")
        end
    end
end)

-- Comando admin para adicionar uma nova casa
RegisterCommand('addhouse', function(source, args)
    local _source = source
    
    -- Verificar se é admin
    if _source > 0 then
        local User = VORPcore.getUser(_source)
        if not User then return end
        
        local group = User.getGroup
        local jobGrade = User.getUsedCharacter and User.getUsedCharacter.jobGrade or 0
        
        local isAllowed = false
        if group == Config.adminGroup then
            isAllowed = true
        else
            for _, job in pairs(Config.ALlowedJobs) do
                if job.jobname == User.getUsedCharacter.job and jobGrade >= (job.jobgrade or 0) then
                    isAllowed = true
                    break
                end
            end
        end
        
        if not isAllowed then
            VORPcore.NotifyRightTip(_source, "You don't have permission to use this command", 4000)
            return
        end
    end
    
    -- Trigger do menu de criação de casa
    if _source > 0 then
        TriggerClientEvent('bcc-housing:openAddHouseMenu', _source)
    else
        print("This command must be used in-game")
    end
end, false)

-- Evento para salvar uma nova casa no banco
RegisterServerEvent('bcc-housing:saveNewHouseConfig')
AddEventHandler('bcc-housing:saveNewHouseConfig', function(houseData)
    local _source = source
    
    -- Função para gerar um uniqueName único
    local function generateUniqueName(displayName)
        local cleanName = displayName:gsub("%s+", "_"):gsub("[^%w_]", ""):lower()
        if cleanName == "" then cleanName = "house" end
        local hash = os.time() % 1000
        local hashStr = tostring(hash)
        if #hashStr == 1 then hashStr = "00" .. hashStr elseif #hashStr == 2 then hashStr = "0" .. hashStr end
        local baseName = cleanName .. "_" .. hashStr
        local uniqueName = baseName
        local counter = 1
        while true do
            local existing = MySQL.query.await("SELECT id FROM bcchousing_config WHERE unique_name = ?", {uniqueName})
            if not existing or #existing == 0 then break end
            uniqueName = baseName .. "_" .. counter
            counter = counter + 1
            if counter > 999 then
                local fallbackHash = os.time() % 1000000
                local fallbackStr = tostring(fallbackHash)
                while #fallbackStr < 6 do fallbackStr = "0" .. fallbackStr end
                uniqueName = cleanName .. "_" .. fallbackStr
                break
            end
        end
        return uniqueName
    end
    
    -- Validar e definir valores padrão para campos obrigatórios
    local validatedData = {
        uniqueName = generateUniqueName(houseData.name),
        name = houseData.name or "House",
        houseCoords = houseData.houseCoords or vector3(0, 0, 0),
        houseRadiusLimit = houseData.houseRadiusLimit or 20,
        invLimit = houseData.invLimit or 1000,
        taxAmount = houseData.taxAmount or 0,
        playerMax = houseData.playerMax or 3,
        tpInt = houseData.tpInt or 0,
        tpInstance = houseData.tpInstance or 0,
        menuCoords = houseData.menuCoords or houseData.houseCoords or vector3(0, 0, 0),
        menuRadius = houseData.menuRadius or 2.0,
        price = houseData.price or 0,
        sellPrice = houseData.sellPrice or 0,
        rentalDeposit = houseData.rentalDeposit or 0,
        rentCharge = houseData.rentCharge or 0,
        canSell = houseData.canSell ~= false,
        canBuy = houseData.canBuy ~= false,
        canRent = houseData.canRent or false,
        doors = houseData.doors or {}
    }
    
    -- Inserir a casa no banco
    local houseId = MySQL.insert.await([[INSERT INTO bcchousing_config (
        unique_name, name, coords_x, coords_y, coords_z, radius_limit, 
        inv_limit, tax_amount, player_max, tp_int, tp_instance,
        menu_coords_x, menu_coords_y, menu_coords_z, menu_radius,
        price, sell_price, rental_deposit, rent_charge,
        can_sell, can_buy, can_rent,
        blip_owned_active, blip_owned_name, blip_owned_sprite, blip_owned_color,
        blip_forsale_active, blip_forsale_name, blip_forsale_sprite, blip_forsale_color
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ]], {
        validatedData.uniqueName,
        validatedData.name,
        validatedData.houseCoords.x,
        validatedData.houseCoords.y,
        validatedData.houseCoords.z,
        validatedData.houseRadiusLimit,
        validatedData.invLimit,
        validatedData.taxAmount,
        validatedData.playerMax,
        validatedData.tpInt,
        validatedData.tpInstance,
        validatedData.menuCoords.x,
        validatedData.menuCoords.y,
        validatedData.menuCoords.z,
        validatedData.menuRadius,
        validatedData.price,
        validatedData.sellPrice,
        validatedData.rentalDeposit,
        validatedData.rentCharge,
        validatedData.canSell and 1 or 0,
        validatedData.canBuy and 1 or 0,
        validatedData.canRent and 1 or 0,
        (houseData.blip and houseData.blip.owned and houseData.blip.owned.active) and 1 or 0,
        (houseData.blip and houseData.blip.owned and houseData.blip.owned.name) or "Sua Casa",
        (houseData.blip and houseData.blip.owned and houseData.blip.owned.sprite) or "blip_mp_base",
        (houseData.blip and houseData.blip.owned and houseData.blip.owned.color) or "WHITE",
        (houseData.blip and houseData.blip.forSale and houseData.blip.forSale.active) and 1 or 0,
        (houseData.blip and houseData.blip.forSale and houseData.blip.forSale.name) or "Casa a Venda",
        (houseData.blip and houseData.blip.forSale and houseData.blip.forSale.sprite) or "blip_ambient_delivery",
        (houseData.blip and houseData.blip.forSale and houseData.blip.forSale.color) or "BLIP_MODIFIER_MP_COLOR_16"
    })
    
    -- Inserir as portas se houver
    if validatedData.doors and #validatedData.doors > 0 then
        for _, door in ipairs(validatedData.doors) do
            MySQL.insert.await([[INSERT INTO bcchousing_config_doors (house_config_id, doorinfo, locked) VALUES (?, ?, ?)]], {houseId, door.doorinfo, door.locked and 1 or 0})
        end
    end
    
    -- Recarregar as casas
    LoadHousesFromDatabase()
    -- Notificar todos os jogadores para atualizar suas casas
    TriggerClientEvent('bcc-housing:reloadHouses', -1)
    VORPcore.NotifyRightTip(_source, "House added successfully!", 4000)
end)

-- Comando para remover uma casa
RegisterCommand('removehouse', function(source, args)
    local _source = source
    
    if #args < 1 then
        if _source > 0 then
            VORPcore.NotifyRightTip(_source, "Usage: /removehouse [uniqueName]", 4000)
        else
            print("Usage: removehouse [uniqueName]")
        end
        return
    end
    
    local uniqueName = args[1]
    
    -- Verificar permissões (mesmo código do addhouse)
    if _source > 0 then
        local User = VORPcore.getUser(_source)
        if not User then return end
        
        local group = User.getGroup
        local jobGrade = User.getUsedCharacter and User.getUsedCharacter.jobGrade or 0
        
        local isAllowed = false
        if group == Config.adminGroup then
            isAllowed = true
        else
            for _, job in pairs(Config.ALlowedJobs) do
                if job.jobname == User.getUsedCharacter.job and jobGrade >= (job.jobgrade or 0) then
                    isAllowed = true
                    break
                end
            end
        end
        
        if not isAllowed then
            VORPcore.NotifyRightTip(_source, "You don't have permission to use this command", 4000)
            return
        end
    end
    
    -- Verificar se existem casas compradas com este uniqueName
    local ownedHouses = MySQL.query.await("SELECT COUNT(*) as count FROM bcchousing WHERE uniqueName = ?", {uniqueName})
    
    if ownedHouses[1].count > 0 then
        if _source > 0 then
            VORPcore.NotifyRightTip(_source, "Cannot remove this house. " .. ownedHouses[1].count .. " players own it!", 4000)
        else
            print("Cannot remove this house. " .. ownedHouses[1].count .. " players own it!")
        end
        return
    end
    
    -- Remover a casa
    MySQL.update.await("DELETE FROM bcchousing_config WHERE unique_name = ?", {uniqueName})
    
    -- Recarregar as casas
    LoadHousesFromDatabase()
    
    -- Notificar todos os jogadores
    TriggerClientEvent('bcc-housing:reloadHouses', -1)
    
    if _source > 0 then
        VORPcore.NotifyRightTip(_source, "House removed successfully!", 4000)
    else
        print("House removed successfully!")
    end
end, false)

-- Exportar a função para outros resources poderem recarregar as casas
exports('ReloadHouses', LoadHousesFromDatabase)