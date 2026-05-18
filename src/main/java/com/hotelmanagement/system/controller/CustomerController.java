package com.hotelmanagement.system.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class CustomerController {
    @GetMapping("/customer/home")
    public String customerHomePage(){
        return "customer-home";
    }
}
