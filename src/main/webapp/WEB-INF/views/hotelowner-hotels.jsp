<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.hotelmanagement.system.model.Hotel" %>
<%@ page import="com.hotelmanagement.system.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Hotels</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark px-4">
    <span class="navbar-brand fw-bold">🏨 Hotel Reservation System</span>
    <div>
        <span class="text-light me-3">
            Welcome, <%= ((User) session.getAttribute("loggedUser")).getName() %>
        </span>
        <a href="/hotelowner/home" class="btn btn-outline-light btn-sm me-2">Dashboard</a>
        <a href="/logout" class="btn btn-outline-light btn-sm">Logout</a>
    </div>
</nav>

<div class="container mt-5">
    <h2 class="mb-1">My Hotels</h2>
    <p class="text-muted mb-4">View and manage your hotel listings</p>

    <div class="d-flex justify-content-end mb-4">
        <a href="/hotelowner/add-hotel" class="btn btn-dark">+ Add New Hotel</a>
    </div>

    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
    <% } %>

    <%
        List<Hotel> hotels = (List<Hotel>) request.getAttribute("hotels");
        if (hotels == null || hotels.isEmpty()) {
    %>
        <div class="alert alert-info">
            You have not submitted any hotels yet.
            <a href="/hotelowner/add-hotel">Add your first hotel.</a>
        </div>
    <% } else { %>
        <div class="card shadow-sm">
            <table class="table table-hover mb-0">
                <thead class="table-dark">
                    <tr>
                        <th>#</th>
                        <th>Hotel Name</th>
                        <th>City</th>
                        <th>Star Rating</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Hotel hotel : hotels) { %>
                    <tr>
                        <td><%= hotel.getId() %></td>
                        <td><%= hotel.getName() %></td>
                        <td><%= hotel.getCity() %></td>
                        <td><%= hotel.getStarRating() %> ⭐</td>
                        <td>
                            <% if ("APPROVED".equals(hotel.getStatus())) { %>
                                <span class="badge bg-success">Approved</span>
                            <% } else if ("PENDING".equals(hotel.getStatus())) { %>
                                <span class="badge bg-warning text-dark">Pending</span>
                            <% } else { %>
                                <span class="badge bg-danger">Rejected</span>
                            <% } %>
                        </td>
                        <td>
                            <% if ("APPROVED".equals(hotel.getStatus())) { %>
                                <a href="/hotelowner/hotel/<%= hotel.getId() %>"
                                   class="btn btn-sm btn-dark">Manage</a>
                            <% } else { %>
                                <span class="text-muted small">Not available</span>
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