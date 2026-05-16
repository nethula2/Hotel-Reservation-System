package com.hotelmanagement.system;

import com.hotelmanagement.system.util.DBConnection;
import java.sql.Connection;
import java.sql.Statement;

public class DbFixer {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            System.out.println("Applying database migration...");
            
            // Add room_tier if not exists
            try {
                stmt.execute("ALTER TABLE rooms ADD COLUMN room_tier ENUM('STANDARD', 'GOLD', 'VIP') DEFAULT 'STANDARD' AFTER room_type");
                System.out.println("Added room_tier column.");
            } catch (Exception e) {
                System.out.println("room_tier might already exist: " + e.getMessage());
            }
            
            // Drop old columns
            try {
                stmt.execute("ALTER TABLE rooms DROP COLUMN standard_rooms");
                System.out.println("Dropped standard_rooms.");
            } catch (Exception e) {}
            
            try {
                stmt.execute("ALTER TABLE rooms DROP COLUMN vip_rooms");
                System.out.println("Dropped vip_rooms.");
            } catch (Exception e) {}
            
            System.out.println("Migration complete!");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
