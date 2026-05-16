package com.hotelmanagement.system.controller;

import com.hotelmanagement.system.dao.UserDAO;
import com.hotelmanagement.system.model.Admin;
import com.hotelmanagement.system.model.Customer;
import com.hotelmanagement.system.model.HotelOwner;
import com.hotelmanagement.system.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.sql.SQLException;

@Controller
public class AuthController {

    private final UserDAO userDAO = new UserDAO();

    @GetMapping("/login")
    public String showLoginPage() {
        return "login";
    }

    @PostMapping("/login")
    public String processLogin(@RequestParam String email, 
                             @RequestParam String password, 
                             HttpSession session, 
                             Model model) throws SQLException {
        User user = userDAO.authenticate(email, password);

        if (user != null) {
            session.setAttribute("loggedUser", user);
            return "redirect:" + user.getUserHomePageUrl();
        } else {
            model.addAttribute("error", "Invalid email or password");
            return "login";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }

    @GetMapping("/register")
    public String showRegisterPage() {
        return "register-customer";
    }

    @PostMapping("/register")
    public String processRegistration(@RequestParam String name,
                                    @RequestParam String email,
                                    @RequestParam String password,
                                    @RequestParam String phone,
                                    @RequestParam(defaultValue = "CUSTOMER") String role) throws SQLException {
        User newUser;
        if (role.equals("ADMIN")) newUser = new Admin(name, email, password, phone);
        else if (role.equals("HOTEL_OWNER")) newUser = new HotelOwner(name, email, password, phone);
        else newUser = new Customer(name, email, password, phone);

        if (userDAO.registerUser(newUser)) {
            return "redirect:/login?registered=true";
        } else {
            return "redirect:/register?error=true";
        }
    }
}
