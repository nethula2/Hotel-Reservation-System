<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Available Rooms</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Outfit', sans-serif; background-color: #f4f7f6; }
        .room-card {
            border: none;
            border-radius: 12px;
            overflow: hidden;
            background: white;
            transition: all 0.3s ease;
        }
        .room-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.05); }
        .price-tag { font-size: 1.5rem; font-weight: 600; color: #0d6efd; }
        .badge-availability { padding: 5px 12px; border-radius: 20px; font-size: 0.8rem; }
    </style>
</head>
<body>

<nav class="navbar navbar-dark bg-dark px-4 shadow-sm">
    <a class="navbar-brand fw-bold" href="/rooms/search">🏨 LUXE STAY</a>
</nav>

<div class="container py-5">
    <h2 class="mb-4 fw-bold">Select Your Room</h2>
    
    <div class="row">
        <%
            java.util.List<com.hotelmanagement.system.model.Room> rooms =
                (java.util.List<com.hotelmanagement.system.model.Room>) request.getAttribute("rooms");

            if (rooms == null || rooms.isEmpty()) {
        %>
            <div class="col-12">
                <div class="alert alert-warning">No rooms are available in this hotel at the moment.</div>
            </div>
        <% } else {
            for (com.hotelmanagement.system.model.Room room : rooms) {
        %>
            <div class="col-md-6 mb-4">
                <div class="card room-card shadow-sm h-100">
                    <div class="row g-0">
                        <div class="col-md-5">
                            <img src="https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&q=80&w=1974" class="img-fluid rounded-start h-100" style="object-fit: cover;" alt="Room">
                        </div>
                        <div class="col-md-7">
                            <div class="card-body d-flex flex-column h-100">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <h5 class="card-title fw-bold mb-0"><%= room.getRoomType() %></h5>
                                    <span class="badge badge-availability bg-success-subtle text-success">
                                        <%= room.getAvailableRooms() %> Available
                                    </span>
                                </div>
                                <p class="text-muted small mb-3">Capacity: <%= room.getCapacity() %> Guests</p>
                                <p class="card-text text-muted flex-grow-1"><%= room.getDescription() %></p>
                                <div class="mt-3 d-flex justify-content-between align-items-center">
                                    <div class="price-tag">$<%= room.getPricePerNight() %><small class="text-muted" style="font-size: 0.8rem;">/night</small></div>
                                    <a href="/book/<%= room.getId() %>" class="btn btn-primary rounded-pill px-4">Book Now</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        <%
            } }
        %>
    </div>
</div>

</body>
</html>
