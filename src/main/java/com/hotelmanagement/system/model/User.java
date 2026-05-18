package com.hotelmanagement.system.model;

public abstract class User {
    private int id;
    private String name;
    private String email;
    private String password;
    private String phone;
    private String role;

    public User() {}

    public User(String name, String email, String password, String phone, String role) {
        this.name     = name;
        this.email    = email;
        this.password = password;
        this.phone    = phone;
        this.role     = role;
    }

    // getters
    public int    getId()       { return id; }
    public String getName()     { return name; }
    public String getEmail()    { return email; }
    public String getPassword() { return password; }
    public String getPhone()    { return phone; }
    public String getRole()     { return role; }


    // setters
    public void setId(int id)             { this.id = id; }
    public void setName(String name)      { this.name = name; }
    public void setEmail(String email)    { this.email = email; }
    public void setPassword(String pass)  { this.password = pass; }
    public void setPhone(String phone)    { this.phone = phone; }
    public void setRole(String role)      { this.role = role; }

    // abstract method
    public abstract String getUserHomePageUrl();
}
