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
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

@Controller
public class ReservationController {

    private final HotelDAO hotelDAO = new HotelDAO();
    private final RoomDAO roomDAO = new RoomDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

    private final String UPLOAD_DIR = "src/main/webapp/uploads/payments/";

    @GetMapping("/hotels")
    public String browseHotels(HttpSession session, Model model) throws SQLException {
        if (!SessionUtils.isLoggedIn(session)) return "redirect:/login";
        
        List<Hotel> hotels = hotelDAO.getAllApprovedHotels();
        model.addAttribute("hotels", hotels);
        return "hotels";
    }

    @GetMapping("/reservation")
    public String showReservationPage(@RequestParam int hotelId, 
                                    @RequestParam(required = false) Integer roomId,
                                    HttpSession session, Model model) throws SQLException {
        User user = SessionUtils.getLoggedInUser(session);
        if (user == null) return "redirect:/login";

        Hotel hotel = hotelDAO.getHotelById(hotelId);
        List<Room> rooms = roomDAO.getRoomsByHotelId(hotelId);

        model.addAttribute("hotel", hotel);
        model.addAttribute("rooms", rooms);
        model.addAttribute("customer", user);
        model.addAttribute("selectedRoomId", roomId);

        return "reservation";
    }

    @PostMapping("/reservation/submit")
    public String handleReservation(@RequestParam int hotelId,
                                  @RequestParam int roomId,
                                  @RequestParam String checkIn,
                                  @RequestParam String checkOut,
                                  @RequestParam int nights,
                                  @RequestParam double totalPrice,
                                  @RequestParam int guests,
                                  @RequestParam String nicPassport,
                                  @RequestParam String country,
                                  @RequestParam String specialRequests,
                                  @RequestParam("paymentSlip") MultipartFile file,
                                  HttpSession session, Model model) throws SQLException, IOException {
        
        User user = SessionUtils.getLoggedInUser(session);
        if (user == null) return "redirect:/login";

        String fileName = "slip_" + System.currentTimeMillis() + "_" + file.getOriginalFilename();
        Path path = Paths.get(UPLOAD_DIR + fileName);
        Files.createDirectories(path.getParent());
        Files.write(path, file.getBytes());

        Booking booking = new Booking();
        booking.setCustomerId(user.getId());
        booking.setHotelId(hotelId);
        booking.setRoomId(roomId);
        booking.setCheckIn(Date.valueOf(checkIn));
        booking.setCheckOut(Date.valueOf(checkOut));
        booking.setNights(nights);
        booking.setTotalPrice(totalPrice);
        booking.setGuests(guests);
        booking.setNicPassport(nicPassport);
        booking.setCountry(country);
        booking.setSpecialRequests(specialRequests);
        booking.setPaymentSlipUrl("/uploads/payments/" + fileName);
        booking.setStatus("PENDING_VERIFICATION");

        if (bookingDAO.insertBooking(booking)) {
            model.addAttribute("booking", booking);
            return "reservation-success";
        } else {
            model.addAttribute("error", "Failed to submit reservation. Please try again.");
            return "reservation";
        }
    }

    @GetMapping("/customer/reservations")
    public String viewCustomerReservations(HttpSession session, Model model) throws SQLException {
        User user = SessionUtils.getLoggedInUser(session);
        if (user == null) return "redirect:/login";

        List<Booking> bookings = bookingDAO.getBookingsByCustomerId(user.getId());
        model.addAttribute("bookings", bookings);
        return "customer-reservations";
    }

    @GetMapping("/admin/reservations")
    public String viewAllReservations(HttpSession session, Model model) throws SQLException {
        if (!SessionUtils.hasRole(session, "ADMIN")) return "redirect:/login";

        List<Booking> bookings = bookingDAO.getAllBookings();
        model.addAttribute("bookings", bookings);
        return "admin-reservations";
    }

    @PostMapping("/admin/reservation/status")
    public String updateStatus(@RequestParam int bookingId, @RequestParam String status, HttpSession session) throws SQLException {
        if (!SessionUtils.hasRole(session, "ADMIN")) return "redirect:/login";
        bookingDAO.updateBookingStatus(bookingId, status);
        return "redirect:/admin/reservations";
    }
}
