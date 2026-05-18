<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.hotelmanagement.system.model.Hotel" %>
<%@ page import="com.hotelmanagement.system.model.Room" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Hotel Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark px-4">
    <span class="navbar-brand fw-bold">🏨 Hotel Reservation System</span>
    <div>
        <a href="/hotels" class="btn btn-outline-light btn-sm me-2">← Back</a>
        <a href="/logout" class="btn btn-outline-light btn-sm">Logout</a>
    </div>
</nav>

<%
    Hotel hotel = (Hotel) request.getAttribute("hotel");
    List<Room> rooms = (List<Room>) request.getAttribute("rooms");
%>

<!-- Hotel Header -->
<div style="background:#343a40; color:white; padding:30px 0; margin-bottom:30px;">
    <div class="container">
        <h2 class="fw-bold"><%= hotel.getName() %></h2>
        <p class="mb-1">📍 <%= hotel.getCity() %> — <%= hotel.getAddress() %></p>
        <p class="mb-0">⭐ <%= hotel.getStarRating() %> Stars</p>
        <% if (hotel.getDescription() != null && !hotel.getDescription().isEmpty()) { %>
            <p class="mt-2 text-light"><%= hotel.getDescription() %></p>
        <% } %>
    </div>
</div>

<div class="container">
    <h4 class="mb-4">Available Rooms</h4>

    <% if (rooms == null || rooms.isEmpty()) { %>
        <div class="alert alert-info">No rooms available in this hotel right now.</div>
    <% } else { %>
        <div class="row g-4">
        <% for (Room r : rooms) {
            String tierBadge = "bg-secondary";
            if ("VIP".equalsIgnoreCase(r.getRoomTier()))  tierBadge = "bg-dark";
            if ("GOLD".equalsIgnoreCase(r.getRoomTier())) tierBadge = "bg-warning text-dark";
        %>
            <div class="col-md-4">
                <div class="card h-100 shadow-sm">
                    <div class="card-body">
                        <img src="<%= r.getImageUrl() %>"
                             class="card-img-top"
                             style="height:150px; object-fit:cover;"
                             onerror="this.src='https://www.pngkey.com/png/detail/470-4703342_generic-placeholder-image-conference-room-free-icon.png'">a

                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <h5 class="card-title mb-0">Room <%= r.getRoomNumber() %></h5>
                            <span class="badge <%= tierBadge %>"><%= r.getTierLabel() %></span>
                        </div>
                        <p class="text-muted mb-1">
                            Floor <%= r.getFloor() %> · <%= r.getRoomType() %>
                        </p>
                        <p class="text-muted mb-1">
                            👥 Up to <%= r.getCapacity() %> guest(s)
                        </p>
                        <p class="fw-bold text-danger mb-2">
                            Rs. <%= r.getPricePerNight() %> / night
                        </p>
                        <% if (r.getDescription() != null && !r.getDescription().isEmpty()) { %>
                            <p class="small text-muted"><%= r.getDescription() %></p>
                        <% } %>
                    </div>
                    <div class="card-footer bg-white border-top-0 d-flex gap-2">
                        <a href="/hotelowner/room/<%= r.getId() %>/availability"
                           class="btn btn-outline-dark btn-sm flex-fill">
                            Check Dates
                        </a>
                        <a href="/booking/new?roomId=<%= r.getId() %>&hotelId=<%= hotel.getId() %>"
                           class="btn btn-dark btn-sm flex-fill">
                            Reserve
                        </a>
                    </div>
                </div>
            </div>
        <% } %>
        </div>
    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>