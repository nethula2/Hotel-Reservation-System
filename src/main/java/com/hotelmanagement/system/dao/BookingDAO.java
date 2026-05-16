package com.hotelmanagement.system.dao;

import com.hotelmanagement.system.model.Booking;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import static com.hotelmanagement.system.util.DBConnection.getConnection;

public class BookingDAO {

    public boolean insertBooking(Booking booking) throws SQLException {
        Connection connection = getConnection();
        if (connection == null) return false;

        String query = "INSERT INTO bookings (customer_id, hotel_id, room_id, check_in, check_out, nights, total_price, guests, nic_passport, country, special_requests, payment_slip_url, status) " +
                       "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        PreparedStatement statement = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
        statement.setInt(1, booking.getCustomerId());
        statement.setInt(2, booking.getHotelId());
        statement.setInt(3, booking.getRoomId());
        statement.setDate(4, booking.getCheckIn());
        statement.setDate(5, booking.getCheckOut());
        statement.setInt(6, booking.getNights());
        statement.setDouble(7, booking.getTotalPrice());
        statement.setInt(8, booking.getGuests());
        statement.setString(9, booking.getNicPassport());
        statement.setString(10, booking.getCountry());
        statement.setString(11, booking.getSpecialRequests());
        statement.setString(12, booking.getPaymentSlipUrl());
        statement.setString(13, booking.getStatus());

        int rows = statement.executeUpdate();

        if (rows > 0) {
            ResultSet rs = statement.getGeneratedKeys();
            if (rs.next()) {
                booking.setId(rs.getInt(1));
            }
        }

        connection.close();
        return rows > 0;
    }

    public List<Booking> getAllBookings() throws SQLException {
        Connection connection = getConnection();
        if (connection == null) return new ArrayList<>();

        PreparedStatement statement = connection.prepareStatement(
            "SELECT b.*, h.name as hotel_name, r.room_type, u.name as customer_name " +
            "FROM bookings b " +
            "JOIN hotels h ON b.hotel_id = h.id " +
            "JOIN rooms r ON b.room_id = r.id " +
            "JOIN users u ON b.customer_id = u.id"
        );
        ResultSet rs = statement.executeQuery();

        List<Booking> bookings = new ArrayList<>();
        while (rs.next()) {
            Booking booking = buildBookingFromResultSet(rs);
            booking.setHotelName(rs.getString("hotel_name"));
            booking.setRoomType(rs.getString("room_type"));
            booking.setCustomerName(rs.getString("customer_name"));
            bookings.add(booking);
        }

        connection.close();
        return bookings;
    }

    public boolean updateBookingStatus(int bookingId, String status) throws SQLException {
        Connection connection = getConnection();
        if (connection == null) return false;

        PreparedStatement statement = connection.prepareStatement("UPDATE bookings SET status = ? WHERE id = ?");
        statement.setString(1, status);
        statement.setInt(2, bookingId);

        int rows = statement.executeUpdate();
        connection.close();
        return rows > 0;
    }

    private Booking buildBookingFromResultSet(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setId(rs.getInt("id"));
        booking.setCustomerId(rs.getInt("customer_id"));
        booking.setHotelId(rs.getInt("hotel_id"));
        booking.setRoomId(rs.getInt("room_id"));
        booking.setCheckIn(rs.getDate("check_in"));
        booking.setCheckOut(rs.getDate("check_out"));
        booking.setNights(rs.getInt("nights"));
        booking.setTotalPrice(rs.getDouble("total_price"));
        booking.setGuests(rs.getInt("guests"));
        
        try { booking.setNicPassport(rs.getString("nic_passport")); } catch (Exception ignored) {}
        try { booking.setCountry(rs.getString("country")); } catch (Exception ignored) {}
        try { booking.setSpecialRequests(rs.getString("special_requests")); } catch (Exception ignored) {}
        try { booking.setPaymentSlipUrl(rs.getString("payment_slip_url")); } catch (Exception ignored) {}
        
        booking.setStatus(rs.getString("status"));
        return booking;
    }
    public List<Booking> getBookingsByCustomerId(int customerId) throws SQLException {
        Connection connection = getConnection();
        if (connection == null) return new ArrayList<>();

        PreparedStatement statement = connection.prepareStatement(
            "SELECT b.*, h.name as hotel_name, r.room_type " +
            "FROM bookings b " +
            "JOIN hotels h ON b.hotel_id = h.id " +
            "JOIN rooms r ON b.room_id = r.id " +
            "WHERE b.customer_id = ?"
        );
        statement.setInt(1, customerId);
        ResultSet rs = statement.executeQuery();

        List<Booking> bookings = new ArrayList<>();
        while (rs.next()) {
            Booking booking = buildBookingFromResultSet(rs);
            booking.setHotelName(rs.getString("hotel_name"));
            booking.setRoomType(rs.getString("room_type"));
            bookings.add(booking);
        }

        connection.close();
        return bookings;
    }
}
