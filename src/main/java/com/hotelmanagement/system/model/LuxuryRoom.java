package com.hotelmanagement.system.model;

//inheriting all properties and methods from  Room class
public class LuxuryRoom extends Room {
    
    // new pro
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

    //Changing the behavior of the toString method from the Object class
    @Override
    public String toString() {
        return "This is a Luxury Room of type: " + getRoomType();
    }
}
