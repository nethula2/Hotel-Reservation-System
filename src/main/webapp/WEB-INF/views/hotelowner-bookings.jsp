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
        java.util.List<com.hotelmanagement.system.model.Booking> bookings =
            (java.util.List<com.hotelmanagement.system.model.Booking>) request.getAttribute("bookings");

        if (bookings == null || bookings.isEmpty()) {
    %>
        <div class="alert alert-info">No booking requests at the moment.</div>
    <% } else { %>
        <div class="table-responsive">
            <table class="table table-bordered table-hover bg-white shadow-sm">
                <thead class="table-dark">
                    <tr>
                        <th>Booking ID</th>
                        <th>Customer</th>
                        <th>Hotel</th>
                        <th>Room Type</th>
                        <th>Check In</th>
                        <th>Check Out</th>
                        <th>Total</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% for (com.hotelmanagement.system.model.Booking booking : bookings) { %>
                    <tr>
                        <td>#<%= booking.getId() %></td>
                        <td><%= booking.getCustomerName() %></td>
                        <td><%= booking.getHotelName() %></td>
                        <td><%= booking.getRoomType() %></td>
                        <td><%= booking.getCheckIn() %></td>
                        <td><%= booking.getCheckOut() %></td>
                        <td>$<%= booking.getTotalPrice() %></td>
                        <td>
                            <% if (booking.getStatus().equals("PENDING")) { %>
                                <span class="badge bg-warning text-dark">Pending</span>
                            <% } else if (booking.getStatus().equals("CONFIRMED")) { %>
                                <span class="badge bg-success">Confirmed</span>
                            <% } else { %>
                                <span class="badge bg-danger">Rejected</span>
                            <% } %>
                        </td>
                        <td>
                            <% if (booking.getStatus().equals("PENDING")) { %>
                                <a href="/hotelowner/booking/confirm/<%= booking.getId() %>"
                                   class="btn btn-sm btn-success me-1">Confirm</a>
                                <a href="/hotelowner/booking/reject/<%= booking.getId() %>"
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

</body>
</html>