<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.hotelmanagement.system.model.Booking" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Reservations</title>
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
    <h2 class="mb-1">My Reservations</h2>
    <p class="text-muted mb-4">All your hotel booking requests and their status</p>

    <%
        List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
        if (bookings == null || bookings.isEmpty()) {
    %>
        <div class="alert alert-info">
            You have no reservations yet.
            <a href="/hotels">Browse hotels</a> to make your first booking.
        </div>
    <% } else { %>
        <div class="table-responsive">
            <table class="table table-bordered table-hover bg-white shadow-sm">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Hotel</th>
                        <th>Room Type</th>
                        <th>Check In</th>
                        <th>Check Out</th>
                        <th>Nights</th>
                        <th>Total</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Booking b : bookings) {
                    String statusBadge = "bg-warning text-dark";
                    if ("CONFIRMED".equals(b.getStatus()))  statusBadge = "bg-success";
                    if ("REJECTED".equals(b.getStatus()))   statusBadge = "bg-danger";
                    if ("CANCELLED".equals(b.getStatus()))  statusBadge = "bg-secondary";
                %>
                    <tr>
                        <td>#<%= b.getId() %></td>
                        <td><%= b.getHotelName() %></td>
                        <td><%= b.getRoomType() %></td>
                        <td><%= b.getCheckIn() %></td>
                        <td><%= b.getCheckOut() %></td>
                        <td><%= b.getNights() %></td>
                        <td>Rs. <%= b.getTotalPrice() %></td>
                        <td>
                            <span class="badge <%= statusBadge %>">
                                <%= b.getStatus() %>
                            </span>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>