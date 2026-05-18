<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.hotelmanagement.system.model.Hotel" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Browse Hotels</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark px-4">
    <span class="navbar-brand fw-bold">🏨 Hotel Reservation System</span>
    <div>
        <a href="/customer/home" class="btn btn-outline-light btn-sm me-2">Dashboard</a>
        <a href="/logout" class="btn btn-outline-light btn-sm">Logout</a>
    </div>
</nav>

<div class="container mt-5">
    <h2 class="mb-1">Available Hotels</h2>
    <p class="text-muted mb-4">Click a hotel to see rooms and make a reservation</p>

    <%
        List<Hotel> hotels = (List<Hotel>) request.getAttribute("hotels");
        if (hotels == null || hotels.isEmpty()) {
    %>
        <div class="alert alert-info">No hotels available at the moment.</div>
    <% } else { %>
        <div class="row g-4">
        <% for (Hotel h : hotels) { %>
            <div class="col-md-4">
                <div class="card h-100 shadow-sm">

                    <img src="<%= h.getImageUrl() %>"
                         class="card-img-top"
                         style="height:200px; object-fit:cover;"
                         onerror="this.src='https://site-img-res-new.s3.ap-south-1.amazonaws.com/next-site-images/mobileplaceholder.jpg'">

                    <div class="card-body">
                        <h5 class="card-title"><%= h.getName() %></h5>
                        <p class="text-muted mb-1">📍 <%= h.getCity() %></p>
                        <p class="text-muted mb-2">⭐ <%= h.getStarRating() %> Stars</p>
                        <p class="card-text small"><%= h.getDescription() != null ? h.getDescription() : "" %></p>
                    </div>
                    <div class="card-footer bg-white border-top-0">
                        <a href="/hotels/<%= h.getId() %>" class="btn btn-dark w-100">
                            View Rooms
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