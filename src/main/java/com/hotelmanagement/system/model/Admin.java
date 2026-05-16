package com.hotelmanagement.system.model;

public class Admin extends User {
    public Admin() {
        super();
        setRole("ADMIN");
    }

    public Admin(String name, String email, String password, String phone) {
        super(name, email, password, phone, "ADMIN");
    }

    @Override
    public String getUserHomePageUrl(){
        return "/admin/home";
    }
}
