package com.hotelmanagement.system.dao;

import com.hotelmanagement.system.model.Room;
import com.hotelmanagement.system.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO {

    public List<Room> getRoomsByHotelId(int hotelId) throws SQLException {
        List<Room> rooms = new ArrayList<>();
        String query = "SELECT * FROM rooms WHERE hotel_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, hotelId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    rooms.add(mapResultSetToRoom(rs));
                }
            }
        }
        return rooms;
    }

    public Room getRoomById(int roomId) throws SQLException {
        String query = "SELECT * FROM rooms WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToRoom(rs);
                }
            }
        }
        return null;
    }

    public boolean updateRoomAvailability(int roomId, int change) throws SQLException {
        String query = "UPDATE rooms SET available_rooms = available_rooms + ? WHERE id = ? AND available_rooms + ? >= 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, change);
            ps.setInt(2, roomId);
            ps.setInt(3, change);
            return ps.executeUpdate() > 0;
        }
    }

    private Room mapResultSetToRoom(ResultSet rs) throws SQLException {
        Room room = new Room();
        room.setId(rs.getInt("id"));
        room.setHotelId(rs.getInt("hotel_id"));
        room.setRoomType(rs.getString("room_type"));
        room.setPricePerNight(rs.getDouble("price_per_night"));
        room.setCapacity(rs.getInt("capacity"));
        room.setTotalRooms(rs.getInt("total_rooms"));
        room.setAvailableRooms(rs.getInt("available_rooms"));
        room.setDescription(rs.getString("description"));
        return room;
    }
}
