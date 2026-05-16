package com.hotelmanagement.system.dao;

import com.hotelmanagement.system.model.LuxuryRoom;
import com.hotelmanagement.system.model.Room;
import com.hotelmanagement.system.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

// handles all Database operations for Rooms

public class RoomDAO {

    // CREATE - Adding a new room to the database
    public boolean addRoom(Room room) throws SQLException {
        // Getting connection from our DBConnection utility
        Connection con = DBConnection.getConnection();
        if (con == null) {
            return false;
        }

        // SQL query to insert data
        String sql = "INSERT INTO rooms (hotel_id, room_type, room_tier, price_per_night, capacity, total_rooms, available_rooms, description) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(sql);
        
        // Setting values for the query placeholders (?)
        ps.setInt(1, room.getHotelId());
        ps.setString(2, room.getRoomType());
        ps.setString(3, room.getRoomTier());
        ps.setDouble(4, room.getPricePerNight());
        ps.setInt(5, room.getCapacity());
        ps.setInt(6, room.getTotalRooms());
        ps.setInt(7, room.getAvailableRooms());
        ps.setString(8, room.getDescription());

        int result = ps.executeUpdate();
        
        con.close();
        
        return result > 0;
    }

    // READ - Getting a list of all rooms for a hotel
    public List<Room> getRoomsByHotelId(int hotelId) throws SQLException {
        List<Room> roomList = new ArrayList<>();
        Connection con = DBConnection.getConnection();
        if (con == null) {
            return roomList;
        }

        String sql = "SELECT * FROM rooms WHERE hotel_id = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, hotelId);
        
        // Executing the query and getting results
        ResultSet rs = ps.executeQuery();

        // Looping through the results
        while (rs.next()) {
            String type = rs.getString("room_type");
            Room r;

            // Using Inheritance
            if (type.equals("SUITE") || type.equals("DELUXE")) {
                r = new LuxuryRoom();
            } else {
                r = new Room();
            }

            // Setting data to the object
            r.setId(rs.getInt("id"));
            r.setHotelId(rs.getInt("hotel_id"));
            r.setRoomType(type);
            r.setRoomTier(rs.getString("room_tier"));
            r.setPricePerNight(rs.getDouble("price_per_night"));
            r.setCapacity(rs.getInt("capacity"));
            r.setTotalRooms(rs.getInt("total_rooms"));
            r.setAvailableRooms(rs.getInt("available_rooms"));
            r.setDescription(rs.getString("description"));


            roomList.add(r);
        }
        
        con.close();
        return roomList;
    }

    // READ - Getting a single room by ID
    public Room getRoomById(int roomId) throws SQLException {
        Connection con = DBConnection.getConnection();
        if (con == null) return null;

        String sql = "SELECT * FROM rooms WHERE id = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, roomId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            String type = rs.getString("room_type");
            Room r;
            if (type.equals("SUITE") || type.equals("DELUXE")) {
                r = new LuxuryRoom();
            } else {
                r = new Room();
            }
            r.setId(rs.getInt("id"));
            r.setHotelId(rs.getInt("hotel_id"));
            r.setRoomType(type);
            r.setRoomTier(rs.getString("room_tier"));
            r.setPricePerNight(rs.getDouble("price_per_night"));
            r.setCapacity(rs.getInt("capacity"));
            r.setTotalRooms(rs.getInt("total_rooms"));
            r.setAvailableRooms(rs.getInt("available_rooms"));
            r.setDescription(rs.getString("description"));
            con.close();
            return r;
        }
        con.close();
        return null;
    }

    // UPDATE -modifying existing room information
    public boolean updateRoom(int id, double price, int total, int available) throws SQLException {
        Connection con = DBConnection.getConnection();
        if (con == null) {
            return false;
        }

        String sql = "UPDATE rooms SET price_per_night = ?, total_rooms = ?, available_rooms = ? WHERE id = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setDouble(1, price);
        ps.setInt(2, total);
        ps.setInt(3, available);
        ps.setInt(4, id);

        int result = ps.executeUpdate();
        con.close();
        
        return result > 0;
    }

    // DELETE -removing a room from the system
    public boolean deleteRoom(int id) throws SQLException {
        Connection con = DBConnection.getConnection();
        if (con == null) {
            return false;
        }

        String sql = "DELETE FROM rooms WHERE id = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, id);

        int result = ps.executeUpdate();
        con.close();
        
        return result > 0;
    }
}
