package com.hotelmanagement.system.model;

public class LuxuryRoom extends Room {
    private boolean hasPremiumService;

    public LuxuryRoom() {
        super();
        this.hasPremiumService = true;
    }

    public boolean isHasPremiumService() {
        return hasPremiumService;
    }

    public void setHasPremiumService(boolean hasPremiumService) {
        this.hasPremiumService = hasPremiumService;
    }

    @Override
    public String toString() {
        return "LuxuryRoom: " + getRoomType() + " with Premium Service";
    }
}
