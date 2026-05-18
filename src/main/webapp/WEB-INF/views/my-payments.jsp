<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.hotelmanagement.system.model.Booking" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Payment History</title>
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
    <h2 class="mb-1">Payment History</h2>
    <p class="text-muted mb-4">Your confirmed bookings and payments</p>

    <%
        List<Booking> payments = (List<Booking>) request.getAttribute("payments");
        if (payments == null || payments.isEmpty()) {
    %>
        <div class="alert alert-info">No confirmed payments yet.</div>
    <% } else { %>
        <div class="table-responsive">
            <table class="table table-bordered table-hover bg-white shadow-sm">
                <thead class="table-dark">
                    <tr>
                        <th>Booking ID</th>
                        <th>Hotel</th>
                        <th>Room Type</th>
                        <th>Check In</th>
                        <th>Check Out</th>
                        <th>Nights</th>
                        <th>Amount Paid</th>
                        <th>Payment Slip</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Booking b : payments) { %>
                    <tr>
                        <td>#<%= b.getId() %></td>
                        <td><%= b.getHotelName() %></td>
                        <td><%= b.getRoomType() %></td>
                        <td><%= b.getCheckIn() %></td>
                        <td><%= b.getCheckOut() %></td>
                        <td><%= b.getNights() %></td>
                        <td class="fw-bold text-success">Rs. <%= b.getTotalPrice() %></td>
                        <td>
                            <% if (b.getPaymentSlipUrl() != null) { %>
                                <a href="/<%= b.getPaymentSlipUrl() %>"
                                   target="_blank"
                                   class="btn btn-sm btn-outline-dark">
                                    View Slip
                                </a>
                            <% } else { %>
                                <span class="text-muted">—</span>
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