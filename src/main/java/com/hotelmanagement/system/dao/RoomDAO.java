package com.hotelmanagement.system.dao;

import com.hotelmanagement.system.model.Room;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import static com.hotelmanagement.system.util.DBConnection.getConnection;

public class RoomDAO {
    public List<Room> getRoomsByHotelId(int hotelId) throws SQLException {
        List<Room> rooms = new ArrayList<>();
        Connection conn = getConnection();
        if (conn == null) return rooms;

        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM rooms WHERE hotel_id = ?");
        stmt.setInt(1, hotelId);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            Room room = new Room();
            room.setId(rs.getInt("id"));
            room.setHotelId(rs.getInt("hotel_id"));
            room.setRoomType(rs.getString("room_type"));
            room.setPricePerNight(rs.getDouble("price_per_night"));
            room.setCapacity(rs.getInt("capacity"));
            room.setTotalRooms(rs.getInt("total_rooms"));
            room.setAvailableRooms(rs.getInt("available_rooms"));
            room.setDescription(rs.getString("description"));
            rooms.add(room);
        }
        conn.close();
        return rooms;
    }

    public Room getRoomById(int roomId) throws SQLException {
        Connection conn = getConnection();
        if (conn == null) return null;

        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM rooms WHERE id = ?");
        stmt.setInt(1, roomId);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            Room room = new Room();
            room.setId(rs.getInt("id"));
            room.setHotelId(rs.getInt("hotel_id"));
            room.setRoomType(rs.getString("room_type"));
            room.setPricePerNight(rs.getDouble("price_per_night"));
            room.setCapacity(rs.getInt("capacity"));
            room.setTotalRooms(rs.getInt("total_rooms"));
            room.setAvailableRooms(rs.getInt("available_rooms"));
            room.setDescription(rs.getString("description"));
            conn.close();
            return room;
        }
        conn.close();
        return null;
    }

    public boolean addRoom(Room room) throws SQLException {
        Connection conn = getConnection();
        if (conn == null) return false;

        PreparedStatement stmt = conn.prepareStatement(
            "INSERT INTO rooms (hotel_id, room_type, price_per_night, capacity, total_rooms, available_rooms, description) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?)"
        );
        stmt.setInt(1, room.getHotelId());
        stmt.setString(2, room.getRoomType());
        stmt.setDouble(3, room.getPricePerNight());
        stmt.setInt(4, room.getCapacity());
        stmt.setInt(5, room.getTotalRooms());
        stmt.setInt(6, room.getAvailableRooms());
        stmt.setString(7, room.getDescription());

        int rows = stmt.executeUpdate();
        conn.close();
        return rows > 0;
    }
}
