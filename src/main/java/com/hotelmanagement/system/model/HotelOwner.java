package com.hotelmanagement.system.model;

public class HotelOwner extends User {
    public HotelOwner() {
        super();
        setRole("HOTEL_OWNER");
    }

    public HotelOwner(String name, String email, String password, String phone) {
        super(name, email, password, phone, "HOTEL_OWNER");
    }

    @Override
    public String getUserHomePageUrl(){
        return "/hotelowner/home";
    }
}
