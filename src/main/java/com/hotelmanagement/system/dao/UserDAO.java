package com.hotelmanagement.system.dao;

import com.hotelmanagement.system.model.Admin;
import com.hotelmanagement.system.model.Customer;
import com.hotelmanagement.system.model.HotelOwner;
import com.hotelmanagement.system.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import static com.hotelmanagement.system.util.DBConnection.getConnection;

public class UserDAO {
    public boolean checkUserEmail(String email) throws SQLException {
        Connection connection = getConnection();

        if (connection == null) {
            return false;
        }

        PreparedStatement statement = connection.prepareStatement(
                "SELECT * FROM users WHERE email = ?"
        );
        statement.setString(1, email);

        ResultSet rs = statement.executeQuery();

        boolean exists = rs.next();
        connection.close();

        return exists;
    }

    public boolean enterNewUserData(User user) throws SQLException {
        if (checkUserEmail(user.getEmail())) {
            System.out.println("Email Already Exsist");
            return false;
        }

        Connection connection = getConnection();

        if (connection == null) {
            System.out.println("Connection to Database Failed");
            return false;
        }

        PreparedStatement statement = connection.prepareStatement(
                "INSERT INTO users (name, email, password, phone, role) " +
                        "VALUES (?, ?, ?, ?, ?)"
        );

        statement.setString(1, user.getName());
        statement.setString(2, user.getEmail());
        statement.setString(3, user.getPassword());
        statement.setString(4, user.getPhone());
        statement.setString(5, user.getRole());

        int rows = statement.executeUpdate();

        connection.close();

        return rows > 0;
    }

    public User loginUser(String email, String password) throws SQLException {
        Connection connection = getConnection();
        if (connection == null) return null;

        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";

        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setString(1, email);
        statement.setString(2, password);

        ResultSet rs = statement.executeQuery();

        if (rs.next()) {
            String role = rs.getString("role");
            User user;

            switch (role) {
                case "CUSTOMER":
                    user = new Customer();
                    break;

                case "ADMIN":
                    user = new Admin();
                    break;

                case "HOTEL_OWNER":
                    user = new HotelOwner();
                    break;

                default:
                    connection.close();
                    return null;
            }

            user.setId(rs.getInt("id"));
            user.setName(rs.getString("name"));
            user.setEmail(rs.getString("email"));
            user.setPhone(rs.getString("phone"));

            // If account was deactivated this is to reactivate it on login
            if (!rs.getBoolean("is_active")) {
                reactivateUser(user.getId(), connection);
            }


            connection.close();
            return user;
        }
        connection.close();
        return null;
    }

    private void reactivateUser(int id, Connection connection) {
        try {
            PreparedStatement ps = connection.prepareStatement(
                    "UPDATE users SET is_active = true WHERE id = ?"
            );
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Failed to reactivate user: " + e.getMessage());
        }
    }
}