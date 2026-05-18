package com.hotelmanagement.system.dao;

import com.hotelmanagement.system.model.Booking;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import static com.hotelmanagement.system.util.DBConnection.getConnection;

public class BookingDAO {

    // CREATE
    public boolean insertBooking(Booking booking) throws SQLException {
        Connection connection = getConnection();
        if (connection == null) return false;

        String query =
                "INSERT INTO bookings " +
                        "(customer_id, hotel_id, room_id, check_in, check_out, nights, " +
                        "total_price, nic_passport, country, special_requests, payment_slip_url, status) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        PreparedStatement statement = connection.prepareStatement(
                query, Statement.RETURN_GENERATED_KEYS
        );

        statement.setInt(1,    booking.getCustomerId());
        statement.setInt(2,    booking.getHotelId());
        statement.setInt(3,    booking.getRoomId());
        statement.setDate(4,   booking.getCheckIn());
        statement.setDate(5,   booking.getCheckOut());
        statement.setInt(6,    booking.getNights());
        statement.setDouble(7, booking.getTotalPrice());
        statement.setString(8, booking.getNicPassport());
        statement.setString(9, booking.getCountry());
        statement.setString(10, booking.getSpecialRequests());
        statement.setString(11, booking.getPaymentSlipUrl());
        statement.setString(12, booking.getStatus());

        int rows = statement.executeUpdate();

        if (rows > 0) {
            ResultSet rs = statement.getGeneratedKeys();
            if (rs.next()) booking.setId(rs.getInt(1));
        }

        connection.close();
        return rows > 0;
    }

    // READ - single booking by id
    public Booking getBookingById(int id) throws SQLException {
        Connection connection = getConnection();
        if (connection == null) return null;

        PreparedStatement statement = connection.prepareStatement(
                "SELECT * FROM bookings WHERE id = ?"
        );
        statement.setInt(1, id);
        ResultSet rs = statement.executeQuery();

        Booking booking = null;
        if (rs.next()) booking = buildBookingFromResultSet(rs);

        connection.close();
        return booking;
    }

    // READ - all bookings (admin)
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

    // READ - by customer
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

    // READ - by room (for availability calendar)
    public List<Booking> getBookingsByRoomId(int roomId) throws SQLException {
        Connection connection = getConnection();
        if (connection == null) return new ArrayList<>();

        PreparedStatement statement = connection.prepareStatement(
                "SELECT * FROM bookings WHERE room_id = ? " +
                        "AND status != 'CANCELLED' AND status != 'REJECTED'"
        );
        statement.setInt(1, roomId);
        ResultSet rs = statement.executeQuery();

        List<Booking> bookings = new ArrayList<>();
        while (rs.next()) bookings.add(buildBookingFromResultSet(rs));

        connection.close();
        return bookings;
    }

    // READ - by hotel owner
    public List<Booking> getBookingsByOwnerId(int ownerId) throws SQLException {
        Connection connection = getConnection();
        if (connection == null) return new ArrayList<>();

        PreparedStatement statement = connection.prepareStatement(
                "SELECT b.*, h.name as hotel_name, r.room_type, u.name as customer_name " +
                        "FROM bookings b " +
                        "JOIN hotels h ON b.hotel_id = h.id " +
                        "JOIN rooms r ON b.room_id = r.id " +
                        "JOIN users u ON b.customer_id = u.id " +
                        "WHERE h.owner_id = ?"
        );
        statement.setInt(1, ownerId);
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

    // UPDATE - change booking status
    public boolean updateBookingStatus(int bookingId, String status) throws SQLException {
        Connection connection = getConnection();
        if (connection == null) return false;

        PreparedStatement statement = connection.prepareStatement(
                "UPDATE bookings SET status = ? WHERE id = ?"
        );
        statement.setString(1, status);
        statement.setInt(2, bookingId);

        int rows = statement.executeUpdate();
        connection.close();
        return rows > 0;
    }

    public Booking buildBookingFromResultSet(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setId(rs.getInt("id"));
        booking.setCustomerId(rs.getInt("customer_id"));
        booking.setHotelId(rs.getInt("hotel_id"));
        booking.setRoomId(rs.getInt("room_id"));
        booking.setCheckIn(rs.getDate("check_in"));
        booking.setCheckOut(rs.getDate("check_out"));
        booking.setNights(rs.getInt("nights"));
        booking.setTotalPrice(rs.getDouble("total_price"));
        booking.setNicPassport(rs.getString("nic_passport"));
        booking.setCountry(rs.getString("country"));
        booking.setSpecialRequests(rs.getString("special_requests"));
        booking.setPaymentSlipUrl(rs.getString("payment_slip_url"));
        booking.setStatus(rs.getString("status"));
        return booking;
    }


}