package com.hotelmanagement.system.controller;

import com.hotelmanagement.system.dao.HotelDAO;
import com.hotelmanagement.system.dao.RoomDAO;
import com.hotelmanagement.system.model.Hotel;
import com.hotelmanagement.system.model.Room;
import com.hotelmanagement.system.util.SessionUtils;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.sql.SQLException;
import java.util.List;

@Controller
public class HotelController {

    // GET — browse all approved hotels
    @GetMapping("/hotels")
    public String browseHotels(HttpSession session, Model model) throws SQLException {
        if (!SessionUtils.isLoggedIn(session)) return "redirect:/login";

        HotelDAO hotelDAO = new HotelDAO();
        List<Hotel> hotels = hotelDAO.getAllApprovedHotels();
        model.addAttribute("hotels", hotels);
        return "hotels";
    }

    // GET — view one hotel and its available rooms
    @GetMapping("/hotels/{id}")
    public String hotelDetail(
            @PathVariable int id,
            HttpSession session,
            Model model) throws SQLException {

        if (!SessionUtils.isLoggedIn(session)) return "redirect:/login";

        HotelDAO hotelDAO = new HotelDAO();
        Hotel hotel = hotelDAO.getHotelById(id);

        RoomDAO roomDAO = new RoomDAO();
        List<Room> rooms = roomDAO.getAvailableRoomsByHotelId(id);

        model.addAttribute("hotel", hotel);
        model.addAttribute("rooms", rooms);
        return "hotel-details";
    }
}