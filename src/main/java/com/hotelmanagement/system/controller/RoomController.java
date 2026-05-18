package com.hotelmanagement.system.controller;

import com.hotelmanagement.system.dao.BookingDAO;
import com.hotelmanagement.system.dao.HotelDAO;
import com.hotelmanagement.system.dao.RoomDAO;

import com.hotelmanagement.system.model.*;
import com.hotelmanagement.system.util.SessionUtils;

import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.sql.SQLException;
import java.util.List;


//handling all room management web requests
@Controller
public class RoomController {


//method to show the manage rooms page
    @GetMapping("/hotelowner/hotel/{hotelId}")
    public String showManageRoomsPage(
            @PathVariable int hotelId,
            HttpSession session,
            Model model) throws SQLException {

//checking if s user is logged in
        if (!SessionUtils.isLoggedIn(session)) return "redirect:/login";
        if (!SessionUtils.hasRole(session, "HOTEL_OWNER")) return "redirect:/login";

        //Creating a instance of HotelDAO to get hotel info
        HotelDAO hotelDAO = new HotelDAO();
        Hotel hotel = hotelDAO.getHotelById(hotelId);

//Creating an instance of RoomDAO to get all rooms for hotl
        RoomDAO roomDAO = new RoomDAO();
        List<Room> roomList = roomDAO.getRoomsByHotelId(hotelId);

        model.addAttribute("hotel", hotel);
        model.addAttribute("rooms", roomList);

        return "manage-rooms";
    }

    //POST method to add a new room to hotel entry
    @PostMapping("/hotelowner/hotel/{hotelId}/add-room")
    public String handleAddRoom(
            @PathVariable int hotelId,
            @RequestParam String roomNumber,
            @RequestParam int floor,
            @RequestParam String roomType,
            @RequestParam String roomTier,
            @RequestParam double pricePerNight,
            @RequestParam int capacity,
            @RequestParam String description,
            @RequestParam(required = false) String imageUrl,
            HttpSession session) throws SQLException {

        if (!SessionUtils.isLoggedIn(session)) return "redirect:/login";
        if (!SessionUtils.hasRole(session, "HOTEL_OWNER")) return "redirect:/login";

        //implementing nheritance
        Room newRoom;
        if (roomTier.equals("VIP") || roomTier.equals("GOLD")) {
            newRoom = new LuxuryRoom();
        } else {
            newRoom = new StandardRoom();
        }

       // Create a new Room object and set its properties
        newRoom.setHotelId(hotelId);
        newRoom.setRoomNumber(roomNumber);
        newRoom.setFloor(floor);
        newRoom.setRoomType(roomType);
        newRoom.setRoomTier(roomTier);
        newRoom.setPricePerNight(pricePerNight);
        newRoom.setCapacity(capacity);
        newRoom.setDescription(description);
        newRoom.setImageUrl(imageUrl);

        //Calling the DAO to add the room to db
        RoomDAO dao = new RoomDAO();
        dao.addRoom(newRoom);

        return "redirect:/hotelowner/hotel/" + hotelId;
    }

    //POST—method to update an existing room
    @PostMapping("/hotelowner/hotel/{hotelId}/update-room/{roomId}")
    public String handleUpdateRoom(
            @PathVariable int hotelId,
            @PathVariable int roomId,
            @RequestParam double pricePerNight,
            @RequestParam String status,
            @RequestParam String description,
            HttpSession session) throws SQLException {

        if (!SessionUtils.isLoggedIn(session)) return "redirect:/login";
        if (!SessionUtils.hasRole(session, "HOTEL_OWNER")) return "redirect:/login";

        //calling the updateRoom method in RoomDAO
        RoomDAO dao = new RoomDAO();
        dao.updateRoom(roomId, pricePerNight, status, description);

        return "redirect:/hotelowner/hotel/" + hotelId;
    }

    //method to delete a room
    @PostMapping("/hotelowner/hotel/{hotelId}/delete-room/{roomId}")
    public String handleDeleteRoom(
            @PathVariable int hotelId,
            @PathVariable int roomId,
            HttpSession session) throws SQLException {

        if (!SessionUtils.isLoggedIn(session)) return "redirect:/login";
        if (!SessionUtils.hasRole(session, "HOTEL_OWNER")) return "redirect:/login";

        RoomDAO dao = new RoomDAO();
        dao.deleteRoom(roomId);

        return "redirect:/hotelowner/hotel/" + hotelId;
    }

    //method to show availability calendar for a room
    @GetMapping("/hotelowner/room/{roomId}/availability")
    public String showRoomAvailability(
            @PathVariable int roomId,
            HttpSession session,
            Model model) throws SQLException {

        if (!SessionUtils.isLoggedIn(session)) return "redirect:/login";

        //Get the room details
        RoomDAO roomDAO = new RoomDAO();
        Room room = roomDAO.getRoomById(roomId);


//Get all bookings for this room
        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> bookings = bookingDAO.getBookingsByRoomId(roomId);

        //Adding  debug print to console
        System.out.println("Room ID: " + roomId + " | Bookings found: " + bookings.size());

//Pass data to the view
        model.addAttribute("room", room);
        model.addAttribute("bookings", bookings);

        return "room-availability";
    }
}