package com.hotelmanagement.system.model;

// parent User class initialize any basic user properties
public class Customer extends User {
    public Customer() {
        super();
        setRole("CUSTOMER"); // automatically sets the user role
    }

    // use to create new customer
    public Customer(String name, String email, String password, String phone) {
        super(name, email, password, phone, "CUSTOMER");
    }

    @Override
    public String getUserHomePageUrl(){
        return "/customer/home"; // provide own specific homepage URL
    }
}
