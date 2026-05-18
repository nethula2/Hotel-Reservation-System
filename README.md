# Hotel Room Reservation System
### SE1020 - Object-Oriented Programming (OOP) Project

Welcome to the **Hotel Room Reservation System** (StayScape), a fully-integrated Java web application designed as a course project for **SE1020 Object-Oriented Programming**. 

This project integrates five distinct modules to provide a seamless platform for Customers, Hotel Owners, and Administrators to manage bookings, hotels, rooms, and users.

---

##  Team & Workload Distribution

| Module | Contributor Email | Assigned Features & Responsibilities |
| :--- | :--- | :--- |
| **Room Management** | `it25100015@my.sliit.lk` | Room model hierarchy, adding room tier logic (VIP/Gold/Standard), floor tracking, availability check. |
| **Customer Management** | `it25102342@my.sliit.lk` | Profile management, update details form, account deactivation/deletion, support pages. |
| **Reservation Management** | `it25100618@my.sliit.lk` | Booking lifecycle management, guest documents/countries support, payment status verification. |
| **Hotel Management** | `it25103395@my.sliit.lk` | Hotel details, star rating, address/city directory, uploadable hotel image links, and pending approval flows. |
| **User Management** | `it25103621@my.sliit.lk` | Core Authentication, Registration, multi-role session utility, and Auth Controllers. |

---

##  Project Architecture

The application is structured following the **MVC (Model-View-Controller)** pattern:
* **Models**: Represents the core business entities and database structures.
* **Controllers**: Handles Spring Web MVC routing, request mapping, session validation, and redirects.
* **DAOs (Data Access Objects)**: Manages clean separation of JDBC SQL operations, database connection pooling, and record retrieval.
* **Views**: Dynamic web interfaces built using **JSP (JavaServer Pages)**, JSTL, and styled beautifully using **Bootstrap 5** and **FontAwesome**.

---

##  Core OOP Concepts Implemented

To fulfill the requirements of **SE1020 OOP**, the project extensively implements the four pillars of Object-Oriented Programming:

### 1. Encapsulation 
We protect the integrity of the data inside our models by restricting direct access to object attributes. Fields are declared `private` and can only be accessed or mutated through public `getter` and `setter` methods, incorporating validation when necessary.

* **Example in [`User.java`](file:///src/main/java/com/hotelmanagement/system/model/User.java)**:
```java
public abstract class User {
    private int id;
    private String name;
    private String email;
    private String password;
    
    // Controlled read access
    public String getEmail() { return email; }
    
    // Controlled write access
    public void setEmail(String email) { this.email = email; }
}
```

### 2. Inheritance 
Inheritance allows us to reuse common fields and behavior across multiple related classes, reducing redundancy and making the codebase easier to maintain.

* **User Hierarchy**: `Customer`, `HotelOwner`, and `Admin` inherit all standard user credentials and attributes from the parent `User` base class.
* **Room Hierarchy**: `LuxuryRoom` and `StandardRoom` inherit standard room fields (like `roomNumber`, `floor`, `pricePerNight`) from the `Room` base class.

* **Example in [`Customer.java`](file:///src/main/java/com/hotelmanagement/system/model/Customer.java)**:
```java
public class Customer extends User {
    public Customer() {
        super();
        setRole("CUSTOMER"); // Inherited method from User base class
    }
}
```

### 3. Abstraction 
Abstraction allows us to define structural interfaces or "templates" for our entities without specifying the complete implementation, hiding the underlying complexity.

* **Example in [`User.java`](file:///src/main/java/com/hotelmanagement/system/model/User.java)**:
The base `User` class is defined as `abstract`, preventing direct instantiation. It declares an abstract method that forces subclasses to define their own specific home dashboard redirection URLs:
```java
public abstract class User {
    // Abstract method: Has no body in parent class
    public abstract String getUserHomePageUrl();
}
```

### 4. Polymorphism 
Polymorphism allows objects of different subclasses to be treated as instances of a common superclass, enabling dynamic method dispatch at runtime.

#### A. Method Overriding (Runtime Polymorphism)
Subclasses override inherited parent methods to implement specific behavior unique to that subclass type.

* **Redirection Redefinition**: `Customer`, `HotelOwner`, and `Admin` each implement `getUserHomePageUrl()` differently:
```java
// Inside Customer.java
@Override
public String getUserHomePageUrl() { return "/customer/home"; }

// Inside HotelOwner.java
@Override
public String getUserHomePageUrl() { return "/hotelowner/home"; }
```

#### B. Dynamic Method Dispatch / Upcasting
In the Database Access layer, we query rooms and instantiate the appropriate subclass dynamically based on the DB data, holding the reference in a generic `Room` superclass type.

* **Example in [`RoomDAO.java`](file:///src/main/java/com/hotelmanagement/system/dao/RoomDAO.java)**:
```java
private Room buildRoomFromResultSet(ResultSet rs) throws SQLException {
    String tier = rs.getString("room_tier");
    Room r;

    // Polymorphic Instantiation
    if ("VIP".equals(tier) || "GOLD".equals(tier)) {
        r = new LuxuryRoom(); // Upcasting
    } else {
        r = new StandardRoom(); // Upcasting
    }
    
    r.setRoomTier(tier);
    return r; // Returns standard Room reference containing subclass behavior
}
```

---

##  How to Set Up & Run

### Prerequisites
1. **Java JDK 17** installed.
2. **Maven 3+** (or use the built-in Maven Wrapper `./mvnw`).
3. **MySQL Server** running.

### Database Setup
1. Open your MySQL client (e.g. XAMPP phpMyAdmin, MySQL Workbench).
2. Create a new database:
   ```sql
   CREATE DATABASE hotel_reservation_db;
   ```
3. Import the database schema from the **`database.sql`** file located in the project root:
   ```bash
   mysql -u root -p hotel_reservation_db < database.sql
   ```
4. Verify database configurations in `src/main/resources/db.properties` (or the connection utility class).

### Launching the Application
Run the embedded server using the provided Maven wrapper:
```bash
# Windows
.\mvnw.cmd spring-boot:run

# Linux / macOS
chmod +x mvnw
./mvnw spring-boot:run
```

Once started successfully, open your browser and navigate to:
```
http://localhost:8080
```

---

##  Workflow Rules
1. **Branching**: Do NOT push directly to the `main` branch. Developers must work on their respective feature branches and submit a Pull Request.
2. **Database Integrity**: Avoid making manual updates directly to the schema structure; keep changes tracked within `database.sql`.
3. **Descriptive Commits**: Label commits cleanly (e.g., `feat: added customer profile deactivation controller`).
