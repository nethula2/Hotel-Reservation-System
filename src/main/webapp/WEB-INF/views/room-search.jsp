<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Find Your Perfect Stay</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Outfit', sans-serif; background-color: #f8f9fa; }
        .hero-section {
            background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)), url('https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&q=80&w=2070');
            background-size: cover;
            background-position: center;
            color: white;
            padding: 100px 0;
            text-align: center;
        }
        .hotel-card {
            border: none;
            border-radius: 15px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            overflow: hidden;
            margin-bottom: 30px;
        }
        .hotel-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.1);
        }
        .star-rating { color: #ffc107; }
        .btn-primary { background-color: #0d6efd; border: none; border-radius: 8px; padding: 10px 20px; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark px-4 shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="/">🏨 LUXE STAY</a>
        <div class="ms-auto">
            <a href="/login" class="btn btn-outline-light btn-sm rounded-pill px-4">Sign In</a>
        </div>
    </div>
</nav>

<header class="hero-section">
    <div class="container">
        <h1 class="display-3 fw-bold mb-3">Discover Your Next Adventure</h1>
        <p class="lead mb-4">Book exclusive hotels and resorts at the best prices.</p>
    </div>
</header>

<main class="container mt-n5">
    <div class="row">
        <%
            java.util.List<com.hotelmanagement.system.model.Hotel> hotels =
                (java.util.List<com.hotelmanagement.system.model.Hotel>) request.getAttribute("hotels");

            if (hotels == null || hotels.isEmpty()) {
        %>
            <div class="col-12 text-center py-5">
                <div class="alert alert-light shadow-sm">No hotels are currently available for booking.</div>
            </div>
        <% } else {
            for (com.hotelmanagement.system.model.Hotel hotel : hotels) {
        %>
            <div class="col-md-4">
                <div class="card hotel-card shadow-sm">
                    <img src="<%= hotel.getImageUrl() != null ? hotel.getImageUrl() : "https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&q=80&w=2070" %>" class="card-img-top" alt="Hotel" style="height: 200px; object-fit: cover;">
                    <div class="card-body p-4">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h5 class="card-title mb-0 fw-bold"><%= hotel.getName() %></h5>
                            <div class="star-rating">
                                <% for(int i=0; i<hotel.getStarRating(); i++) { %>★<% } %>
                            </div>
                        </div>
                        <p class="text-muted small mb-3"><i class="bi bi-geo-alt"></i> <%= hotel.getCity() %></p>
                        <p class="card-text text-truncate" style="max-height: 3em;"><%= hotel.getDescription() %></p>
                        <a href="/hotel/<%= hotel.getId() %>/rooms" class="btn btn-primary w-100 mt-3">View Rooms</a>
                    </div>
                </div>
            </div>
        <%
            } }
        %>
    </div>
</main>

<footer class="bg-dark text-white py-4 mt-5">
    <div class="container text-center">
        <p class="mb-0">&copy; 2026 Luxe Stay Hotel Reservation System. All rights reserved.</p>
    </div>
</footer>

</body>
</html>
