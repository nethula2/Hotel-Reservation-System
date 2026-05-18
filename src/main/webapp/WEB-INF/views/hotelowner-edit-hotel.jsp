<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.hotelmanagement.system.model.Hotel" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Hotel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark px-4">
    <span class="navbar-brand fw-bold">🏨 Hotel Reservation System</span>
    <div>
        <a href="/hotelowner/hotels" class="btn btn-outline-light btn-sm me-2">← Back</a>
        <a href="/logout" class="btn btn-outline-light btn-sm">Logout</a>
    </div>
</nav>

<%
    Hotel hotel = (Hotel) request.getAttribute("hotel");
%>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-7">
            <div class="card shadow p-4">
                <h3 class="mb-1">Edit Hotel</h3>
                <p class="text-muted mb-4">
                    Saving changes will reset approval status to Pending.
                </p>

                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>

                <form action="/hotelowner/edit-hotel/<%= hotel.getId() %>" method="post">
                    <div class="mb-3">
                        <label class="form-label">Hotel Name</label>
                        <input type="text" name="name" class="form-control"
                               value="<%= hotel.getName() %>" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">City</label>
                        <input type="text" name="city" class="form-control"
                               value="<%= hotel.getCity() %>" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Full Address</label>
                        <input type="text" name="address" class="form-control"
                               value="<%= hotel.getAddress() %>" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea name="description" class="form-control" rows="3"><%= hotel.getDescription() != null ? hotel.getDescription() : "" %></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Star Rating</label>
                        <select name="starRating" class="form-select" required>
                            <% for (int i = 1; i <= 5; i++) { %>
                                <option value="<%= i %>"
                                    <%= hotel.getStarRating() == i ? "selected" : "" %>>
                                    <%= i %> Star<%= i > 1 ? "s" : "" %>
                                </option>
                            <% } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Image URL</label>
                        <input type="text" name="imageUrl" class="form-control"
                               value="<%= hotel.getImageUrl() != null ? hotel.getImageUrl() : "" %>"
                               placeholder="https://example.com/hotel-photo.jpg">
                    </div>
                    <button type="submit" class="btn btn-dark w-100">
                        Save Changes
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>