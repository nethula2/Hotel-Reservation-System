package com.hotelmanagement.system.model;

//creating parent class for room management

public abstract class Room {

  //implementing private attributes
    private int    id;
    private int    hotelId;
    private String roomNumber;
    private int    floor;
    private String roomType;
    private String roomTier;
    private double pricePerNight;
    private int    capacity;
    private String status;
    private String description;
    private String imageUrl;
    private String createdAt;

    //extra attribute
    private String hotelName;

    public Room() {}

 //creating abstract method for child classes
    public abstract String getTierLabel();

//creating getter and setter to access above private variables
    public int getId() {
        return id; }
    public void setId(int id) {
        this.id = id; }

    public int getHotelId() {
        return hotelId; }
    public void setHotelId(int hotelId) {
        this.hotelId = hotelId; }

    public String getRoomNumber() {
        return roomNumber; }
    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber; }

    public int getFloor() {
        return floor; }
    public void setFloor(int floor) {
        this.floor = floor; }

    public String getRoomType() {
        return roomType; }
    public void setRoomType(String roomType) {
        this.roomType = roomType; }

    public String getRoomTier() {
        return roomTier; }
    public void setRoomTier(String roomTier) {
        this.roomTier = roomTier; }

    public double getPricePerNight() {
        return pricePerNight; }
    public void setPricePerNight(double price) {
        this.pricePerNight = price; }

    public int getCapacity() {
        return capacity; }
    public void setCapacity(int capacity) {
        this.capacity = capacity; }

    public String getStatus() {
        return status; }
    public void setStatus(String status) {
        this.status = status; }

    public String getDescription() {
        return description; }
    public void setDescription(String desc) {
        this.description = desc; }

    public String getImageUrl() {
        return imageUrl; }
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl; }

    public String getCreatedAt() {
        return createdAt; }
    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt; }

    public String getHotelName() {
        return hotelName; }
    public void setHotelName(String hotelName) {
        this.hotelName = hotelName; }
}