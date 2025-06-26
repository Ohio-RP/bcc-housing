Config = {
    -- Defina seu idioma aqui
    defaultlang = 'br_lang',
    -----------------------------------------------------

    DevMode = true,               -- False no servidor ao vivo
    DevModeCommand = "HousingDev", -- Este comando precisa ser enviado após reiniciar o recurso
    -----------------------------------------------------

    keys = {
        manage = 'G',  -- [G] Gerenciar Casa
        collect = 'G', -- [G] Coletar dinheiro da venda da casa
        buy = 'G',     -- [B] Comprar casa
    },
    -----------------------------------------------------

    -- Defina seu grupo de administrador aqui
    adminGroup = 'admin',
    -----------------------------------------------------

    -- Empregos que poderão criar casas assim como os administradores acima. Útil para empregos de corretor de imóveis
    ALlowedJobs = {
        { jobname = 'realtor' }, -- Para adicionar mais, apenas copie/cole e altere o nome do emprego
    },
    -----------------------------------------------------

    -- Comandos de administrador
    AdminManagementMenuCommand = 'HousingManager', -- nome do comando para admins gerenciarem todas as casas
    -----------------------------------------------------

    -- Máximo de casas permitidas por personagem
    Setup = {
        MaxHousePerChar = 3,
    },
    -----------------------------------------------------

    collectTaxes = true,
    -- Dia para checar o livro-caixa e coletar impostos
    TaxDay = 26,      -- Número do dia de cada mês que os impostos serão coletados
    TaxResetDay = 27, -- ESTE DEVE ser o dia seguinte ao TaxDay definido acima!!! (não altere estas datas se a data atual for uma das duas, por exemplo, se for dia 22 ou 23 não altere ou quebrará o código)
    -----------------------------------------------------

    -- Webhooks do Discord
    WebhookLink = 'https://canary.discord.com/api/webhooks/1383900094742532147/mRitLo8be0z0v-Uif6NPDrlUUYvnTVT2QPHGCbMtx-CWT_uf1G3B-FmB2AorSKt_D46O', -- insira o link do seu webhook aqui se quiser webhooks
    WebhookTitle = 'Ohio Casas',
    WebhookAvatar = 'https://media.discordapp.net/attachments/1312746579735613441/1374480223273353256/ohio-logo.png?ex=684fd235&is=684e80b5&hm=2774f91f747e1c8def3d50f2352d7342b66fe39783321547d2816ce42abf694c&=&format=webp&quality=lossless&width=639&height=639',
    -----------------------------------------------------

    doors = { -- Ativar/desativar botões de porta no menu da casa
        createNewDoors = true,
        removeDoors = true
    },
    -----------------------------------------------------

    EnablePrivatePropertyCheck = true, -- Defina como true para exibir uma mensagem ao entrar em propriedade privada
    -----------------------------------------------------

    UseImageAtBottomMenu = true,
    HouseImageURL = [[<img style="margin: 0 auto; max-width: 20vw; max-height: 15vh; width: auto; height: auto;" src="]] ..
        "https://bcc-scripts.com/servericons/provision_jail_keys.png" .. [[" />]],
    --<img width="750px" height="108px" style="margin: 0 auto;" src="https://bcc-scripts.com/servericons/ammo_arrow_tracking.png" /> -- Adicione a URL da imagem desejada aqui
    -----------------------------------------------------

    dontShowNames = true, -- Se true, o ID do jogador será exibido no menu de lista de jogadores ao invés do nome
    -----------------------------------------------------

    -- Casas com TP
    -- Aqui você precisa adicionar coordenadas para interiores cujas portas não podem ser abertas. Entre na casa com Noclip e pegue as coordenadas.
    -- Certifique-se de adicionar as coordenadas antes de criar a casa TP
    TpInteriors = {
        Interior1 = {
            exitCoords = vector3(-1103.15, -2252.92, 50.65),
            furnRadius = 10
        },
        Interior2 = {
            exitCoords = vector3(-63.74, 14.05, 76.6),
            furnRadius = 10
        },
        Interior3 = {
            exitCoords = vector3(-60.36, 1238.86, 170.79),
            furnRadius = 10
        },
    },
    -----------------------------------------------------

    SellToPlayer = true,             -- Defina como false se não quiser que jogadores vendam casas para outros jogadores
    DefaultSellPricetoPlayer = 50000, -- Preço de venda padrão para casas a outro jogador
    -----------------------------------------------------

    -- Configurações globais de Blip para casas possuídas criadas pelo menu (não para casas configuradas por config)
    HouseBlip = {
        active = true,           -- Mostrar blip para casas possuídas
        name = 'Sua Casa',     -- Nome do blip de casa no mapa
        sprite = 'blip_mp_base', -- Defina o sprite do blip da casa
        color = 'WHITE',         -- Defina a cor do blip da casa (veja BlipColors abaixo)
    },
    -----------------------------------------------------


    DefaultMenuManageRadius = 1.2,
    -----------------------------------------------------

    BlipColors = {
        LIGHT_BLUE    = 'BLIP_MODIFIER_MP_COLOR_1',
        DARK_RED      = 'BLIP_MODIFIER_MP_COLOR_2',
        PURPLE        = 'BLIP_MODIFIER_MP_COLOR_3',
        ORANGE        = 'BLIP_MODIFIER_MP_COLOR_4',
        TEAL          = 'BLIP_MODIFIER_MP_COLOR_5',
        LIGHT_YELLOW  = 'BLIP_MODIFIER_MP_COLOR_6',
        PINK          = 'BLIP_MODIFIER_MP_COLOR_7',
        GREEN         = 'BLIP_MODIFIER_MP_COLOR_8',
        DARK_TEAL     = 'BLIP_MODIFIER_MP_COLOR_9',
        RED           = 'BLIP_MODIFIER_MP_COLOR_10',
        LIGHT_GREEN   = 'BLIP_MODIFIER_MP_COLOR_11',
        TEAL2         = 'BLIP_MODIFIER_MP_COLOR_12',
        BLUE          = 'BLIP_MODIFIER_MP_COLOR_13',
        DARK_PUPLE    = 'BLIP_MODIFIER_MP_COLOR_14',
        DARK_PINK     = 'BLIP_MODIFIER_MP_COLOR_15',
        DARK_DARK_RED = 'BLIP_MODIFIER_MP_COLOR_16',
        GRAY          = 'BLIP_MODIFIER_MP_COLOR_17',
        PINKISH       = 'BLIP_MODIFIER_MP_COLOR_18',
        YELLOW_GREEN  = 'BLIP_MODIFIER_MP_COLOR_19',
        DARK_GREEN    = 'BLIP_MODIFIER_MP_COLOR_20',
        BRIGHT_BLUE   = 'BLIP_MODIFIER_MP_COLOR_21',
        BRIGHT_PURPLE = 'BLIP_MODIFIER_MP_COLOR_22',
        YELLOW_ORANGE = 'BLIP_MODIFIER_MP_COLOR_23',
        BLUE2         = 'BLIP_MODIFIER_MP_COLOR_24',
        TEAL3         = 'BLIP_MODIFIER_MP_COLOR_25',
        TAN           = 'BLIP_MODIFIER_MP_COLOR_26',
        OFF_WHITE     = 'BLIP_MODIFIER_MP_COLOR_27',
        LIGHT_YELLOW2 = 'BLIP_MODIFIER_MP_COLOR_28',
        LIGHT_PINK    = 'BLIP_MODIFIER_MP_COLOR_29',
        LIGHT_RED     = 'BLIP_MODIFIER_MP_COLOR_30',
        LIGHT_YELLOW3 = 'BLIP_MODIFIER_MP_COLOR_31',
        WHITE         = 'BLIP_MODIFIER_MP_COLOR_32'
    }
}
