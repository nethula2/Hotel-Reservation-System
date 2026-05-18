<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.hotelmanagement.system.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Hotel Owner Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark px-4">
    <span class="navbar-brand fw-bold">🏨 Hotel Reservation System</span>
    <div>
        <span class="text-light me-3">
            Welcome, <%= ((User) session.getAttribute("loggedUser")).getName() %>
        </span>
        <a href="/logout" class="btn btn-outline-light btn-sm">Logout</a>
    </div>
</nav>

<div class="container mt-5">
    <h2 class="mb-1">Owner Dashboard</h2>
    <p class="text-muted mb-4">Manage your hotels and reservations</p>

    <div class="row g-4">

        <div class="col-md-4">
            <div class="card h-100 shadow-sm">
                <div class="card-body text-center p-4">
                    <div style="font-size:2rem">🏨</div>
                    <h5 class="card-title mt-2">My Hotels</h5>
                    <p class="card-text text-muted">
                        View all your submitted hotels and check their admin approval status.
                    </p>
                    <a href="/hotelowner/hotels" class="btn btn-dark w-100">View My Hotels</a>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card h-100 shadow-sm">
                <div class="card-body text-center p-4">
                    <div style="font-size:2rem">📋</div>
                    <h5 class="card-title mt-2">Booking Requests</h5>
                    <p class="card-text text-muted">
                        Review customer booking requests and approve or reject them.
                    </p>
                    <a href="/hotelowner/bookings" class="btn btn-dark w-100">View Requests</a>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card h-100 shadow-sm">
                <div class="card-body text-center p-4">
                    <div style="font-size:2rem">➕</div>
                    <h5 class="card-title mt-2">Add New Hotel</h5>
                    <p class="card-text text-muted">
                        Submit a new hotel listing for admin approval.
                    </p>
                    <a href="/hotelowner/add-hotel" class="btn btn-dark w-100">Add Hotel</a>
                </div>
            </div>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>