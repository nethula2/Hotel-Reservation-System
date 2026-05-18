<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.hotelmanagement.system.model.User" %>

<%
    User user = (User) session.getAttribute("loggedUser");
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Customer Dashboard</title>

    <!-- Bootstrap -->
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
            rel="stylesheet">

    <style>

        body {
            background-color: #f8f9fa;
        }

        .dashboard-card {
            border-radius: 15px;
            transition: all 0.3s ease;
        }

        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }

        .icon {
            font-size: 3rem;
        }

        .navbar-brand {
            font-size: 1.3rem;
        }

    </style>
</head>

<body>

<!-- Navbar -->
<nav class="navbar navbar-dark bg-dark px-4"> <!-- dark-themed  -->
    <div class="container-fluid">

        <span class="navbar-brand fw-bold">
            🏨 Hotel Reservation System
        </span>

        <div class="d-flex align-items-center">

            <span class="text-white me-3">
                Welcome, <%= user.getName() %>
            </span>

            <a href="/logout" class="btn btn-outline-light btn-sm">
                Logout
            </a>

        </div>

    </div>
</nav>

<!-- Main Content -->
<div class="container mt-5">

    <!-- Heading -->
    <div class="mb-4">
        <h2 class="fw-bold">Customer Dashboard</h2>
        <p class="text-muted">
            Manage your account and hotel reservations
        </p>
    </div>

    <!-- Dashboard Cards -->
    <div class="row g-4">

        <!-- Profile -->
        <div class="col-md-4">
            <div class="card dashboard-card shadow-sm text-center p-4 h-100">

                <div class="icon">📋</div>

                <h5 class="mt-3">My Profile</h5> <!-- user profile -->

                <p class="text-muted small">
                    View and update your personal account details
                </p>

                <a href="/customer/update"
                   class="btn btn-dark btn-sm">
                    Edit Profile
                </a>

            </div>
        </div>

        <!-- Browse Hotels -->
        <div class="col-md-4">
            <div class="card dashboard-card shadow-sm text-center p-4 h-100">

                <div class="icon">🏨</div>

                <h5 class="mt-3">Browse Hotels</h5>

                <p class="text-muted small">
                    Explore hotels and reserve rooms easily
                </p>

                <a href="/hotels"
                   class="btn btn-dark btn-sm">
                    View Hotels
                </a>

            </div>
        </div>

        <!-- My Reservations -->
        <div class="col-md-4">
            <div class="card dashboard-card shadow-sm text-center p-4 h-100">

                <div class="icon">📅</div>

                <h5 class="mt-3">My Reservations</h5>

                <p class="text-muted small">
                    View your hotel booking history and status
                </p>

                <a href="/reservations"
                   class="btn btn-dark btn-sm">
                    View Reservations
                </a>

            </div>
        </div>

        <!-- Payment History -->
        <div class="col-md-4">
            <div class="card dashboard-card shadow-sm text-center p-4 h-100">

                <div class="icon">💳</div>

                <h5 class="mt-3">Payment History</h5>

                <p class="text-muted small">
                    Review your completed hotel payments
                </p>

                <a href="/payments"
                   class="btn btn-dark btn-sm">
                    View Payments
                </a>

            </div>
        </div>

        <!-- Support -->
        <div class="col-md-4">
            <div class="card dashboard-card shadow-sm text-center p-4 h-100">

                <div class="icon">☎️</div>

                <h5 class="mt-3">Support</h5>

                <p class="text-muted small">
                    Contact support for help and assistance
                </p>

                <a href="/support"
                   class="btn btn-dark btn-sm">
                    Contact Support
                </a>

            </div>
        </div>

    </div>

</div>

<!-- Bootstrap JS -->
<script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js">
</script>

</body>
</html>