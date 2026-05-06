package com.hotelmanagement.system.model;

import java.sql.Date;

public class Booking {
    private int id;
    private int customerId;
    private int hotelId;
    private int roomId;
    private Date checkIn;
    private Date checkOut;
    private int nights;
    private double totalPrice;
    private String status;

    // vars that not in the bookings table
    private String customerName;
    private String hotelName;
    private String roomType;


    // getters
    public int    getId()            { return id; }
    public int    getCustomerId()    { return customerId; }
    public int    getHotelId()       { return hotelId; }
    public int    getRoomId()        { return roomId; }
    public Date   getCheckIn()       { return checkIn; }
    public Date   getCheckOut()      { return checkOut; }
    public int    getNights()        { return nights; }
    public double getTotalPrice()    { return totalPrice; }
    public String getStatus()        { return status; }

    public String getCustomerName()  { return customerName; }
    public String getHotelName()     { return hotelName; }
    public String getRoomType()      { return roomType; }


    // setters
    public void setId(int id)                        { this.id = id; }
    public void setCustomerId(int customerId)        { this.customerId = customerId; }
    public void setHotelId(int hotelId)              { this.hotelId = hotelId; }
    public void setRoomId(int roomId)                { this.roomId = roomId; }
    public void setCheckIn(Date checkIn)             { this.checkIn = checkIn; }
    public void setCheckOut(Date checkOut)           { this.checkOut = checkOut; }
    public void setNights(int nights)                { this.nights = nights; }
    public void setTotalPrice(double totalPrice)     { this.totalPrice = totalPrice; }
    public void setStatus(String status)             { this.status = status; }

    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public void setHotelName(String hotelName)       { this.hotelName = hotelName; }
    public void setRoomType(String roomType)         { this.roomType = roomType; }
}
