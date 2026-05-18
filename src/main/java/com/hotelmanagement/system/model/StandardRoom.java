package com.hotelmanagement.system.model;

// inheritning all properties form room class
public class StandardRoom extends Room {
    public StandardRoom() {
        super();
    }

    //polymorphism
    @Override
    public String getTierLabel() {
        return "Standard";
    }
}