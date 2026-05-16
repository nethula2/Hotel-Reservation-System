package com.hotelmanagement.system.dao;

import com.hotelmanagement.system.model.Hotel;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import static com.hotelmanagement.system.util.DBConnection.getConnection;

public class HotelDAO {
    public boolean addHotel(Hotel hotel) throws SQLException {
        Connection connection = getConnection();

        if (connection == null) {
            System.out.println("Connection to Database Failed");
            return false;
        }

        PreparedStatement statement = connection.prepareStatement(
                "INSERT INTO hotels (owner_id, name, city, address, description, star_rating, status) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?)"
        );

        statement.setInt(1, hotel.getOwnerId());
        statement.setString(2, hotel.getName());
        statement.setString(3, hotel.getCity());
        statement.setString(4, hotel.getAddress());
        statement.setString(5, hotel.getDescription());
        statement.setInt(6, hotel.getStarRating());
        statement.setString(7, "PENDING");

        int rows = statement.executeUpdate();

        connection.close();

        return rows > 0;

    }

    public List<Hotel> getHotelsByOwnerId(int ownerId) throws SQLException {
        List<Hotel> hotels = new ArrayList<>();

        Connection connection = getConnection();

        if (connection == null) {
            System.out.println("Connection to Database Failed");
            return hotels;
        }

        PreparedStatement statement = connection.prepareStatement(
                "SELECT * FROM hotels WHERE owner_id = ? "
        );

        statement.setInt(1, ownerId);

        ResultSet rs = statement.executeQuery();

        while (rs.next()){
            Hotel hotel = new Hotel();

            hotel.setName(rs.getString("name"));
            hotel.setCity(rs.getString("city"));
            hotel.setAddress(rs.getString("address"));
            hotel.setDescription(rs.getString("description"));
            hotel.setStarRating(rs.getInt("star_rating"));
            hotel.setOwnerId(ownerId);
            hotel.setId(rs.getInt("id"));
            hotel.setStatus(rs.getString("status"));

            hotels.add(hotel);

        }
        connection.close();
        return hotels;
    }

    public List<Hotel> getPendingHotels() throws SQLException {
        List<Hotel> hotels = new ArrayList<>();

        Connection connection = getConnection();

        if (connection == null) {
            System.out.println("Connection to Database Failed");
            return hotels;
        }

        PreparedStatement statement = connection.prepareStatement(
                "SELECT * FROM hotels WHERE status = ? "
        );

        statement.setString(1, "PENDING");

        ResultSet rs = statement.executeQuery();

        while (rs.next()){
            Hotel hotel = new Hotel();

            hotel.setName(rs.getString("name"));
            hotel.setCity(rs.getString("city"));
            hotel.setAddress(rs.getString("address"));
            hotel.setDescription(rs.getString("description"));
            hotel.setStarRating(rs.getInt("star_rating"));
            hotel.setOwnerId(rs.getInt("owner_id"));
            hotel.setId(rs.getInt("id"));
            hotel.setStatus(rs.getString("status"));

            hotels.add(hotel);

        }
        connection.close();
        return hotels;
    }

    public boolean updateHotelStatus(int hotelId, String status) throws SQLException {
        Connection connection = getConnection();

        if (connection == null) {
            System.out.println("Connection to Database Failed");
            return false;
        }

        PreparedStatement statement = connection.prepareStatement(
                "UPDATE hotels SET status = ? WHERE id = ?"
        );

        statement.setString(1, status);
        statement.setInt(2, hotelId);

        int rowsUpdated = statement.executeUpdate();

        connection.close();
        return rowsUpdated > 0;
    }

    public Hotel getHotelById(int hotelId) throws SQLException {
        Connection connection = getConnection();
        if (connection == null) return null;

        PreparedStatement statement = connection.prepareStatement(
                "SELECT * FROM hotels WHERE id = ?"
        );
        statement.setInt(1, hotelId);

        ResultSet rs = statement.executeQuery();
        Hotel hotel = null;

        if (rs.next()){
            hotel = new Hotel();
            hotel.setId(rs.getInt("id"));
            hotel.setName(rs.getString("name"));
            hotel.setCity(rs.getString("city"));
            hotel.setAddress(rs.getString("address"));
            hotel.setDescription(rs.getString("description"));
            hotel.setStarRating(rs.getInt("star_rating"));
            hotel.setOwnerId(rs.getInt("owner_id"));
            hotel.setStatus(rs.getString("status"));
        }
        connection.close();
        return hotel;
    }

    public List<Hotel> getAllApprovedHotels() throws SQLException {
        List<Hotel> hotels = new ArrayList<>();
        Connection conn = getConnection();
        if (conn == null) return hotels;

        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM hotels WHERE status = 'APPROVED'");
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            Hotel hotel = new Hotel();
            hotel.setId(rs.getInt("id"));
            hotel.setName(rs.getString("name"));
            hotel.setCity(rs.getString("city"));
            hotel.setAddress(rs.getString("address"));
            hotel.setDescription(rs.getString("description"));
            hotel.setStarRating(rs.getInt("star_rating"));
            hotel.setOwnerId(rs.getInt("owner_id"));
            hotel.setStatus(rs.getString("status"));
            hotel.setImageUrl(rs.getString("image_url"));
            hotels.add(hotel);
        }
        conn.close();
        return hotels;
    }
}
