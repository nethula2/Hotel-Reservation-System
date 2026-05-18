package com.hotelmanagement.system.dao;

import com.hotelmanagement.system.model.Customer;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import static com.hotelmanagement.system.util.DBConnection.getConnection;

public class CustomerDAO {

    //READ: Find a single customer by their ID
    public Customer getCustomerById(int id) throws SQLException{
        Connection connection = getConnection();
        if(connection == null) return null;

        PreparedStatement statement = connection.prepareStatement(
                "SELECT * FROM users WHERE id = ? AND role = 'CUSTOMER'"
        );
        statement.setInt(1, id);

        ResultSet rs = statement.executeQuery();

        Customer customer = null;
        if(rs.next()){ //if matching found moves cursor forward
            customer = buildCustomerFromResultSet(rs);
        }

        connection.close();
        return customer;
    }

    //READ: Find customer by email
    public Customer getCustomerByEmail(String email) throws SQLException{
        Connection connection = getConnection();
        if(connection == null) return null;

        PreparedStatement statement = connection.prepareStatement(
                "SELECT * FROM users WHERE email = ? AND role = 'CUSTOMER'" //role = CUSTOMER - to prevent accidents
        );
        statement.setString(1, email);

        ResultSet rs = statement.executeQuery();

        Customer customer = null;
        if(rs.next()){
            customer = buildCustomerFromResultSet(rs);
        }

        connection.close();
        return customer;
    }

    //READ: Get All customers (for admin list page)
    public List<Customer> getAllCustomers() throws SQLException {
        Connection connection = getConnection();
        if(connection == null) return new ArrayList<>();

        PreparedStatement statement = connection.prepareStatement(
                "SELECT * FROM users WHERE role = 'CUSTOMER'"
        );

        ResultSet rs = statement.executeQuery();
        List<Customer> customers = new ArrayList<>();

        while(rs.next()){ //converts the SQL data into a Customer object and adds it to an ArrayList
            customers.add(buildCustomerFromResultSet(rs));
        }

        connection.close();
        return customers;
    }

    //UPDATE: Modify customer's name,email, or phone
    public boolean updateCustomer(int id,String name,String email,String phone) throws SQLException{
        Connection connection = getConnection();
        if(connection == null) return false;

        PreparedStatement statement = connection.prepareStatement(
                "UPDATE users SET name = ?, email = ?, phone = ? WHERE id = ? AND role = 'CUSTOMER'"
        );
        statement.setString(1, name);
        statement.setString(2, email);
        statement.setString(3, phone);
        statement.setInt(4, id);

        int rows = statement.executeUpdate(); //returns integer representing how many database were changed
        connection.close();

        return rows > 0;

    }

    //DELETE: Remove a customer by ID (Deactivate the account without deleting)
    public boolean deleteCustomer(int id) throws SQLException{
        Connection connection = getConnection();
        if(connection == null) return false;

        PreparedStatement statement = connection.prepareStatement(
                "UPDATE users SET is_active = false WHERE id = ? AND role = 'CUSTOMER'"
        );
        statement.setInt(1, id);

        int rows = statement.executeUpdate();
        connection.close();

        return rows > 0;
    }

    //Helper method: builds the right Customer subclass from a DB row
    private Customer buildCustomerFromResultSet(ResultSet rs) throws SQLException{
        Customer customer = new Customer();

        customer.setId(rs.getInt("id"));
        customer.setName(rs.getString("name"));
        customer.setEmail(rs.getString("email"));
        customer.setPhone(rs.getString("phone"));
        customer.setRole(rs.getString("role"));

        return customer;
    }
}