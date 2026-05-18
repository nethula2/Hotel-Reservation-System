package com.hotelmanagement.system.dao;

import com.hotelmanagement.system.model.HotelOwner;
import com.hotelmanagement.system.model.User;
import com.hotelmanagement.system.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserManagementDAO {

    public List<User> getAllHotelOwners() throws SQLException {
        Connection connection = DBConnection.getConnection();
        if (connection == null) return new ArrayList<>();

        PreparedStatement statement = connection.prepareStatement(
                "SELECT * FROM users WHERE role = 'HOTEL_OWNER'"
        );

        ResultSet rs = statement.executeQuery();
        List<User> owners = new ArrayList<>();

        while (rs.next()) {
            HotelOwner owner = new HotelOwner();
            owner.setId(rs.getInt("id"));
            owner.setName(rs.getString("name"));
            owner.setEmail(rs.getString("email"));
            owner.setPhone(rs.getString("phone"));
            owners.add(owner);
        }

        connection.close();
        return owners;
    }

    public boolean permanentlyDeleteCustomer(int id) throws SQLException {
        Connection connection = DBConnection.getConnection();
        if (connection == null) return false;

        PreparedStatement statement = connection.prepareStatement(
                "DELETE FROM users WHERE id = ? AND role = 'CUSTOMER'"
        );
        statement.setInt(1, id);

        int rows = statement.executeUpdate();
        connection.close();
        return rows > 0;
    }

    public List<User> getAllCustomers() throws SQLException {
        Connection connection = DBConnection.getConnection();
        if (connection == null) return new ArrayList<>();

        PreparedStatement statement = connection.prepareStatement(
                "SELECT * FROM users WHERE role = 'CUSTOMER'"
        );

        ResultSet rs = statement.executeQuery();
        List<User> customers = new ArrayList<>();

        while (rs.next()) {
            User customer = new com.hotelmanagement.system.model.Customer();
            customer.setId(rs.getInt("id"));
            customer.setName(rs.getString("name"));
            customer.setEmail(rs.getString("email"));
            customer.setPhone(rs.getString("phone"));
            customers.add(customer);
        }

        connection.close();
        return customers;
    }

    public boolean deleteHotelOwner(int id) throws SQLException {
        Connection connection = DBConnection.getConnection();
        if (connection == null) return false;

        PreparedStatement statement = connection.prepareStatement(
                "DELETE FROM users WHERE id = ? AND role = 'HOTEL_OWNER'"
        );
        statement.setInt(1, id);

        int rows = statement.executeUpdate();
        connection.close();
        return rows > 0;
    }
}