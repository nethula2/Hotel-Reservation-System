package com.hotelmanagement.system.controller;

import com.hotelmanagement.system.dao.CustomerDAO;
import com.hotelmanagement.system.dao.HotelDAO;
import com.hotelmanagement.system.dao.UserManagementDAO;
import com.hotelmanagement.system.model.Customer;
import com.hotelmanagement.system.model.Hotel;
import com.hotelmanagement.system.model.User;
import com.hotelmanagement.system.util.SessionUtils;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.sql.SQLException;
import java.util.List;

@Controller
public class AdminController {
    @GetMapping("/admin/home")
    public String adminHomePage(HttpSession session) {
        if (!SessionUtils.isLoggedIn(session))        return "redirect:/login";
        if (!SessionUtils.hasRole(session, "ADMIN"))  return "redirect:/login";
        return "admin-home";
    }

    @GetMapping("/admin/pending-hotels")
    public String pendingHotelPage(HttpSession session, Model model) throws SQLException {
        if (!SessionUtils.isLoggedIn(session))        return "redirect:/login";
        if (!SessionUtils.hasRole(session, "ADMIN"))  return "redirect:/login";

        HotelDAO dao = new HotelDAO();
        List<Hotel> hotels = dao.getPendingHotels();
        model.addAttribute("hotels", hotels);
        return "admin-pending-hotels";
    }

    @PostMapping("/admin/hotel/approve")
    public String approvedHotels(HttpSession session, @RequestParam int hotelId) throws SQLException {
        if (!SessionUtils.isLoggedIn(session))        return "redirect:/login";
        if (!SessionUtils.hasRole(session, "ADMIN"))  return "redirect:/login";

        HotelDAO dao = new HotelDAO();
        dao.updateHotelStatus(hotelId, "APPROVED");
        return "redirect:/admin/pending-hotels";
    }

    @PostMapping("/admin/hotel/reject")
    public String rejectedHotels(HttpSession session, @RequestParam int hotelId) throws SQLException {
        if (!SessionUtils.isLoggedIn(session))        return "redirect:/login";
        if (!SessionUtils.hasRole(session, "ADMIN"))  return "redirect:/login";

        HotelDAO dao = new HotelDAO();
        dao.updateHotelStatus(hotelId, "REJECTED");
        return "redirect:/admin/pending-hotels";
    }

    // GET — view all customers
    @GetMapping("/admin/customers")
    public String listAllCustomers(HttpSession session, Model model) {
        if (!SessionUtils.isLoggedIn(session))       return "redirect:/login";
        if (!SessionUtils.hasRole(session, "ADMIN")) return "redirect:/login";

        try {
            UserManagementDAO dao = new UserManagementDAO();
            List<User> customers = dao.getAllCustomers();
            model.addAttribute("customers", customers);
        } catch (SQLException e) {
            model.addAttribute("error", "Could not load customers.");
        }
        return "customer-list";
    }

    // POST — permanently delete a customer (admin only)
    @PostMapping("/admin/customer/delete")
    public String deleteCustomer(@RequestParam int id, HttpSession session) {
        if (!SessionUtils.isLoggedIn(session))       return "redirect:/login";
        if (!SessionUtils.hasRole(session, "ADMIN")) return "redirect:/login";

        try {
            UserManagementDAO dao = new UserManagementDAO();
            dao.permanentlyDeleteCustomer(id);
        } catch (SQLException e) {
            System.out.println("Permanent delete failed: " + e.getMessage());
        }
        return "redirect:/admin/customers";
    }

    // GET — view all hotel owners
    @GetMapping("/admin/hotelowners")
    public String listAllHotelOwners(HttpSession session, Model model) {
        if (!SessionUtils.isLoggedIn(session))       return "redirect:/login";
        if (!SessionUtils.hasRole(session, "ADMIN")) return "redirect:/login";

        try {
            UserManagementDAO dao = new UserManagementDAO();
            List<User> owners = dao.getAllHotelOwners();
            model.addAttribute("owners", owners);
        } catch (SQLException e) {
            model.addAttribute("error", "Could not load hotel owners.");
        }
        return "hotelowner-list";
    }

    // POST — permanently delete a hotel owner
    @PostMapping("/admin/hotelowner/delete")
    public String deleteHotelOwner(@RequestParam int id, HttpSession session) {
        if (!SessionUtils.isLoggedIn(session))       return "redirect:/login";
        if (!SessionUtils.hasRole(session, "ADMIN")) return "redirect:/login";

        try {
            UserManagementDAO dao = new UserManagementDAO();
            dao.deleteHotelOwner(id);
        } catch (SQLException e) {
            System.out.println("Delete failed: " + e.getMessage());
        }
        return "redirect:/admin/hotelowners";
    }
}
