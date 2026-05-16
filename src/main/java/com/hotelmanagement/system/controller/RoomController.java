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
import org.springframework.web.bind.annotation.*;

import java.sql.SQLException;
import java.util.List;

//handling all room management web requests
@Controller
public class RoomController {

    //method to show the management page
    @GetMapping("/hotelowner/hotel/{hotelId}")
    public String showManageRoomsPage(@PathVariable("hotelId") int hotelId, HttpSession session, Model model) throws SQLException {
        
        // Checking if a user is logged in
        User user = (User) session.getAttribute("loggedUser");
        

        if (user == null || !user.getRole().equals("HOTEL_OWNER")) {
            return "redirect Checking if the user has the correct role:/login";
        }

        // Creating an instance of HotelDAO to get hotel information
        HotelDAO hotelDAO = new HotelDAO();
        Hotel h = hotelDAO.getHotelById(hotelId);

        // Creating an instance of RoomDAO to get all rooms for this hotel
        RoomDAO roomDAO = new RoomDAO();
        List<Room> roomList = roomDAO.getRoomsByHotelId(hotelId);
        

        model.addAttribute("hotel", h);
        model.addAttribute("rooms", roomList);
        

        return "manage-rooms";
    }

    //method to handle adding a new room entry
    @PostMapping("/hotelowner/hotel/{hotelId}/add-room")
    public String handleAddRoom(
            @PathVariable("hotelId") int hotelId,
            @RequestParam String roomType,
            @RequestParam String roomTier,
            @RequestParam double pricePerNight,
            @RequestParam int capacity,
            @RequestParam int totalRooms,
            @RequestParam String description,
            HttpSession session
    ) throws SQLException {
        
        User user = (User) session.getAttribute("loggedUser");
        if (user == null || !user.getRole().equals("HOTEL_OWNER")) {
            return "redirect:/login";
        }

        // Create a new Room object and set its properties
        Room newRoom = new Room();
        newRoom.setHotelId(hotelId);
        newRoom.setRoomType(roomType);
        newRoom.setRoomTier(roomTier);
        newRoom.setPricePerNight(pricePerNight);
        newRoom.setCapacity(capacity);
        newRoom.setTotalRooms(totalRooms);
        newRoom.setAvailableRooms(totalRooms);
        newRoom.setDescription(description);

        // Calling the DAO to add the room to the database
        RoomDAO dao = new RoomDAO();
        dao.addRoom(newRoom);


        return "redirect:/hotelowner/hotel/" + hotelId;
    }

    // This method handles updating a room
    @PostMapping("/hotelowner/hotel/{hotelId}/update-room/{roomId}")
    public String handleUpdateRoom(
            @PathVariable("hotelId") int hotelId,
            @PathVariable("roomId") int roomId,
            @RequestParam double pricePerNight,
            @RequestParam int totalRooms,
            @RequestParam int availableRooms,
            HttpSession session
    ) throws SQLException {
        
        User user = (User) session.getAttribute("loggedUser");
        if (user == null || !user.getRole().equals("HOTEL_OWNER")) {
            return "redirect:/login";
        }

        // Calling the updateRoom method in RoomDAO
        RoomDAO dao = new RoomDAO();
        dao.updateRoom(roomId, pricePerNight, totalRooms, availableRooms);

        return "redirect:/hotelowner/hotel/" + hotelId;
    }

    //method to handle deleting a room layout
    @PostMapping("/hotelowner/hotel/{hotelId}/delete-room/{roomId}")
    public String handleDeleteRoom(
            @PathVariable("hotelId") int hotelId,
            @PathVariable("roomId") int roomId,
            HttpSession session
    ) throws SQLException {
        
        User user = (User) session.getAttribute("loggedUser");
        if (user == null || !user.getRole().equals("HOTEL_OWNER")) {
            return "redirect:/login";
        }

        // Calling the deleteRoom method in RoomDAO
        RoomDAO dao = new RoomDAO();
        dao.deleteRoom(roomId);

        return "redirect:/hotelowner/hotel/" + hotelId;
    }

    //method to show the availability of a room
    @GetMapping("/hotelowner/room/{roomId}/availability")
    public String showRoomAvailability(@PathVariable("roomId") int roomId, HttpSession session, Model model) throws SQLException {
        
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) {
            return "redirect:/login";
        }


        if (!user.getRole().equals("HOTEL_OWNER") && !user.getRole().equals("CUSTOMER")) {
            return "redirect:/login";
        }

        // Get the room details
        RoomDAO roomDAO = new RoomDAO();
        Room room = roomDAO.getRoomById(roomId);
        
        // Get all bookings for this room
        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> bookings = bookingDAO.getBookingsByRoomId(roomId);

        // Pass data to the view
        model.addAttribute("room", room);
        model.addAttribute("bookings", bookings);

        return "room-availability";
    }
}
