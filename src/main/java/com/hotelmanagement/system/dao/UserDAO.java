package com.hotelmanagement.system.dao;

import com.hotelmanagement.system.model.Admin;
import com.hotelmanagement.system.model.Customer;
import com.hotelmanagement.system.model.HotelOwner;
import com.hotelmanagement.system.model.User;
import java.sql.*;

import static com.hotelmanagement.system.util.DBConnection.getConnection;

public class UserDAO {

    public User authenticate(String email, String password) throws SQLException {
        Connection conn = getConnection();
        if (conn == null) return null;

        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE email = ? AND password = ?");
        stmt.setString(1, email);
        stmt.setString(2, password);

        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            String role = rs.getString("role");
            User user;
            if (role.equals("ADMIN")) user = new Admin();
            else if (role.equals("HOTEL_OWNER")) user = new HotelOwner();
            else user = new Customer();

            user.setId(rs.getInt("id"));
            user.setName(rs.getString("name"));
            user.setEmail(rs.getString("email"));
            user.setPhone(rs.getString("phone"));
            user.setRole(role);
            conn.close();
            return user;
        }
        conn.close();
        return null;
    }

    public boolean registerUser(User user) throws SQLException {
        Connection conn = getConnection();
        if (conn == null) return false;

        PreparedStatement stmt = conn.prepareStatement(
            "INSERT INTO users (name, email, password, phone, role) VALUES (?, ?, ?, ?, ?)"
        );
        stmt.setString(1, user.getName());
        stmt.setString(2, user.getEmail());
        stmt.setString(3, user.getPassword());
        stmt.setString(4, user.getPhone());
        stmt.setString(5, user.getRole());

        int rows = stmt.executeUpdate();
        conn.close();
        return rows > 0;
    }
}
