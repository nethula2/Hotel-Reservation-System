<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.hotelmanagement.system.model.Hotel" %>
<%@ page import="com.hotelmanagement.system.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pending Hotel Requests</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark px-4">
    <span class="navbar-brand fw-bold">🏨 Hotel Reservation System</span>
    <div>
        <span class="text-light me-3">
            Welcome, <%= ((User) session.getAttribute("loggedUser")).getName() %>
        </span>
        <a href="/admin/home" class="btn btn-outline-light btn-sm me-2">Dashboard</a>
        <a href="/logout" class="btn btn-outline-light btn-sm">Logout</a>
    </div>
</nav>

<div class="container mt-5">
    <h2 class="mb-1">Pending Hotel Requests</h2>
    <p class="text-muted mb-4">Review and approve or reject hotel submissions</p>

    <% if (request.getAttribute("success") != null) { %>
        <div class="alert alert-success"><%= request.getAttribute("success") %></div>
    <% } %>

    <%
        List<Hotel> hotels = (List<Hotel>) request.getAttribute("hotels");
        if (hotels == null || hotels.isEmpty()) {
    %>
        <div class="alert alert-info">No pending hotel requests at the moment.</div>
    <% } else { %>
        <div class="card shadow-sm">
            <table class="table table-hover mb-0">
                <thead class="table-dark">
                    <tr>
                        <th>#</th>
                        <th>Hotel Name</th>
                        <th>City</th>
                        <th>Address</th>
                        <th>Stars</th>
                        <th>Description</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Hotel hotel : hotels) { %>
                    <tr>
                        <td><%= hotel.getId() %></td>
                        <td><%= hotel.getName() %></td>
                        <td><%= hotel.getCity() %></td>
                        <td><%= hotel.getAddress() %></td>
                        <td><%= hotel.getStarRating() %> ⭐</td>
                        <td><%= hotel.getDescription() != null ? hotel.getDescription() : "—" %></td>
                        <td>
                            <form action="/admin/hotel/approve" method="post" style="display:inline">
                                <input type="hidden" name="hotelId" value="<%= hotel.getId() %>">
                                <button type="submit" class="btn btn-sm btn-success me-1">Approve</button>
                            </form>
                            <form action="/admin/hotel/reject" method="post" style="display:inline">
                                <input type="hidden" name="hotelId" value="<%= hotel.getId() %>">
                                <button type="submit" class="btn btn-sm btn-danger">Reject</button>
                            </form>
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