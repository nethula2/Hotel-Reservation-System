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
                        image_url    VARCHAR(500),
                        status       ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING',
                        created_at   TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
                        FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ROOMS > store room info and type
CREATE TABLE rooms (
                       id              INT AUTO_INCREMENT PRIMARY KEY,
                       hotel_id        INT            NOT NULL,
                       room_type       ENUM('SINGLE', 'DOUBLE', 'SUITE', 'DELUXE') NOT NULL,
                       price_per_night DECIMAL(10, 2) NOT NULL,
                       capacity        INT            NOT NULL DEFAULT 1,
                       total_rooms     INT            NOT NULL DEFAULT 1,
                       available_rooms INT            NOT NULL DEFAULT 1,
                       description     TEXT,
                       created_at      TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
                       FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE CASCADE
);

-- BOOKINGS > used to keep track on bookings
CREATE TABLE bookings (
                          id            INT AUTO_INCREMENT PRIMARY KEY,
                          customer_id   INT            NOT NULL,
                          hotel_id      INT            NOT NULL,
                          room_id       INT            NOT NULL,
                          check_in      DATE           NOT NULL,
                          check_out     DATE           NOT NULL,
                          nights        INT            NOT NULL,
                          total_price   DECIMAL(10, 2) NOT NULL,
                          guests        INT            NOT NULL DEFAULT 1,
                          status        ENUM('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED') DEFAULT 'PENDING',
                          created_at    TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
                          FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE CASCADE,
                          FOREIGN KEY (hotel_id)    REFERENCES hotels(id) ON DELETE CASCADE,
                          FOREIGN KEY (room_id)     REFERENCES rooms(id)  ON DELETE CASCADE
);

-- REVIEWS
CREATE TABLE reviews (
                         id          INT AUTO_INCREMENT PRIMARY KEY,
                         customer_id INT  NOT NULL,
                         hotel_id    INT  NOT NULL,
                         booking_id  INT  NOT NULL,
                         rating      INT  NOT NULL CHECK (rating BETWEEN 1 AND 5),
                         comment     TEXT,
                         created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         FOREIGN KEY (customer_id) REFERENCES users(id)     ON DELETE CASCADE,
                         FOREIGN KEY (hotel_id)    REFERENCES hotels(id)    ON DELETE CASCADE,
                         FOREIGN KEY (booking_id)  REFERENCES bookings(id)  ON DELETE CASCADE
);

-- SEED DATA — default admin account
INSERT IGNORE INTO users (name, email, password, role)
VALUES ('Big Dawg', 'admin@hotel.com', 'admin123', 'ADMIN');