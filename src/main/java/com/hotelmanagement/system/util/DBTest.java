package com.hotelmanagement.system.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class DBTest {
    public static void main(String[] args) {
        Connection connection = DBConnection.getConnection();

        if (connection != null)
        {
            System.out.println("Database connected successfully...!");

            try
            {
                Statement stmt = connection.createStatement();

                // to get the details of the users table
                ResultSet rs = stmt.executeQuery("SELECT * FROM users");
                while (rs.next()) {
                    System.out.println("Found user : " + rs.getString("name")
                            + " AND Role: " + rs.getString("role"));
                }
                connection.close();
            }

            catch (Exception e)
            {
                System.out.println("Query error : " + e.getMessage());
            }
        }

        else {
            System.out.println("Connection failed.");
        }
    }
}