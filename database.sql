CREATE TABLE IF NOT EXISTS `user` (
    `id` INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(100) NOT NULL,
    `email` VARCHAR(100) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL, -- Diperpanjang untuk hash yang lebih aman
    `role` ENUM('guest', 'admin') NOT NULL DEFAULT 'guest',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_user_email` (`email`),
    INDEX `idx_user_username` (`username`)
);

CREATE TABLE IF NOT EXISTS `vehicle` (
    `id` INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `description` TEXT NULL, -- Diubah ke TEXT untuk deskripsi yang lebih panjang
    `price` DECIMAL(10,2) NOT NULL DEFAULT 0.00, -- Ditambahkan kolom harga
    `stock` SMALLINT NOT NULL DEFAULT 0, -- Diubah ke SMALLINT untuk kapasitas lebih besar
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_vehicle_name` (`name`)
);

CREATE TABLE IF NOT EXISTS `order` (
    `id` INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_id` INTEGER NOT NULL,
    `order_number` VARCHAR(50) NOT NULL UNIQUE, -- Ditambahkan nomor order yang unik
    `total_price` DECIMAL(12,2) NOT NULL DEFAULT 0.00, -- Diubah ke DECIMAL untuk presisi
    `status` ENUM('pending', 'confirmed', 'processing', 'completed', 'cancelled') NOT NULL DEFAULT 'pending',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,
    `cancelled_at` DATETIME NULL, -- Dipisahkan dari status biasa
    INDEX `idx_order_user` (`user_id`),
    INDEX `idx_order_number` (`order_number`),
    INDEX `idx_order_status` (`status`),
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS `order_item` ( -- Nama diubah dari order_detail ke order_item
    `id` INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `order_id` INTEGER NOT NULL,
    `vehicle_id` INTEGER NOT NULL,
    `quantity` INTEGER NOT NULL DEFAULT 1, -- Ditambahkan quantity
    `unit_price` DECIMAL(10,2) NOT NULL, -- Harga satuan saat order
    `sub_total` DECIMAL(12,2) NOT NULL, -- Total per item
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_order_item_order` (`order_id`),
    INDEX `idx_order_item_vehicle` (`vehicle_id`),
    UNIQUE KEY `uk_order_item` (`order_id`, `vehicle_id`), -- Mencegah duplikasi item dalam order yang sama
    FOREIGN KEY (`order_id`) REFERENCES `order`(`id`) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (`vehicle_id`) REFERENCES `vehicle`(`id`) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS `payment` (
    `id` INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `order_id` INTEGER NOT NULL,
    `payment_method` VARCHAR(50) NOT NULL DEFAULT 'transfer', -- Ditambahkan metode pembayaran
    `amount` DECIMAL(12,2) NOT NULL, -- Diubah nama dari total ke amount
    `status` ENUM('pending', 'paid', 'failed', 'cancelled', 'refunded') NOT NULL DEFAULT 'pending',
    `payment_date` DATETIME NULL, -- Waktu pembayaran berhasil
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,
    `reference_number` VARCHAR(100) NULL, -- Nomor referensi pembayaran
    INDEX `idx_payment_order` (`order_id`),
    INDEX `idx_payment_status` (`status`),
    INDEX `idx_payment_reference` (`reference_number`),
    FOREIGN KEY (`order_id`) REFERENCES `order`(`id`) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS `token` (
    `id` INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_id` INTEGER NOT NULL,
    `token` VARCHAR(255) NOT NULL,
    `token_type` ENUM('access', 'refresh', 'reset_password') NOT NULL DEFAULT 'access', -- Ditambahkan tipe token
    `expires_at` DATETIME NOT NULL, -- Waktu kadaluarsa token
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_token_user` (`user_id`),
    INDEX `idx_token_value` (`token`),
    INDEX `idx_token_expires` (`expires_at`),
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON UPDATE CASCADE ON DELETE CASCADE
);