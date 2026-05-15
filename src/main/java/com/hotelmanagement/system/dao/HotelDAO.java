package com.hotelmanagement.system.dao;

import com.hotelmanagement.system.model.Hotel;
import com.hotelmanagement.system.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HotelDAO {

    public boolean addHotel(Hotel hotel) throws SQLException {
        String query = "INSERT INTO hotels (owner_id, name, city, address, description, star_rating, image_url) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, hotel.getOwnerId());
            ps.setString(2, hotel.getName());
            ps.setString(3, hotel.getCity());
            ps.setString(4, hotel.getAddress());
            ps.setString(5, hotel.getDescription());
            ps.setInt(6, hotel.getStarRating());
            ps.setString(7, hotel.getImageUrl());
            return ps.executeUpdate() > 0;
        }
    }

    public List<Hotel> getHotelsByOwnerId(int ownerId) throws SQLException {
        List<Hotel> hotels = new ArrayList<>();
        String query = "SELECT * FROM hotels WHERE owner_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Hotel hotel = mapResultSetToHotel(rs);
                    hotels.add(hotel);
                }
            }
        }
        return hotels;
    }

    public List<Hotel> getAllApprovedHotels() throws SQLException {
        List<Hotel> hotels = new ArrayList<>();
        String query = "SELECT * FROM hotels WHERE status = 'APPROVED'";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                hotels.add(mapResultSetToHotel(rs));
            }
        }
        return hotels;
    }

    private Hotel mapResultSetToHotel(ResultSet rs) throws SQLException {
        Hotel hotel = new Hotel();
        hotel.setId(rs.getInt("id"));
        hotel.setOwnerId(rs.getInt("owner_id"));
        hotel.setName(rs.getString("name"));
        hotel.setCity(rs.getString("city"));
        hotel.setAddress(rs.getString("address"));
        hotel.setDescription(rs.getString("description"));
        hotel.setStarRating(rs.getInt("star_rating"));
        hotel.setImageUrl(rs.getString("image_url"));
        hotel.setStatus(rs.getString("status"));
        return hotel;
    }
}
