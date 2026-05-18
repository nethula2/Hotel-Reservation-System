package com.hotelmanagement.system.controller;

import com.hotelmanagement.system.dao.CustomerDAO;
import com.hotelmanagement.system.model.Customer;
import com.hotelmanagement.system.model.User;
import com.hotelmanagement.system.util.SessionUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import com.hotelmanagement.system.dao.BookingDAO;
import com.hotelmanagement.system.model.Booking;
import java.util.ArrayList;
import java.util.List;

@Controller
public class CustomerController {

    private final CustomerDAO customerDAO = new CustomerDAO();

    // GET: Display Customer Home Page
    @GetMapping("/customer/home")
    public String customerHomePage(HttpSession session, Model model) {
        if (!SessionUtils.isLoggedIn(session)) return "redirect:/login";

        User customer = SessionUtils.getLoggedInUser(session);
        model.addAttribute("customer", customer);
        return "customer-home";
    }

    // GET: Show Update Form
    @GetMapping("/customer/update")
    public String showUpdateForm(HttpSession session, Model model) {
        if (!SessionUtils.isLoggedIn(session)) return "redirect:/login";

        User customer = SessionUtils.getLoggedInUser(session);
        model.addAttribute("customer", customer);
        return "customer-update";
    }

    // POST: Handle Update Form Submit
    @PostMapping("/customer/update")
    public String updateCustomer(
            @RequestParam String name, //accepts the updates
            @RequestParam String email,
            @RequestParam String phone,
            HttpSession session,
            Model model) {

        if (!SessionUtils.isLoggedIn(session)) return "redirect:/login";

        User customer = SessionUtils.getLoggedInUser(session);

        try {
            boolean success = customerDAO.updateCustomer(customer.getId(), name, email, phone); //write the updates to database

            if (success) {
                // Update session with new data (after successfully wrote database)
                customer.setName(name);
                customer.setEmail(email);
                customer.setPhone(phone);
                session.setAttribute("loggedUser", customer);
                model.addAttribute("success", "Profile updated successfully!");
            } else {
                //if database writing fails
                model.addAttribute("error", "Update failed. Please try again.");
            }

        } catch (SQLException e) {
            model.addAttribute("error", "Update failed. Please try again.");
        }

        model.addAttribute("customer", customer);
        return "customer-update";
    }

    //GET: Display the Customer Support Page.
    @GetMapping("/support")
    public String supportPage(HttpSession session) {
        if (!SessionUtils.isLoggedIn(session)) return "redirect:/login";
        return "support";
    }

    //POST: Delete Customer Account - (Deactivate account)
    @PostMapping("/customer/delete")
    public String deleteOwnAccount(HttpSession session) {
        if (!SessionUtils.isLoggedIn(session)) return "redirect:/login";

        User customer = SessionUtils.getLoggedInUser(session);

        try {
            customerDAO.deleteCustomer(customer.getId());
            session.invalidate();
            return "redirect:/";
        } catch (SQLException e) {
            return "redirect:/customer/update";
        }
    }

    // GET — Display all Bookings
    @GetMapping("/reservations")
    public String myReservations(HttpSession session, Model model) throws SQLException {
        if (!SessionUtils.isLoggedIn(session)) return "redirect:/login";

        User user = SessionUtils.getLoggedInUser(session);
        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> bookings = bookingDAO.getBookingsByCustomerId(user.getId());
        model.addAttribute("bookings", bookings);
        return "my-reservations";
    }

    // GET — My Payments(Display Confirmed Bookings)
    @GetMapping("/payments")
    public String myPayments(HttpSession session, Model model) throws SQLException {
        if (!SessionUtils.isLoggedIn(session)) return "redirect:/login";

        User user = SessionUtils.getLoggedInUser(session);
        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> allBookings = bookingDAO.getBookingsByCustomerId(user.getId());

        // Filter confirmed only
        List<Booking> payments = new ArrayList<>();
        for (Booking b : allBookings) {
            if ("CONFIRMED".equals(b.getStatus())) {
                payments.add(b);
            }
        }

        model.addAttribute("payments", payments);
        return "my-payments";
    }
}