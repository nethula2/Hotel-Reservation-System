package com.hotelmanagement.system.dao;

import com.hotelmanagement.system.model.Booking;
import com.hotelmanagement.system.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    public boolean createBooking(Booking booking) throws SQLException {
        String query = "INSERT INTO bookings (customer_id, hotel_id, room_id, check_in, check_out, nights, total_price, guests) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, booking.getCustomerId());
            ps.setInt(2, booking.getHotelId());
            ps.setInt(3, booking.getRoomId());
            ps.setDate(4, booking.getCheckIn());
            ps.setDate(5, booking.getCheckOut());
            ps.setInt(6, booking.getNights());
            ps.setDouble(7, booking.getTotalPrice());
            ps.setInt(8, 1); // Default to 1 guest for now or add field to Booking
            return ps.executeUpdate() > 0;
        }
    }

    public List<Booking> getBookingsByOwnerId(int ownerId) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String query = "SELECT b.*, u.name as customer_name, h.name as hotel_name, r.room_type " +
                       "FROM bookings b " +
                       "JOIN users u ON b.customer_id = u.id " +
                       "JOIN hotels h ON b.hotel_id = h.id " +
                       "JOIN rooms r ON b.room_id = r.id " +
                       "WHERE h.owner_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking booking = mapResultSetToBooking(rs);
                    booking.setCustomerName(rs.getString("customer_name"));
                    booking.setHotelName(rs.getString("hotel_name"));
                    booking.setRoomType(rs.getString("room_type"));
                    bookings.add(booking);
                }
            }
        }
        return bookings;
    }

    public boolean updateBookingStatus(int bookingId, String status) throws SQLException {
        String query = "UPDATE bookings SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        }
    }

    private Booking mapResultSetToBooking(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setId(rs.getInt("id"));
        booking.setCustomerId(rs.getInt("customer_id"));
        booking.setHotelId(rs.getInt("hotel_id"));
        booking.setRoomId(rs.getInt("room_id"));
        booking.setCheckIn(rs.getDate("check_in"));
        booking.setCheckOut(rs.getDate("check_out"));
        booking.setNights(rs.getInt("nights"));
        booking.setTotalPrice(rs.getDouble("total_price"));
        booking.setStatus(rs.getString("status"));
        return booking;
    }
}
