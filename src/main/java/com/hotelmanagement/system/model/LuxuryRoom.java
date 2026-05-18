package com.hotelmanagement.system.model;

// inheriting all properties from room class
public class LuxuryRoom extends Room {
    private boolean hasPremiumService;

    public LuxuryRoom() {
        super();
        this.hasPremiumService = true;
    }

    @Override
    public String getTierLabel() {
        return "Luxury";
    }

//new attribute
    public boolean isHasPremiumService() {
        return hasPremiumService;
    }
    public void setHasPremiumService(boolean value) {
        this.hasPremiumService = value;
    }
}