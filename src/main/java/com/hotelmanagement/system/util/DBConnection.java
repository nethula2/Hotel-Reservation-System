package com.hotelmanagement.system.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection{
    private static final String URL = "jdbc:mysql://localhost:3306/hotel_reservation";
    private static final String USER = "root";
    private static final String PASSWORD = "root1234";

    public static Connection getConnection(){
        try
        {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        }

        catch (Exception e)
        {
            System.out.println("DB Connection failed : " + e.getMessage());
            return null;
        }
    }
}