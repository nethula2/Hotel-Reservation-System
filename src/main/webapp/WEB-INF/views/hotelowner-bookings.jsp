<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.hotelmanagement.system.model.Booking" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Booking Requests</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark px-4">
    <span class="navbar-brand fw-bold">🏨 Hotel Reservation System</span>
    <div>
        <a href="/hotelowner/home" class="btn btn-outline-light btn-sm me-2">Dashboard</a>
        <a href="/logout" class="btn btn-outline-light btn-sm">Logout</a>
    </div>
</nav>

<div class="container mt-5">
    <h2 class="mb-4">Booking Requests</h2>

    <%
        List<Booking> bookings =
            (List<Booking>) request.getAttribute("bookings");

        if (bookings == null || bookings.isEmpty()) {
    %>
        <div class="alert alert-info">No booking requests at the moment.</div>
    <% } else { %>
        <div class="table-responsive">
            <table class="table table-bordered table-hover bg-white shadow-sm">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Customer</th>
                        <th>Hotel</th>
                        <th>Room Type</th>
                        <th>Check In</th>
                        <th>Check Out</th>
                        <th>Nights</th>
                        <th>Total</th>
                        <th>Payment Slip</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Booking b : bookings) {
                    String statusBadge = "bg-warning text-dark";
                    if ("CONFIRMED".equals(b.getStatus())) statusBadge = "bg-success";
                    if ("REJECTED".equals(b.getStatus()))  statusBadge = "bg-danger";
                    if ("CANCELLED".equals(b.getStatus())) statusBadge = "bg-secondary";
                %>
                    <tr>
                        <td>#<%= b.getId() %></td>
                        <td><%= b.getCustomerName() %></td>
                        <td><%= b.getHotelName() %></td>
                        <td><%= b.getRoomType() %></td>
                        <td><%= b.getCheckIn() %></td>
                        <td><%= b.getCheckOut() %></td>
                        <td><%= b.getNights() %></td>
                        <td>Rs. <%= b.getTotalPrice() %></td>
                        <td>
                            <% if (b.getPaymentSlipUrl() != null) { %>
                                <a href="/<%= b.getPaymentSlipUrl() %>"
                                   target="_blank"
                                   class="btn btn-sm btn-info">
                                    View Slip
                                </a>
                            <% } else { %>
                                <span class="text-muted">None</span>
                            <% } %>
                        </td>
                        <td>
                            <span class="badge <%= statusBadge %>">
                                <%= b.getStatus() %>
                            </span>
                        </td>
                        <td>
                            <% if ("PENDING".equals(b.getStatus())) { %>
                                <a href="/hotelowner/booking/confirm/<%= b.getId() %>"
                                   class="btn btn-sm btn-success me-1">Confirm</a>
                                <a href="/hotelowner/booking/reject/<%= b.getId() %>"
                                   class="btn btn-sm btn-danger">Reject</a>
                            <% } else { %>
                                <span class="text-muted">No actions</span>
                            <% } %>
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