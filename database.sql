CREATE DATABASE IF NOT EXISTS hotel_reservation;
USE hotel_reservation;

-- USERS > use this to store every user and role
CREATE TABLE users (
                       id           INT AUTO_INCREMENT PRIMARY KEY,
                       name         VARCHAR(100)  NOT NULL,
                       email        VARCHAR(100)  NOT NULL UNIQUE,
                       password     VARCHAR(255)  NOT NULL,
                       phone        VARCHAR(20),
                       role         ENUM('ADMIN', 'HOTEL_OWNER', 'CUSTOMER') NOT NULL,
                       is_active    BOOLEAN       DEFAULT TRUE,
                       created_at   TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
);

-- HOTELS > store hotels and their approve status
CREATE TABLE hotels (
                        id           INT AUTO_INCREMENT PRIMARY KEY,
                        owner_id     INT           NOT NULL,
                        name         VARCHAR(150)  NOT NULL,
                        city         VARCHAR(100)  NOT NULL,
                        address      VARCHAR(255)  NOT NULL,
                        description  TEXT,
                        star_rating  INT           CHECK (star_rating BETWEEN 1 AND 5),
                        image_url   VARCHAR(500)  DEFAULT 'https://site-img-res-new.s3.ap-south-1.amazonaws.com/next-site-images/mobileplaceholder.jpg',
                        status       ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING',
                        created_at   TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
                        FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ROOMS > store room info and type (updated)
CREATE TABLE rooms (
                       id              INT AUTO_INCREMENT PRIMARY KEY,
                       hotel_id        INT           NOT NULL,
                       room_number     VARCHAR(20)   NOT NULL,
                       floor           INT           DEFAULT 1,
                       room_type       ENUM('SINGLE', 'DOUBLE', 'SUITE', 'DELUXE') NOT NULL,
                       room_tier       ENUM('STANDARD', 'GOLD', 'VIP') DEFAULT 'STANDARD',
                       price_per_night DECIMAL(10,2) NOT NULL,
                       capacity        INT           NOT NULL DEFAULT 1,
                       status          ENUM('AVAILABLE', 'OCCUPIED', 'MAINTENANCE') DEFAULT 'AVAILABLE',
                       description     TEXT,
                       image_url       VARCHAR(500)  DEFAULT 'https://www.pngkey.com/png/detail/470-4703342_generic-placeholder-image-conference-room-free-icon.png',
                       created_at      TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
                       FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE CASCADE,
                       UNIQUE KEY unique_room (hotel_id, room_number)
);

-- BOOKINGS > used to keep track on bookings (updated - removed guest column)
CREATE TABLE bookings (
                          id            INT AUTO_INCREMENT PRIMARY KEY,
                          customer_id   INT            NOT NULL,
                          hotel_id      INT            NOT NULL,
                          room_id       INT            NOT NULL,
                          check_in      DATE           NOT NULL,
                          check_out     DATE           NOT NULL,
                          nights        INT            NOT NULL,
                          total_price   DECIMAL(10, 2) NOT NULL,
                          status           ENUM('PENDING', 'CONFIRMED', 'CANCELLED', 'REJECTED') DEFAULT 'PENDING',
                          created_at       TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
                          nic_passport     VARCHAR(100),
                          country          VARCHAR(100),
                          special_requests TEXT,
                          payment_slip_url VARCHAR(500),
                          FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE CASCADE,
                          FOREIGN KEY (hotel_id)    REFERENCES hotels(id) ON DELETE CASCADE,
                          FOREIGN KEY (room_id)     REFERENCES rooms(id)  ON DELETE CASCADE
);


-- SEED DATA — default admin account
INSERT IGNORE INTO users (name, email, password, role)
VALUES ('Admin - DK', 'admin@hotel.com', 'admin123', 'ADMIN');