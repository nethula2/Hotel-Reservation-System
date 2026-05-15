package com.hotelmanagement.system.controller;

import com.hotelmanagement.system.dao.BookingDAO;
import com.hotelmanagement.system.dao.HotelDAO;
import com.hotelmanagement.system.model.Booking;
import com.hotelmanagement.system.model.Hotel;
import com.hotelmanagement.system.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.sql.SQLException;
import java.util.List;

@Controller
public class HotelOwnerController {
    @GetMapping("/hotelowner/home")
    public String hotelOwnerHomePage(HttpSession session){
        Object loggedInUser = session.getAttribute("loggedUser");

        if (loggedInUser == null) { return "redirect:/login"; }

        return "hotelowner-home";
    }

    @GetMapping("/hotelowner/hotels")
    public String hotelOwnerHotelsPage(HttpSession session, Model model) throws SQLException {
        Object loggedInUserObj = session.getAttribute("loggedUser");

        if (loggedInUserObj == null) {
            return "redirect:/login";
        }

        User loggedInUser = (User) loggedInUserObj;

        HotelDAO dao = new HotelDAO();
        List<Hotel> hotels = dao.getHotelsByOwnerId(loggedInUser.getId());

        model.addAttribute("hotels", hotels);

        return "hotelowner-hotels";
    }

    @GetMapping("/hotelowner/add-hotel")
    public String hotelOwnerAddHotelPage(HttpSession session){
        Object loggedInUserObj = session.getAttribute("loggedUser");

        if (loggedInUserObj == null) {
            return "redirect:/login";
        }
        return "hotelowner-add-hotel";
    }

    @PostMapping("/hotelowner/add-hotel")
    public String addHotelPage(
            HttpSession session,
            @RequestParam String name,
            @RequestParam String city,
            @RequestParam String address,
            @RequestParam String description,
            @RequestParam int starRating,
            Model model
    ) throws SQLException {

        Object loggedInUserObj = session.getAttribute("loggedUser");

        if (loggedInUserObj == null) {
            return "redirect:/login";
        }

        User loggedInUser = (User) loggedInUserObj;

        Hotel newHotel = new Hotel(name, city, address, description, starRating);
        newHotel.setOwnerId(loggedInUser.getId());

        HotelDAO dao = new HotelDAO();

        boolean state = dao.addHotel(newHotel);
        if (state) { return "redirect:/hotelowner/home";}

        else {
            model.addAttribute("error", "Registration Failed");
            return "hotelowner-add-hotel";
        }
    }

    @GetMapping("/hotelowner/bookings")
    public String hotelOwnerBookingsPage(HttpSession session, Model model) throws SQLException {
        Object loggedInUserObj = session.getAttribute("loggedUser");

        if (loggedInUserObj == null) {
            return "redirect:/login";
        }

        User loggedInUser = (User) loggedInUserObj;
        BookingDAO dao = new BookingDAO();
        List<Booking> bookings = dao.getBookingsByOwnerId(loggedInUser.getId());

        model.addAttribute("bookings", bookings);

        return "hotelowner-bookings";
    }

    @GetMapping("/hotelowner/booking/confirm/{id}")
    public String confirmBooking(@PathVariable int id) throws SQLException {
        BookingDAO dao = new BookingDAO();
        dao.updateBookingStatus(id, "CONFIRMED");
        return "redirect:/hotelowner/bookings";
    }

    @GetMapping("/hotelowner/booking/reject/{id}")
    public String rejectBooking(@PathVariable int id) throws SQLException {
        BookingDAO dao = new BookingDAO();
        dao.updateBookingStatus(id, "REJECTED");
        return "redirect:/hotelowner/bookings";
    }
}
