package com.hotelmanagement.system.dao;

import com.hotelmanagement.system.model.Room;
import com.hotelmanagement.system.model.LuxuryRoom;
import com.hotelmanagement.system.model.StandardRoom;
import com.hotelmanagement.system.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import static com.hotelmanagement.system.util.DBConnection.getConnection;

public class RoomDAO {

    // CREATE — adding a new room to a hotel
    public boolean addRoom(Room room) throws SQLException {
        Connection con = getConnection();
        if (con == null) return false;
        String sql = "INSERT INTO rooms " +
                "(hotel_id, room_number, floor, room_type, room_tier, " +
                "price_per_night, capacity, status, description, image_url) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1,    room.getHotelId());
        ps.setString(2, room.getRoomNumber());
        ps.setInt(3,    room.getFloor());
        ps.setString(4, room.getRoomType());
        ps.setString(5, room.getRoomTier());
        ps.setDouble(6, room.getPricePerNight());
        ps.setInt(7,    room.getCapacity());
        ps.setString(8, "AVAILABLE"); // always starts as available
        ps.setString(9, room.getDescription());
        ps.setString(10, room.getImageUrl());
        int result = ps.executeUpdate();
        con.close();
        return result > 0;
    }

    // READ 1 — get list of all rooms for a hotel
    public List<Room> getRoomsByHotelId(int hotelId) throws SQLException {
        List<Room> roomList = new ArrayList<>();
        Connection con = getConnection();
        if (con == null) return roomList;
        String sql = "SELECT * FROM rooms WHERE hotel_id = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, hotelId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Room r = buildRoomFromResultSet(rs);
            roomList.add(r);
        }
        con.close();
        return roomList;
    }

    // READ 2 — get a single room by its id
    public Room getRoomById(int roomId) throws SQLException {
        Connection con = getConnection();
        if (con == null) return null;
        String sql = "SELECT * FROM rooms WHERE id = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, roomId);
        ResultSet rs = ps.executeQuery();
        Room r = null;
        if (rs.next()) {
            r = buildRoomFromResultSet(rs);
        }
        con.close();
        return r;
    }

    // READ 3 — get only available rooms for hotel
    public List<Room> getAvailableRoomsByHotelId(int hotelId) throws SQLException {
        List<Room> roomList = new ArrayList<>();
        Connection con = getConnection();
        if (con == null) return roomList;
        String sql = "SELECT * FROM rooms WHERE hotel_id = ? AND status = 'AVAILABLE'";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, hotelId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            roomList.add(buildRoomFromResultSet(rs));
        }
        con.close();
        return roomList;
    }

    // UPDATE — modifying room details
    public boolean updateRoom(int id, double price, String status, String description) throws SQLException {
        Connection con = getConnection();
        if (con == null) return false;
        String sql = "UPDATE rooms SET price_per_night = ?, status = ?, description = ? WHERE id = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setDouble(1, price);
        ps.setString(2, status);
        ps.setString(3, description);
        ps.setInt(4, id);
        int result = ps.executeUpdate();
        con.close();
        return result > 0;
    }

    // DELETE — remove a room permanently
    public boolean deleteRoom(int id) throws SQLException {
        Connection con = getConnection();
        if (con == null) return false;
        String sql = "DELETE FROM rooms WHERE id = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, id);
        int result = ps.executeUpdate();
        con.close();
        return result > 0;
    }

    // HELPER — builds the correct Room subclass from a ResultSet row
    private Room buildRoomFromResultSet(ResultSet rs) throws SQLException {
        String tier = rs.getString("room_tier");
        Room r;
        if (tier.equals("VIP") || tier.equals("GOLD")) {
            r = new LuxuryRoom();
        } else {
            r = new StandardRoom();
        }
        r.setId(rs.getInt("id"));
        r.setHotelId(rs.getInt("hotel_id"));
        r.setRoomNumber(rs.getString("room_number"));
        r.setFloor(rs.getInt("floor"));
        r.setRoomType(rs.getString("room_type"));
        r.setRoomTier(tier);
        r.setPricePerNight(rs.getDouble("price_per_night"));
        r.setCapacity(rs.getInt("capacity"));
        r.setStatus(rs.getString("status"));
        r.setDescription(rs.getString("description"));
        r.setImageUrl(rs.getString("image_url"));
        r.setCreatedAt(rs.getString("created_at"));
        return r;
    }
}
