-- Menu para adicionar casas ao banco de dados
local AddHouseMenu = nil
local preservedHouseData = nil -- Variável global para preservar dados

RegisterNetEvent('bcc-housing:openAddHouseMenu')
AddEventHandler('bcc-housing:openAddHouseMenu', function()
    if AddHouseMenu then
        AddHouseMenu:Close()
    end
    
    AddHouseMenu = FeatherMenu:RegisterMenu('bcc_housing_add_house', {
        top = '50%',
        left = '50%',
        ['720width'] = '720px',
        ['1080width'] = '900px',
        ['2kwidth'] = '1200px',
        ['4kwidth'] = '1500px',
        style = {},
        contentslot = {
            style = { ['height'] = '550px', ['min-height'] = '550px' }
        },
        draggable = true
    })
    
    local mainPage = AddHouseMenu:RegisterPage('main')
    
    mainPage:RegisterElement('header', {
        value = 'Add New House Configuration',
        slot = 'header',
        style = {}
    })
    
    mainPage:RegisterElement('line', {
        slot = 'header',
        style = {}
    })
    
    -- Dados da nova casa - restaurar dados preservados se existirem
    local newHouseData = preservedHouseData or { 
        doors = {},
        blip = {
            owned = {
                active = true,
                name = "My House",
                sprite = "blip_ambient_delivery",
                color = "BLIP_MODIFIER_MP_COLOR_21"
            },
            forSale = {
                active = true,
                name = "House for Sale",
                sprite = "blip_ambient_delivery",
                color = "BLIP_MODIFIER_MP_COLOR_16"
            }
        }
    }
    
    -- Limpar dados preservados após restaurar
    preservedHouseData = nil
    
    -- Nome de exibição
    mainPage:RegisterElement('input', {
        label = 'Display Name',
        placeholder = 'Strawberry House',
        inputType = 'text',
        slot = 'content',
        style = {}
    }, function(data)
        if data.value and data.value ~= '' then
            newHouseData.name = data.value
        end
    end)
    
    -- Coordenadas da casa
    mainPage:RegisterElement('button', {
        label = 'Set House Coordinates (Click to move freely)',
        slot = 'content',
        style = {}
    }, function()
        -- Preservar dados atuais do formulário
        preservedHouseData = newHouseData
        
        -- Fechar o menu temporariamente
        AddHouseMenu:Close()
        
        -- Notificar o usuário
        VORPcore.NotifyRightTip('Menu closed. Move to desired house location and press [E] to set coordinates.', 4000)
        
        -- Thread para capturar a tecla E
        CreateThread(function()
            while true do
                Wait(0)
                if IsControlJustPressed(0, 0xCEFD9220) then -- Tecla E
                    local ped = PlayerPedId()
                    local coords = GetEntityCoords(ped)
                    preservedHouseData.houseCoords = {x = coords.x, y = coords.y, z = coords.z}
                    
                    VORPcore.NotifyRightTip('House coordinates set! Reopening menu...', 2000)
                    
                    -- Reabrir o menu após um pequeno delay
                    Wait(2000)
                    TriggerEvent('bcc-housing:openAddHouseMenu')
                    break
                end
                
                -- Permitir fechar com ESC
                if IsControlJustPressed(0, 0x156F7119) then -- Tecla ESC
                    VORPcore.NotifyRightTip('Coordinate setting cancelled. Reopening menu...', 2000)
                    Wait(2000)
                    TriggerEvent('bcc-housing:openAddHouseMenu')
                    break
                end
            end
        end)
    end)
    
    -- Coordenadas do menu
    mainPage:RegisterElement('button', {
        label = 'Set Menu Coordinates (Click to move freely)',
        slot = 'content',
        style = {}
    }, function()
        -- Preservar dados atuais do formulário
        preservedHouseData = newHouseData
        
        -- Fechar o menu temporariamente
        AddHouseMenu:Close()
        
        -- Notificar o usuário
        VORPcore.NotifyRightTip('Menu closed. Move to desired menu location and press [E] to set coordinates.', 4000)
        
        -- Thread para capturar a tecla E
        CreateThread(function()
            while true do
                Wait(0)
                if IsControlJustPressed(0, 0xCEFD9220) then -- Tecla E
                    local ped = PlayerPedId()
                    local coords = GetEntityCoords(ped)
                    preservedHouseData.menuCoords = {x = coords.x, y = coords.y, z = coords.z}
                    
                    VORPcore.NotifyRightTip('Menu coordinates set! Reopening menu...', 2000)
                    
                    -- Reabrir o menu após um pequeno delay
                    Wait(2000)
                    TriggerEvent('bcc-housing:openAddHouseMenu')
                    break
                end
                
                -- Permitir fechar com ESC
                if IsControlJustPressed(0, 0x156F7119) then -- Tecla ESC
                    VORPcore.NotifyRightTip('Coordinate setting cancelled. Reopening menu...', 2000)
                    Wait(2000)
                    TriggerEvent('bcc-housing:openAddHouseMenu')
                    break
                end
            end
        end)
    end)
    
    -- Raio da casa
    mainPage:RegisterElement('slider', {
        label = 'House Radius',
        start = 20,
        min = 5,
        max = 100,
        steps = 5,
        slot = 'content',
        style = {}
    }, function(data)
        newHouseData.houseRadiusLimit = data.value
    end)
    
    -- Limite de inventário
    mainPage:RegisterElement('slider', {
        label = 'Inventory Limit',
        start = 1000,
        min = 100,
        max = 5000,
        steps = 100,
        slot = 'content',
        style = {}
    }, function(data)
        newHouseData.invLimit = data.value
    end)
    
    -- Preço
    mainPage:RegisterElement('input', {
        label = 'Purchase Price ($)',
        placeholder = '1000',
        inputType = 'number',
        slot = 'content',
        style = {}
    }, function(data)
        if data.value and tonumber(data.value) then
            newHouseData.price = tonumber(data.value)
        end
    end)
    
    -- Preço de venda
    mainPage:RegisterElement('input', {
        label = 'Sell Price ($)',
        placeholder = '500',
        inputType = 'number',
        slot = 'content',
        style = {}
    }, function(data)
        if data.value and tonumber(data.value) then
            newHouseData.sellPrice = tonumber(data.value)
        end
    end)
    
    -- Impostos
    mainPage:RegisterElement('input', {
        label = 'Tax Amount ($)',
        placeholder = '0',
        inputType = 'number',
        slot = 'content',
        style = {}
    }, function(data)
        if data.value and tonumber(data.value) then
            newHouseData.taxAmount = tonumber(data.value)
        end
    end)
    
    -- Interior TP
    mainPage:RegisterElement('slider', {
        label = 'Teleport Interior (0 = none)',
        start = 0,
        min = 0,
        max = 10,
        steps = 1,
        slot = 'content',
        style = {}
    }, function(data)
        newHouseData.tpInt = data.value
    end)
    
    -- Instance TP
    mainPage:RegisterElement('slider', {
        label = 'Teleport Instance (0 = none)',
        start = 0,
        min = 0,
        max = 10,
        steps = 1,
        slot = 'content',
        style = {}
    }, function(data)
        newHouseData.tpInstance = data.value
    end)
    
    -- Menu Radius
    mainPage:RegisterElement('slider', {
        label = 'Menu Radius',
        start = 2.0,
        min = 0.5,
        max = 10.0,
        steps = 0.5,
        slot = 'content',
        style = {}
    }, function(data)
        newHouseData.menuRadius = data.value
    end)
    
    -- Player Max
    mainPage:RegisterElement('slider', {
        label = 'Maximum Players',
        start = 3,
        min = 1,
        max = 10,
        steps = 1,
        slot = 'content',
        style = {}
    }, function(data)
        newHouseData.playerMax = data.value
    end)
    
    -- Rental Deposit
    mainPage:RegisterElement('input', {
        label = 'Rental Deposit ($)',
        placeholder = '0',
        inputType = 'number',
        slot = 'content',
        style = {}
    }, function(data)
        if data.value and tonumber(data.value) then
            newHouseData.rentalDeposit = tonumber(data.value)
        end
    end)
    
    -- Rent Charge
    mainPage:RegisterElement('input', {
        label = 'Rent Charge ($)',
        placeholder = '0',
        inputType = 'number',
        slot = 'content',
        style = {}
    }, function(data)
        if data.value and tonumber(data.value) then
            newHouseData.rentCharge = tonumber(data.value)
        end
    end)
    
    -- Opções
    mainPage:RegisterElement('checkbox', {
        label = 'Can Buy',
        start = true,
        slot = 'content',
        style = {}
    }, function(data)
        newHouseData.canBuy = data.value
    end)
    
    mainPage:RegisterElement('checkbox', {
        label = 'Can Sell',
        start = true,
        slot = 'content',
        style = {}
    }, function(data)
        newHouseData.canSell = data.value
    end)
    
    mainPage:RegisterElement('checkbox', {
        label = 'Can Rent',
        start = false,
        slot = 'content',
        style = {}
    }, function(data)
        newHouseData.canRent = data.value
    end)
    
    -- Botão para gerenciar portas
    mainPage:RegisterElement('button', {
        label = 'Manage Doors',
        slot = 'content',
        style = {}
    }, function()
        newHouseData.doors = newHouseData.doors or {}
        OpenDoorManagementMenu(newHouseData)
    end)
    
    mainPage:RegisterElement('line', {
        slot = 'footer',
        style = {}
    })
    
    -- Botão de salvar
    mainPage:RegisterElement('button', {
        label = 'Save House Configuration',
        slot = 'footer',
        style = {}
    }, function()
        -- Validar dados
        if not newHouseData.name or newHouseData.name == '' then
            VORPcore.NotifyRightTip('Please enter a display name!', 4000)
            return
        end
        
        if not newHouseData.houseCoords.x then
            VORPcore.NotifyRightTip('Please set house coordinates!', 4000)
            return
        end
        
        if not newHouseData.menuCoords.x then
            VORPcore.NotifyRightTip('Please set menu coordinates!', 4000)
            return
        end
        
        -- Enviar para o servidor
        TriggerServerEvent('bcc-housing:saveNewHouseConfig', newHouseData)
        AddHouseMenu:Close()
    end)
    
    -- Botão de cancelar
    mainPage:RegisterElement('button', {
        label = 'Cancel',
        slot = 'footer',
        style = {}
    }, function()
        AddHouseMenu:Close()
    end)
    
    AddHouseMenu:Open({ 
        startupPage = mainPage,
        menuFocus = true,   -- Mantém o foco do menu para interação
        cursorFocus = true  -- Mantém o cursor para interagir com o menu
    })
    
    -- Notificar o usuário sobre como coletar coordenadas
    VORPcore.NotifyRightTip('Use the coordinate buttons to temporarily close the menu and set positions.', 4000)
end)

-- Menu para gerenciar portas
function OpenDoorManagementMenu(houseData)
    houseData = houseData or {}
    houseData.doors = houseData.doors or {}
    local doorPage = AddHouseMenu:RegisterPage('doors')
    
    doorPage:RegisterElement('header', {
        value = 'Door Management',
        slot = 'header',
        style = {}
    })
    
    doorPage:RegisterElement('line', {
        slot = 'header',
        style = {}
    })
    
    -- Listar portas existentes
    if #houseData.doors > 0 then
        for i, door in ipairs(houseData.doors) do
            doorPage:RegisterElement('button', {
                label = 'Door ' .. i .. ': ' .. (door.locked and 'Locked' or 'Unlocked'),
                slot = 'content',
                style = {}
            }, function()
                -- Remover porta
                table.remove(houseData.doors, i)
                VORPcore.NotifyRightTip('Door removed!', 2000)
                OpenDoorManagementMenu(houseData) -- Recarregar menu
            end)
        end
    else
        doorPage:RegisterElement('textdisplay', {
            value = 'No doors added yet',
            slot = 'content',
            style = {}
        })
    end
    
    -- Adicionar nova porta
    doorPage:RegisterElement('button', {
        label = 'Add Nearest Door',
        slot = 'content',
        style = {}
    }, function()
        -- Detectar porta mais próxima
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local closestDoor = nil
        local closestDistance = 3.0
        
        -- Procurar por portas próximas
        for door, doorData in pairs(DoorHashes) do
            local doorCoords = vector3(doorData[4], doorData[5], doorData[6])
            local distance = #(playerCoords - doorCoords)
            
            if distance < closestDistance then
                closestDoor = doorData
                closestDistance = distance
            end
        end
        
        if closestDoor then
            local doorInfo = '[' .. table.concat(closestDoor, ',') .. ']'
            table.insert(houseData.doors, {
                doorinfo = doorInfo,
                locked = true
            })
            VORPcore.NotifyRightTip('Door added!', 2000)
            OpenDoorManagementMenu(houseData) -- Recarregar menu
        else
            VORPcore.NotifyRightTip('No door found nearby!', 4000)
        end
    end)
    
    doorPage:RegisterElement('line', {
        slot = 'footer',
        style = {}
    })
    
    -- Voltar
    doorPage:RegisterElement('button', {
        label = 'Back',
        slot = 'footer',
        style = {}
    }, function()
        AddHouseMenu:Open({ startupPage = 'main' })
    end)
    
    AddHouseMenu:Open({ startupPage = 'doors' })
end

-- Evento para recarregar as casas
RegisterNetEvent('bcc-housing:reloadHouses')
AddEventHandler('bcc-housing:reloadHouses', function()
    -- Recarregar as casas do cliente
    TriggerServerEvent('bcc-housing:CheckIfHasHouse')
end)