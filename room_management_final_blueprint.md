# 🏨 Room Management Module: Technical Blueprint (Final Merged Version)

This blueprint documents the architecture, Object-Oriented Programming (OOP) design, and database integration of the final merged **Room Management** module for your academic project.

---

## 1. MVC Architectural Overview

The Room Management component follows the industry-standard **Model-View-Controller (MVC)** design pattern to achieve a clean separation of concerns:

*   **Model (Domain & Data Layer)**: Encapsulates state and business rules. Includes the abstract `Room` base class, `StandardRoom`, `LuxuryRoom`, and data retrieval mechanisms inside `RoomDAO`.
*   **View (Presentation Layer)**: Renders the user interface dynamically using **JSP (JavaServer Pages)** and **Bootstrap**. Includes `manage-rooms.jsp` (for hotel owners) and `room-availability.jsp` (for customers and owners to check dates).
*   **Controller (Routing Layer)**: Captures user actions from the views, validates sessions/roles, decides which subclass to construct, and coordinates with the DAO and model layers. Managed by `RoomController`.

---

## 2. Object-Oriented Programming (OOP) Implementation

To satisfy academic project requirements, core Java OOP principles have been strictly implemented across the codebase:

### A. Abstraction
The base `Room` class is declared as `public abstract class Room`. It defines basic attributes (like `roomNumber`, `floor`, `pricePerNight`, `capacity`, and `status`) but cannot be instantiated directly. It defines an abstract method:
```java
public abstract String getTierLabel();
```
This forces all specific room classifications to implement their own tier representation.

### B. Inheritance
Two specialized classes inherit all characteristics from `Room`:
*   `StandardRoom extends Room`: Represents standard accommodations and returns `"Standard"` as its tier label.
*   `LuxuryRoom extends Room`: Inherits all attributes from `Room` but encapsulates an additional property, `private boolean hasPremiumService` (defaulting to `true` in its constructor). It overrides `getTierLabel()` to return `"Luxury"`.

### C. Encapsulation
All attributes in `Room` and its subclasses are declared with the `private` access modifier (e.g. `private String roomNumber`). Access to these fields is exclusively governed through standard `public` getters and setters (e.g., `getRoomNumber()` and `setRoomNumber()`), protecting data integrity.

### D. Polymorphism
During database reading in `RoomDAO.java`, dynamic binding (polymorphism) is used to load rooms into a single generic list:
```java
// Instantiating standard/luxury objects dynamically under the Room reference
Room r;
if (tier.equals("VIP") || tier.equals("GOLD")) {
    r = new LuxuryRoom();
} else {
    r = new StandardRoom();
}
// Adding standard and luxury instances to the same polymorphic list
roomList.add(r);
```
When iterating through the list in the front-end, calling `r.getTierLabel()` dynamically executes the overridden method of the concrete child class (dynamic binding).

---

## 3. Database Schema (`rooms` Table)

The database schema represents a **physical inventory tracker** (where every row is a physical, individual room inside a hotel):

```sql
CREATE TABLE rooms (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    hotel_id        INT           NOT NULL,
    room_number     VARCHAR(20)   NOT NULL,
    floor           INT           DEFAULT 1,
    room_type       ENUM('SINGLE', 'DOUBLE', 'SUITE', 'DELUXE') NOT NULL,
    room_tier       ENUM('STANDARD', 'GOLD', 'VIP') DEFAULT 'STANDARD',
    price_per_night DECIMAL(10,2) NOT NULL,
    capacity        INT           NOT NULL DEFAULT 1,
    status          ENUM('AVAILABLE', 'OCCUPIED', 'MAINTENANCE') DEFAULT 'AVAILABLE',
    description     TEXT,
    image_url       VARCHAR(500)  DEFAULT 'https://www.pngkey.com/png/detail/470-4703342_generic-placeholder-image-conference-room-free-icon.png',
    created_at      TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE CASCADE,
    UNIQUE KEY unique_room (hotel_id, room_number)
);
```

---

## 4. Core Functionality (CRUD Operations)

Manual database mapping and queries are executed through **JDBC (Java Database Connectivity)** within `RoomDAO.java` using `PreparedStatement` to guard against **SQL Injection**.

| Operation | Java Method | Under-the-Hood SQL Statement |
| :--- | :--- | :--- |
| **Create** | `addRoom(Room room)` | `INSERT INTO rooms (hotel_id, room_number, floor, room_type, room_tier, price_per_night, capacity, status, description, image_url) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)` |
| **Read** | `getRoomsByHotelId(int id)` | `SELECT * FROM rooms WHERE hotel_id = ?` |
| **Update** | `updateRoom(...)` | `UPDATE rooms SET price_per_night = ?, status = ?, description = ? WHERE id = ?` |
| **Delete** | `deleteRoom(int id)` | `DELETE FROM rooms WHERE id = ?` |

---

## 5. Operations & Scheduling Conflicts

### A. Session Authorization
Every endpoint inside `RoomController` checks credentials using centralized utility class `SessionUtils.java`:
```java
if (!SessionUtils.isLoggedIn(session)) return "redirect:/login";
if (!SessionUtils.hasRole(session, "HOTEL_OWNER")) return "redirect:/login";
```

### B. Room Creation Polymorphism
When a Hotel Owner submits a new room entry via `/hotelowner/hotel/{hotelId}/add-room`:
1. The controller captures form details.
2. Based on the selected `roomTier`, the application instantiates the correct subclass:
   ```java
   Room newRoom;
   if (roomTier.equals("VIP") || roomTier.equals("GOLD")) {
       newRoom = new LuxuryRoom();
   } else {
       newRoom = new StandardRoom();
   }
   ```
3. Sets attributes and calls `RoomDAO.addRoom(newRoom)`.

### C. Booking Conflict Logic
Because rooms are physical assets, double-booking a specific room during the same dates is mathematically blocked inside `BookingController.java` during reservation attempts:
```java
private boolean checkRoomConflict(int roomId, Date checkIn, Date checkOut) throws SQLException {
    BookingDAO bookingDAO = new BookingDAO();
    List<Booking> existing = bookingDAO.getBookingsByRoomId(roomId);

    java.time.LocalDate newIn  = checkIn.toLocalDate();
    java.time.LocalDate newOut = checkOut.toLocalDate();

    for (Booking b : existing) {
        java.time.LocalDate existIn  = b.getCheckIn().toLocalDate();
        java.time.LocalDate existOut = b.getCheckOut().toLocalDate();

        // Overlap Check Formula: (StartA < EndB) && (EndA > StartB)
        boolean overlaps = newIn.isBefore(existOut) && newOut.isAfter(existIn);
        if (overlaps) return true;
    }
    return false;
}
```

---

## 6. Summary of Key Files in the Component

1.  **`Room.java`** (Model): The central, abstract domain entity.
2.  **`StandardRoom.java` / `LuxuryRoom.java`** (Model Subclasses): Defines tier behaviors.
3.  **`RoomDAO.java`** (Data Access): Handles MySQL data queries.
4.  **`RoomController.java`** (Controller): Routes administration events.
5.  **`SessionUtils.java`** (Utility): Encapsulates clean, role-based checks.
6.  **`manage-rooms.jsp`** (View): Dashboard with status-toggling forms.
7.  **`room-availability.jsp`** (View): Graphical availability tracker.
