package com.hotelmanagement.system.controller;

import com.hotelmanagement.system.dao.HotelDAO;
import com.hotelmanagement.system.model.Hotel;
import com.hotelmanagement.system.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.sql.SQLException;
import java.util.List;

import org.springframework.web.bind.annotation.PathVariable;
import com.hotelmanagement.system.dao.RoomDAO;
import com.hotelmanagement.system.model.Room;

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
    public String hotelOwnerBookingsPage(){
        return "hotelowner-bookings";
    }

    @GetMapping("/hotelowner/hotel/{id}")
    public String manageHotelRoomsPage(@PathVariable("id") int hotelId, HttpSession session, Model model) throws SQLException {
        Object loggedInUserObj = session.getAttribute("loggedUser");
        if (loggedInUserObj == null) return "redirect:/login";

        User loggedInUser = (User) loggedInUserObj;

        HotelDAO hotelDAO = new HotelDAO();
        Hotel hotel = hotelDAO.getHotelById(hotelId);

        // Ensure the hotel exists and belongs to this owner
        if (hotel == null || hotel.getOwnerId() != loggedInUser.getId()) {
            return "redirect:/hotelowner/hotels";
        }

        RoomDAO roomDAO = new RoomDAO();
        List<Room> rooms = roomDAO.getRoomsByHotelId(hotelId);

        model.addAttribute("hotel", hotel);
        model.addAttribute("rooms", rooms);

        return "hotelowner-hotel";
    }

    @PostMapping("/hotelowner/hotel/{id}/add-room")
    public String addRoom(
            @PathVariable("id") int hotelId,
            @RequestParam String roomType,
            @RequestParam double pricePerNight,
            @RequestParam int capacity,
            @RequestParam int totalRooms,
            @RequestParam String description,
            HttpSession session
    ) throws SQLException {
        Object loggedInUserObj = session.getAttribute("loggedUser");
        if (loggedInUserObj == null) return "redirect:/login";

        User loggedInUser = (User) loggedInUserObj;

        HotelDAO hotelDAO = new HotelDAO();
        Hotel hotel = hotelDAO.getHotelById(hotelId);

        // Security check
        if (hotel != null && hotel.getOwnerId() == loggedInUser.getId()) {
            Room newRoom = new Room();
            newRoom.setHotelId(hotelId);
            newRoom.setRoomType(roomType);
            newRoom.setPricePerNight(pricePerNight);
            newRoom.setCapacity(capacity);
            newRoom.setTotalRooms(totalRooms);
            newRoom.setAvailableRooms(totalRooms); // Initially available matches total
            newRoom.setDescription(description);

            RoomDAO roomDAO = new RoomDAO();
            roomDAO.addRoom(newRoom);
        }

        return "redirect:/hotelowner/hotel/" + hotelId;
    }
}
