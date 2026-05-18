<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.hotelmanagement.system.model.User" %>
<%
    User user = (User) session.getAttribute("loggedUser");
    if (user == null) {
        response.sendRedirect("/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Support</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark px-4">
    <span class="navbar-brand fw-bold">🏨 Hotel Reservation System</span>
    <a href="/customer/home" class="btn btn-outline-light btn-sm">← Back</a>
</nav>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-7">

            <div class="card shadow p-4 mb-4">
                <h3 class="mb-1">Contact Support</h3>
                <p class="text-muted mb-4">We are here to help. Reach us through any of the channels below.</p>

                <div class="mb-3 d-flex align-items-center gap-3">
                    <span style="font-size:1.5rem">📧</span>
                    <div>
                        <div class="fw-bold">Email</div>
                        <div class="text-muted">support@hotel.com</div>
                    </div>
                </div>

                <div class="mb-3 d-flex align-items-center gap-3">
                    <span style="font-size:1.5rem">📞</span>
                    <div>
                        <div class="fw-bold">Phone</div>
                        <div class="text-muted">+94 11 666 7878</div>
                    </div>
                </div>

                <div class="mb-3 d-flex align-items-center gap-3">
                    <span style="font-size:1.5rem">🕐</span>
                    <div>
                        <div class="fw-bold">Working Hours</div>
                        <div class="text-muted"> 24 x 7 </div>
                    </div>
                </div>

                <div class="d-flex align-items-center gap-3">
                    <span style="font-size:1.5rem">📍</span>
                    <div>
                        <div class="fw-bold">Office</div>
                        <div class="text-muted">No-653, Galle Road, Colombo 03, Sri Lanka</div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>