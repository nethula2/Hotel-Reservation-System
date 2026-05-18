package com.hotelmanagement.system.controller;

import com.hotelmanagement.system.dao.BookingDAO;
import com.hotelmanagement.system.dao.RoomDAO;
import com.hotelmanagement.system.model.Booking;
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

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

@Controller
public class BookingController {

    private final RoomDAO roomDAO = new RoomDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

    // GET — show booking form
    @GetMapping("/booking/new")
    public String showBookingForm(
            @RequestParam int roomId,
            @RequestParam int hotelId,
            HttpSession session,
            Model model) throws SQLException {

        if (!SessionUtils.isLoggedIn(session)) return "redirect:/login";
        if (!SessionUtils.hasRole(session, "CUSTOMER")) return "redirect:/login";

        Room room = roomDAO.getRoomById(roomId);
        model.addAttribute("room", room);
        model.addAttribute("hotelId", hotelId);
        return "booking-form";
    }

    // POST — process booking
    @PostMapping("/booking/confirm")
    public String processBooking(
            @RequestParam int roomId,
            @RequestParam int hotelId,
            @RequestParam Date checkIn,
            @RequestParam Date checkOut,
            @RequestParam int nights,
            @RequestParam double totalPrice,
            @RequestParam(required = false) String nicPassport,
            @RequestParam(required = false) String country,
            @RequestParam(required = false) String specialRequests,
            @RequestParam(required = false) MultipartFile paymentSlip,
            HttpSession session,
            Model model) throws Exception {

        if (!SessionUtils.isLoggedIn(session)) return "redirect:/login";

        // Server-side date validation
        java.time.LocalDate today    = java.time.LocalDate.now();
        java.time.LocalDate inDate   = checkIn.toLocalDate();
        java.time.LocalDate outDate  = checkOut.toLocalDate();

        if (inDate.isBefore(today)) {
            model.addAttribute("error", "Check-in date cannot be in the past.");
            Room room = roomDAO.getRoomById(roomId);
            model.addAttribute("room", room);
            model.addAttribute("hotelId", hotelId);
            return "booking-form";
        }

        if (!outDate.isAfter(inDate)) {
            model.addAttribute("error", "Check-out date must be after check-in date.");
            Room room = roomDAO.getRoomById(roomId);
            model.addAttribute("room", room);
            model.addAttribute("hotelId", hotelId);
            return "booking-form";
        }

        User user = SessionUtils.getLoggedInUser(session);

        // Handle file upload
        String paymentSlipUrl = null;
        if (paymentSlip != null && !paymentSlip.isEmpty()) {
            String uploadDir = "uploads/payments/";
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            String fileName = System.currentTimeMillis() + "_" +
                    paymentSlip.getOriginalFilename();
            Files.copy(paymentSlip.getInputStream(),
                    Paths.get(uploadDir + fileName));
            paymentSlipUrl = uploadDir + fileName;
        }

        // Check if room is already booked for these dates
        boolean hasConflict = checkRoomConflict(roomId, checkIn, checkOut);
        if (hasConflict) {
            model.addAttribute("error", "This room is already booked for the selected dates. Please choose different dates.");
            Room room = roomDAO.getRoomById(roomId);
            model.addAttribute("room", room);
            model.addAttribute("hotelId", hotelId);
            return "booking-form";
        }

        Booking booking = new Booking();
        booking.setCustomerId(user.getId());
        booking.setHotelId(hotelId);
        booking.setRoomId(roomId);
        booking.setCheckIn(checkIn);
        booking.setCheckOut(checkOut);
        booking.setNights(nights);
        booking.setTotalPrice(totalPrice);
        booking.setNicPassport(nicPassport);
        booking.setCountry(country);
        booking.setSpecialRequests(specialRequests);
        booking.setPaymentSlipUrl(paymentSlipUrl);
        booking.setStatus("PENDING");

        boolean success = bookingDAO.insertBooking(booking);

        if (success) return "redirect:/booking/success";

        model.addAttribute("error", "Booking failed. Please try again.");
        return "redirect:/booking/new?roomId=" + roomId + "&hotelId=" + hotelId;
    }

    // GET — success page
    @GetMapping("/booking/success")
    public String bookingSuccess(HttpSession session) {
        if (!SessionUtils.isLoggedIn(session)) return "redirect:/login";
        return "booking-confirmation";
    }

    private boolean checkRoomConflict(int roomId, Date checkIn, Date checkOut) throws SQLException {
        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> existing = bookingDAO.getBookingsByRoomId(roomId);

        java.time.LocalDate newIn  = checkIn.toLocalDate();
        java.time.LocalDate newOut = checkOut.toLocalDate();

        for (Booking b : existing) {
            java.time.LocalDate existIn  = b.getCheckIn().toLocalDate();
            java.time.LocalDate existOut = b.getCheckOut().toLocalDate();

            // Check overlap — two ranges overlap if one starts before the other ends
            boolean overlaps = newIn.isBefore(existOut) && newOut.isAfter(existIn);
            if (overlaps) return true;
        }
        return false;
    }
}