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
}
