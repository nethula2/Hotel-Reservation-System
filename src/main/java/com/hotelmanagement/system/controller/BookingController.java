package com.hotelmanagement.system.controller;

import com.hotelmanagement.system.dao.BookingDAO;
import com.hotelmanagement.system.dao.HotelDAO;
import com.hotelmanagement.system.dao.RoomDAO;
import com.hotelmanagement.system.model.Booking;
import com.hotelmanagement.system.model.Hotel;
import com.hotelmanagement.system.model.Room;
import com.hotelmanagement.system.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

@Controller
public class BookingController {

    private final HotelDAO hotelDAO = new HotelDAO();
    private final RoomDAO roomDAO = new RoomDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

    @GetMapping("/rooms/search")
    public String searchRooms(Model model) throws SQLException {
        List<Hotel> hotels = hotelDAO.getAllApprovedHotels();
        model.addAttribute("hotels", hotels);
        return "room-search";
    }

    @GetMapping("/hotel/{id}/rooms")
    public String viewHotelRooms(@PathVariable int id, Model model) throws SQLException {
        List<Room> rooms = roomDAO.getRoomsByHotelId(id);
        model.addAttribute("rooms", rooms);
        model.addAttribute("hotelId", id);
        return "room-details";
    }

    @GetMapping("/book/{roomId}")
    public String showBookingForm(@PathVariable int roomId, HttpSession session, Model model) throws SQLException {
        Object loggedUser = session.getAttribute("loggedUser");
        if (loggedUser == null) return "redirect:/login";

        Room room = roomDAO.getRoomById(roomId);
        model.addAttribute("room", room);
        return "booking-form";
    }

    @PostMapping("/book/confirm")
    public String processBooking(
            @RequestParam int roomId,
            @RequestParam int hotelId,
            @RequestParam Date checkIn,
            @RequestParam Date checkOut,
            @RequestParam int nights,
            @RequestParam double totalPrice,
            HttpSession session,
            Model model
    ) throws SQLException {
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) return "redirect:/login";

        Booking booking = new Booking();
        booking.setCustomerId(user.getId());
        booking.setHotelId(hotelId);
        booking.setRoomId(roomId);
        booking.setCheckIn(checkIn);
        booking.setCheckOut(checkOut);
        booking.setNights(nights);
        booking.setTotalPrice(totalPrice);
        booking.setStatus("PENDING");

        boolean success = bookingDAO.createBooking(booking);
        if (success) {
            roomDAO.updateRoomAvailability(roomId, -1);
            return "booking-confirmation";
        } else {
            model.addAttribute("error", "Booking failed. Please try again.");
            return "redirect:/book/" + roomId;
        }
    }
}
