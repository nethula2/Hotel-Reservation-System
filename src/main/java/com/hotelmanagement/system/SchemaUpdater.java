package com.hotelmanagement.system;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class SchemaUpdater {
    public static void main(String[] args) {
        String url = "jdbc:mysql://127.0.0.1:3307/hotel_reservation";
        String user = "root";
        String password = "";

        try (Connection conn = DriverManager.getConnection(url, user, password);
             Statement stmt = conn.createStatement()) {

            System.out.println("Altering bookings table...");
            
            try {
                stmt.execute("ALTER TABLE bookings ADD COLUMN nic_passport VARCHAR(100)");
                System.out.println("Added nic_passport");
            } catch (Exception e) { System.out.println("nic_passport may already exist: " + e.getMessage()); }

            try {
                stmt.execute("ALTER TABLE bookings ADD COLUMN country VARCHAR(100)");
                System.out.println("Added country");
            } catch (Exception e) { System.out.println("country may already exist: " + e.getMessage()); }

            try {
                stmt.execute("ALTER TABLE bookings ADD COLUMN special_requests TEXT");
                System.out.println("Added special_requests");
            } catch (Exception e) { System.out.println("special_requests may already exist: " + e.getMessage()); }

            try {
                stmt.execute("ALTER TABLE bookings ADD COLUMN payment_slip_url VARCHAR(500)");
                System.out.println("Added payment_slip_url");
            } catch (Exception e) { System.out.println("payment_slip_url may already exist: " + e.getMessage()); }

            try {
                stmt.execute("ALTER TABLE bookings MODIFY COLUMN status ENUM('PENDING', 'PENDING_VERIFICATION', 'CONFIRMED', 'CANCELLED', 'COMPLETED', 'REJECTED') DEFAULT 'PENDING_VERIFICATION'");
                System.out.println("Updated status ENUM");
            } catch (Exception e) { System.out.println("Failed to update status ENUM: " + e.getMessage()); }

            System.out.println("Schema update complete.");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
