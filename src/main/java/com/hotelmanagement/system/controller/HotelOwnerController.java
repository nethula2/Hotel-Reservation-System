package com.hotelmanagement.system.controller;


import com.hotelmanagement.system.dao.BookingDAO;
import com.hotelmanagement.system.dao.HotelDAO;
import com.hotelmanagement.system.dao.RoomDAO;
import com.hotelmanagement.system.model.Booking;
import com.hotelmanagement.system.model.Hotel;
import com.hotelmanagement.system.model.Room;
import com.hotelmanagement.system.model.User;
import com.hotelmanagement.system.util.SessionUtils;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PathVariable;

import java.sql.SQLException;
import java.util.List;

@Controller
public class HotelOwnerController {

    // GET — dashboard
    @GetMapping("/hotelowner/home")
    public String hotelOwnerHomePage(HttpSession session) {
        if (!SessionUtils.isLoggedIn(session)) return "redirect:/login";
        if (!SessionUtils.hasRole(session, "HOTEL_OWNER")) return "redirect:/login";
        return "hotelowner-home";
    }

    // GET — my hotels list
    @GetMapping("/hotelowner/hotels")
    public String hotelOwnerHotelsPage(HttpSession session, Model model) throws SQLException {
        if (!SessionUtils.isLoggedIn(session)) return "redirect:/login";
        if (!SessionUtils.hasRole(session, "HOTEL_OWNER")) return "redirect:/login";

        User owner = SessionUtils.getLoggedInUser(session);
        HotelDAO dao = new HotelDAO();
        List<Hotel> hotels = dao.getHotelsByOwnerId(owner.getId());
        model.addAttribute("hotels", hotels);
        return "hotelowner-hotels";
    }

    // GET — add hotel form
    @GetMapping("/hotelowner/add-hotel")
    public String hotelOwnerAddHotelPage(HttpSession session) {
        if (!SessionUtils.isLoggedIn(session)) return "redirect:/login";
        if (!SessionUtils.hasRole(session, "HOTEL_OWNER")) return "redirect:/login";
        return "hotelowner-add-hotel";
    }

    // POST — submit new hotel
    @PostMapping("/hotelowner/add-hotel")
    public String addHotel(
            HttpSession session,
            @RequestParam String name,
            @RequestParam String city,
            @RequestParam String address,
            @RequestParam String description,
            @RequestParam int starRating,
            @RequestParam(required = false) String imageUrl,
            Model model) throws SQLException {

        if (!SessionUtils.isLoggedIn(session)) return "redirect:/login";
        if (!SessionUtils.hasRole(session, "HOTEL_OWNER")) return "redirect:/login";

        User owner = SessionUtils.getLoggedInUser(session);

        Hotel newHotel = new Hotel(name, city, address, description, starRating);
        newHotel.setOwnerId(owner.getId());
        newHotel.setImageUrl(imageUrl);

        HotelDAO dao = new HotelDAO();
        boolean success = dao.addHotel(newHotel);

        if (success) return "redirect:/hotelowner/hotels";

        model.addAttribute("error", "Failed to add hotel. Please try again.");
        return "hotelowner-add-hotel";
    }

    // GET — view booking requests
    @GetMapping("/hotelowner/bookings")
    public String viewBookingRequests(HttpSession session, Model model) throws SQLException {
        if (!SessionUtils.isLoggedIn(session)) return "redirect:/login";
        if (!SessionUtils.hasRole(session, "HOTEL_OWNER")) return "redirect:/login";

        User owner = SessionUtils.getLoggedInUser(session);
        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> bookings = bookingDAO.getBookingsByOwnerId(owner.getId());
        model.addAttribute("bookings", bookings);
        return "hotelowner-bookings";
    }

    // GET — confirm booking
    @GetMapping("/hotelowner/booking/confirm/{id}")
    public String confirmBooking(
            @PathVariable int id,
            HttpSession session) throws SQLException {

        if (!SessionUtils.isLoggedIn(session)) return "redirect:/login";
        if (!SessionUtils.hasRole(session, "HOTEL_OWNER")) return "redirect:/login";

        BookingDAO bookingDAO = new BookingDAO();
        Booking booking = bookingDAO.getBookingById(id);

        if (booking != null) {
            bookingDAO.updateBookingStatus(id, "CONFIRMED");
        }

        return "redirect:/hotelowner/bookings";
    }

    // GET — reject booking
    @GetMapping("/hotelowner/booking/reject/{id}")
    public String rejectBooking(
            @PathVariable int id,
            HttpSession session) throws SQLException {

        if (!SessionUtils.isLoggedIn(session)) return "redirect:/login";
        if (!SessionUtils.hasRole(session, "HOTEL_OWNER")) return "redirect:/login";

        BookingDAO bookingDAO = new BookingDAO();
        bookingDAO.updateBookingStatus(id, "REJECTED");

        return "redirect:/hotelowner/bookings";
    }

    // GET — edit hotel form
    @GetMapping("/hotelowner/edit-hotel/{id}")
    public String editHotelPage(
            @PathVariable int id,
            HttpSession session,
            Model model) throws SQLException {

        if (!SessionUtils.isLoggedIn(session)) return "redirect:/login";
        if (!SessionUtils.hasRole(session, "HOTEL_OWNER")) return "redirect:/login";

        HotelDAO hotelDAO = new HotelDAO();
        Hotel hotel = hotelDAO.getHotelById(id);
        model.addAttribute("hotel", hotel);
        return "hotelowner-edit-hotel";
    }

    // POST — save hotel edits
    @PostMapping("/hotelowner/edit-hotel/{id}")
    public String updateHotel(
            @PathVariable int id,
            @RequestParam String name,
            @RequestParam String city,
            @RequestParam String address,
            @RequestParam String description,
            @RequestParam int starRating,
            @RequestParam(required = false) String imageUrl,
            HttpSession session,
            Model model) throws SQLException {

        if (!SessionUtils.isLoggedIn(session)) return "redirect:/login";
        if (!SessionUtils.hasRole(session, "HOTEL_OWNER")) return "redirect:/login";

        HotelDAO hotelDAO = new HotelDAO();
        boolean success = hotelDAO.updateHotel(id, name, city, address, description, starRating, imageUrl);

        if (success) return "redirect:/hotelowner/hotels";

        model.addAttribute("error", "Update failed. Please try again.");
        Hotel hotel = hotelDAO.getHotelById(id);
        model.addAttribute("hotel", hotel);
        return "hotelowner-edit-hotel";
    }
}