package com.hotelmanagement.system.model;

public class Room {
    private int id;
    private int hotelId;
    private String roomType;
    private double pricePerNight;
    private int capacity;
    private int totalRooms;
    private int availableRooms;
    private String description;
    
    // Useful for UI
    private String hotelName;

    // Constructors
    public Room() {
    }

    public Room(int hotelId, String roomType, double pricePerNight, int capacity, int totalRooms, int availableRooms, String description) {
        this.hotelId = hotelId;
        this.roomType = roomType;
        this.pricePerNight = pricePerNight;
        this.capacity = capacity;
        this.totalRooms = totalRooms;
        this.availableRooms = availableRooms;
        this.description = description;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getHotelId() { return hotelId; }
    public void setHotelId(int hotelId) { this.hotelId = hotelId; }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public double getPricePerNight() { return pricePerNight; }
    public void setPricePerNight(double pricePerNight) { this.pricePerNight = pricePerNight; }

    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }

    public int getTotalRooms() { return totalRooms; }
    public void setTotalRooms(int totalRooms) { this.totalRooms = totalRooms; }

    public int getAvailableRooms() { return availableRooms; }
    public void setAvailableRooms(int availableRooms) { this.availableRooms = availableRooms; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getHotelName() { return hotelName; }
    public void setHotelName(String hotelName) { this.hotelName = hotelName; }
}
