package com.hotelmanagement.system.controller;

import com.hotelmanagement.system.dao.RoomDAO;
import com.hotelmanagement.system.model.Room;
import com.hotelmanagement.system.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.sql.SQLException;
import java.util.List;

@Controller
public class RoomController {

    @GetMapping("/hotelowner/hotel/{hotelId}")
    public String manageRooms(@PathVariable("hotelId") int hotelId, HttpSession session, Model model) throws SQLException {
        User user = (User) session.getAttribute("loggedUser");
        if (user == null || !"HOTEL_OWNER".equals(user.getRole())) {
            return "redirect:/login";
        }

        RoomDAO roomDAO = new RoomDAO();
        List<Room> rooms = roomDAO.getRoomsByHotelId(hotelId);
        
        model.addAttribute("hotelId", hotelId);
        model.addAttribute("rooms", rooms);
        return "manage-rooms";
    }

    @PostMapping("/hotelowner/hotel/{hotelId}/add-room")
    public String addRoom(
            @PathVariable("hotelId") int hotelId,
            @RequestParam String roomType,
            @RequestParam double pricePerNight,
            @RequestParam int capacity,
            @RequestParam int totalRooms,
            @RequestParam String description,
            HttpSession session
    ) throws SQLException {
        User user = (User) session.getAttribute("loggedUser");
        if (user == null || !"HOTEL_OWNER".equals(user.getRole())) {
            return "redirect:/login";
        }

        Room room = new Room();
        room.setHotelId(hotelId);
        room.setRoomType(roomType);
        room.setPricePerNight(pricePerNight);
        room.setCapacity(capacity);
        room.setTotalRooms(totalRooms);
        room.setAvailableRooms(totalRooms); // Initially, available = total
        room.setDescription(description);

        RoomDAO roomDAO = new RoomDAO();
        roomDAO.addRoom(room);

        return "redirect:/hotelowner/hotel/" + hotelId;
    }

    @PostMapping("/hotelowner/hotel/{hotelId}/update-room/{roomId}")
    public String updateRoom(
            @PathVariable("hotelId") int hotelId,
            @PathVariable("roomId") int roomId,
            @RequestParam double pricePerNight,
            @RequestParam int availableRooms,
            HttpSession session
    ) throws SQLException {
        User user = (User) session.getAttribute("loggedUser");
        if (user == null || !"HOTEL_OWNER".equals(user.getRole())) {
            return "redirect:/login";
        }

        RoomDAO roomDAO = new RoomDAO();
        roomDAO.updateRoom(roomId, pricePerNight, availableRooms);

        return "redirect:/hotelowner/hotel/" + hotelId;
    }

    @PostMapping("/hotelowner/hotel/{hotelId}/delete-room/{roomId}")
    public String deleteRoom(
            @PathVariable("hotelId") int hotelId,
            @PathVariable("roomId") int roomId,
            HttpSession session
    ) throws SQLException {
        User user = (User) session.getAttribute("loggedUser");
        if (user == null || !"HOTEL_OWNER".equals(user.getRole())) {
            return "redirect:/login";
        }

        RoomDAO roomDAO = new RoomDAO();
        roomDAO.deleteRoom(roomId);

        return "redirect:/hotelowner/hotel/" + hotelId;
    }
}
