package com.hotelmanagement.system.model;

    public class Customer extends User{
        public Customer() {
            super();
            setRole("CUSTOMER");
        }

    public Customer(String name, String email, String password, String phone) {
        super(name, email, password, phone, "CUSTOMER");
    }

    @Override
    public String getUserHomePageUrl(){
        return "/customer/home";
    }
}
