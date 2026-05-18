package com.hotelmanagement.system.controller;

import com.hotelmanagement.system.dao.UserDAO;
import com.hotelmanagement.system.model.Customer;
import com.hotelmanagement.system.model.HotelOwner;
import com.hotelmanagement.system.model.User;
import com.hotelmanagement.system.util.SessionUtils;
import com.hotelmanagement.system.util.SessionUtils;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import java.sql.SQLException;


@Controller
public class AuthController {

    @GetMapping ("/")
    public String homePage(){
        return "index";
    }

    @GetMapping("/login")
    public String loginPage(){
        return "login";
    }

    @PostMapping("/login")
    public String userLoginAuth(
            @RequestParam String email,
            @RequestParam String password,
            HttpSession session,
            Model model
    ) throws SQLException {
        UserDAO dao = new UserDAO();
        User user = dao.loginUser(email, password);

        if (user == null) {
            model.addAttribute("error", "Invalid email or password");
            return "login";
        }

        session.setAttribute("loggedUser", user);
        session.setAttribute("userRole", user.getRole());

        if (user.getRole().equals("CUSTOMER"))    return "redirect:/customer/home";
        if (user.getRole().equals("HOTEL_OWNER")) return "redirect:/hotelowner/home";
        if (user.getRole().equals("ADMIN"))       return "redirect:/admin/home";

        return "redirect:/login";
    }

    @GetMapping("/register")
    public String registerPage(){
        return "register";
    }

    @GetMapping("/register/customer")
    public String customerRegisterPage(){
        return "register-customer";
    }

    @PostMapping("/register/customer")
    public String registerCustomer(
            @RequestParam String name,
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam String phone,
            Model model
    ) throws SQLException {
        Customer newUser = new Customer(name, email,password, phone);
        UserDAO dao = new UserDAO();

        boolean state = dao.enterNewUserData(newUser);
        if (state) { return "redirect:/login";}

        else {
            model.addAttribute("error", "Registration Failed");
            return "register-customer";
        }
    }

    @GetMapping("/register/hotelowner")
    public String hotelOwnerRegisterPage(){
        return "register-hotelowner";
    }

    @PostMapping("/register/hotelowner")
    public String registerHotelOwner(
            @RequestParam String name,
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam String phone,
            Model model
    ) throws SQLException {
        HotelOwner newUser = new HotelOwner(name, email,password, phone);
        UserDAO dao = new UserDAO();

        boolean state = dao.enterNewUserData(newUser);
        if (state) { return "redirect:/login";}

        else {
            model.addAttribute("error", "Registration Failed");
            return "register-hotelowner";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session){

        SessionUtils.logout(session);

        return "redirect:/login";
    }



}
