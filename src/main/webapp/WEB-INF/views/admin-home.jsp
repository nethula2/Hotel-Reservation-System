<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.hotelmanagement.system.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
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
    <h2 class="mb-1">Admin Dashboard</h2>
    <p class="text-muted mb-4">Manage the entire system from here</p>

    <div class="row g-4">

        <div class="col-md-4">
            <div class="card h-100 shadow-sm">
                <div class="card-body text-center p-4">
                    <div style="font-size:2rem">🏨</div>
                    <h5 class="card-title mt-2">Hotel Requests</h5>
                    <p class="card-text text-muted">
                        Review pending hotel submissions and approve or reject them.
                    </p>
                    <a href="/admin/pending-hotels" class="btn btn-dark w-100">
                        View Requests
                    </a>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card h-100 shadow-sm">
                <div class="card-body text-center p-4">
                    <div style="font-size:2rem">👤</div>
                    <h5 class="card-title mt-2">Customers</h5>
                    <p class="card-text text-muted">
                        View and permanently remove customer accounts.
                    </p>
                    <a href="/admin/customers" class="btn btn-dark w-100">
                        Manage Customers
                    </a>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card h-100 shadow-sm">
                <div class="card-body text-center p-4">
                    <div style="font-size:2rem">🏢</div>
                    <h5 class="card-title mt-2">Hotel Owners</h5>
                    <p class="card-text text-muted">
                        View and permanently remove hotel owner accounts.
                    </p>
                    <a href="/admin/hotelowners" class="btn btn-dark w-100">
                        Manage Owners
                    </a>
                </div>
            </div>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>