CreateThread(function()
    -- Create the bcchousing table if it doesn't exist
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `bcchousing` (
            `charidentifier` varchar(50) NOT NULL,
            `house_coords` LONGTEXT NOT NULL,
            `house_radius_limit` varchar(100) NOT NULL,
            `houseid` int NOT NULL AUTO_INCREMENT,
            `furniture` LONGTEXT NOT NULL DEFAULT 'none',
            `doors` LONGTEXT NOT NULL DEFAULT 'none',
            `allowed_ids` LONGTEXT NOT NULL DEFAULT 'none',
            `invlimit` varchar(50) NOT NULL DEFAULT 200,
            `player_source_spawnedfurn` varchar(50) NOT NULL DEFAULT 'none',
            `taxes_collected` varchar(50) NOT NULL DEFAULT 'false',
            `ledger` float NOT NULL DEFAULT 0,
            `tax_amount` float NOT NULL DEFAULT 0,
            PRIMARY KEY `houseid` (`houseid`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])

    -- Add tpInt and tpInstance columns to bcchousing if they don't exist
    MySQL.query.await("ALTER TABLE `bcchousing` ADD COLUMN IF NOT EXISTS `tpInt` int(10) DEFAULT 0")
    MySQL.query.await("ALTER TABLE `bcchousing` ADD COLUMN IF NOT EXISTS `tpInstance` int(10) DEFAULT 0")
    MySQL.query.await("ALTER TABLE `bcchousing` ADD COLUMN IF NOT EXISTS `uniqueName` VARCHAR(255) NOT NULL")
    MySQL.query.await("ALTER TABLE `bcchousing` ADD COLUMN IF NOT EXISTS `ownershipStatus` ENUM('purchased', 'rented') NOT NULL DEFAULT 'purchased'")

    -- Create the bcchousinghotels table if it doesn't exist
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `bcchousinghotels` (
            `charidentifier` varchar(50) NOT NULL,
            `hotels` LONGTEXT NOT NULL DEFAULT 'none'
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])

    -- Add index to bcchousinghotels if it doesn't exist
    MySQL.query.await([[
        CREATE INDEX IF NOT EXISTS `idx_charidentifier` ON `bcchousinghotels` (`charidentifier`);
    ]])

    -- Create the bcchousing_transactions table if it doesn't exist
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `bcchousing_transactions` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `houseid` int(11) NOT NULL,
            `identifier` varchar(50) NOT NULL,
            `amount` int(11) NOT NULL,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
    ]])

    -- Create the new house configuration tables
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `bcchousing_config` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `unique_name` varchar(255) NOT NULL UNIQUE,
            `name` varchar(255) NOT NULL,
            `coords_x` float NOT NULL,
            `coords_y` float NOT NULL,
            `coords_z` float NOT NULL,
            `radius_limit` int(11) NOT NULL DEFAULT 20,
            `inv_limit` int(11) NOT NULL DEFAULT 1000,
            `tax_amount` float NOT NULL DEFAULT 0,
            `player_max` int(11) NOT NULL DEFAULT 3,
            `tp_int` int(11) NOT NULL DEFAULT 0,
            `tp_instance` int(11) NOT NULL DEFAULT 0,
            `menu_coords_x` float NOT NULL,
            `menu_coords_y` float NOT NULL,
            `menu_coords_z` float NOT NULL,
            `menu_radius` float NOT NULL DEFAULT 2.0,
            `price` float NOT NULL,
            `sell_price` float NOT NULL,
            `rental_deposit` float NOT NULL DEFAULT 0,
            `rent_charge` float NOT NULL DEFAULT 0,
            `can_sell` boolean NOT NULL DEFAULT true,
            `can_buy` boolean NOT NULL DEFAULT true,
            `can_rent` boolean NOT NULL DEFAULT false,
            `blip_owned_active` boolean NOT NULL DEFAULT true,
            `blip_owned_name` varchar(255) DEFAULT 'My House',
            `blip_owned_sprite` varchar(255) DEFAULT 'blip_ambient_delivery',
            `blip_owned_color` varchar(50) DEFAULT 'BLIP_MODIFIER_MP_COLOR_21',
            `blip_forsale_active` boolean NOT NULL DEFAULT true,
            `blip_forsale_name` varchar(255) DEFAULT 'House for Sale',
            `blip_forsale_sprite` varchar(255) DEFAULT 'blip_ambient_delivery',
            `blip_forsale_color` varchar(50) DEFAULT 'BLIP_MODIFIER_MP_COLOR_16',
            `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
            `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            KEY `idx_unique_name` (`unique_name`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])

    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `bcchousing_config_doors` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `house_config_id` int(11) NOT NULL,
            `doorinfo` LONGTEXT NOT NULL,
            `locked` boolean NOT NULL DEFAULT true,
            PRIMARY KEY (`id`),
            KEY `idx_house_config_id` (`house_config_id`),
            CONSTRAINT `fk_house_config_doors` FOREIGN KEY (`house_config_id`) REFERENCES `bcchousing_config` (`id`) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])

    DbUpdated = true

    print("Database tables for \x1b[35m\x1b[1m*bcc-housing*\x1b[0m created or updated \x1b[32msuccessfully\x1b[0m.")
end)