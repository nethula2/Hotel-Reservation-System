package com.hotelmanagement.system.dao;

import com.hotelmanagement.system.model.LuxuryRoom;
import com.hotelmanagement.system.model.Room;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import static com.hotelmanagement.system.util.DBConnection.getConnection;

public class RoomDAO {

    public boolean addRoom(Room room) throws SQLException {
        Connection connection = getConnection();
        if (connection == null) return false;

        PreparedStatement statement = connection.prepareStatement(
                "INSERT INTO rooms (hotel_id, room_type, price_per_night, capacity, total_rooms, available_rooms, description) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?)"
        );
        statement.setInt(1, room.getHotelId());
        statement.setString(2, room.getRoomType());
        statement.setDouble(3, room.getPricePerNight());
        statement.setInt(4, room.getCapacity());
        statement.setInt(5, room.getTotalRooms());
        statement.setInt(6, room.getAvailableRooms());
        statement.setString(7, room.getDescription());

        int rows = statement.executeUpdate();
        connection.close();
        return rows > 0;
    }

    public List<Room> getRoomsByHotelId(int hotelId) throws SQLException {
        List<Room> rooms = new ArrayList<>();
        Connection connection = getConnection();
        if (connection == null) return rooms;

        PreparedStatement statement = connection.prepareStatement(
                "SELECT * FROM rooms WHERE hotel_id = ?"
        );
        statement.setInt(1, hotelId);
        ResultSet rs = statement.executeQuery();

        while (rs.next()) {
            String roomType = rs.getString("room_type");
            Room room;

            if ("SUITE".equals(roomType) || "DELUXE".equals(roomType)) {
                room = new LuxuryRoom();
            } else {
                room = new Room();
            }

            room.setId(rs.getInt("id"));
            room.setHotelId(rs.getInt("hotel_id"));
            room.setRoomType(roomType);
            room.setPricePerNight(rs.getDouble("price_per_night"));
            room.setCapacity(rs.getInt("capacity"));
            room.setTotalRooms(rs.getInt("total_rooms"));
            room.setAvailableRooms(rs.getInt("available_rooms"));
            room.setDescription(rs.getString("description"));

            rooms.add(room);
        }
        connection.close();
        return rooms;
    }

    public boolean updateRoom(int roomId, double newPrice, int newAvailable) throws SQLException {
        Connection connection = getConnection();
        if (connection == null) return false;

        PreparedStatement statement = connection.prepareStatement(
                "UPDATE rooms SET price_per_night = ?, available_rooms = ? WHERE id = ?"
        );
        statement.setDouble(1, newPrice);
        statement.setInt(2, newAvailable);
        statement.setInt(3, roomId);

        int rows = statement.executeUpdate();
        connection.close();
        return rows > 0;
    }

    public boolean deleteRoom(int roomId) throws SQLException {
        Connection connection = getConnection();
        if (connection == null) return false;

        PreparedStatement statement = connection.prepareStatement(
                "DELETE FROM rooms WHERE id = ?"
        );
        statement.setInt(1, roomId);

        int rows = statement.executeUpdate();
        connection.close();
        return rows > 0;
    }
}
