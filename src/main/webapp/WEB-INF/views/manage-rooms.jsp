<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Rooms</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark px-4">
    <span class="navbar-brand fw-bold">🏨 Hotel Reservation System</span>
    <div>
        <a href="/hotelowner/hotels" class="btn btn-outline-light btn-sm me-2">Back to Hotels</a>
        <a href="/logout" class="btn btn-outline-light btn-sm">Logout</a>
    </div>
</nav>

<div class="container mt-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Manage Rooms</h2>
        <button class="btn btn-dark" data-bs-toggle="modal" data-bs-target="#addRoomModal">+ Add New Room</button>
    </div>

    <%
        java.util.List<com.hotelmanagement.system.model.Room> rooms =
            (java.util.List<com.hotelmanagement.system.model.Room>) request.getAttribute("rooms");
        Integer hotelId = (Integer) request.getAttribute("hotelId");

        if (rooms == null || rooms.isEmpty()) {
    %>
        <div class="alert alert-info text-center py-5 shadow-sm">
            <h4 class="alert-heading">No Rooms Found</h4>
            <p>You haven't added any rooms to this hotel yet.</p>
            <hr>
            <p class="mb-0">Click the "Add New Room" button above to get started!</p>
        </div>
    <% } else { %>
        <div class="table-responsive">
            <table class="table table-bordered table-hover table-striped align-middle bg-white shadow-sm">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Type</th>
                        <th>Price/Night ($)</th>
                        <th>Capacity</th>
                        <th>Available / Total</th>
                        <th>Description</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% for (com.hotelmanagement.system.model.Room room : rooms) { %>
                    <tr>
                        <td><%= room.getId() %></td>
                        <td><%= room.getRoomType() %></td>
                        <td>$<%= String.format("%.2f", room.getPricePerNight()) %></td>
                        <td><%= room.getCapacity() %> Person(s)</td>
                        <td>
                            <span class="badge bg-primary"><%= room.getAvailableRooms() %> / <%= room.getTotalRooms() %></span>
                        </td>
                        <td><%= room.getDescription() %></td>
                        <td>
                            <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#editRoomModal<%= room.getId() %>">Edit</button>
                            
                            <form action="/hotelowner/hotel/<%= hotelId %>/delete-room/<%= room.getId() %>" method="post" class="d-inline" onsubmit="return confirm('Are you sure you want to delete this room?');">
                                <button type="submit" class="btn btn-sm btn-outline-danger">Delete</button>
                            </form>
                        </td>
                    </tr>

                    <!-- Edit Room Modal for this Room -->
                    <div class="modal fade" id="editRoomModal<%= room.getId() %>" tabindex="-1" aria-labelledby="editRoomModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <form action="/hotelowner/hotel/<%= hotelId %>/update-room/<%= room.getId() %>" method="post">
                                    <div class="modal-header">
                                        <h5 class="modal-title">Edit Room #<%= room.getId() %></h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="mb-3">
                                            <label class="form-label">Price Per Night ($)</label>
                                            <input type="number" step="0.01" class="form-control" name="pricePerNight" value="<%= room.getPricePerNight() %>" required>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Available Rooms</label>
                                            <input type="number" class="form-control" name="availableRooms" value="<%= room.getAvailableRooms() %>" required min="0" max="<%= room.getTotalRooms() %>">
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                        <button type="submit" class="btn btn-primary">Save Changes</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                <% } %>
                </tbody>
            </table>
        </div>
    <% } %>
</div>

<!-- Add Room Modal -->
<div class="modal fade" id="addRoomModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="/hotelowner/hotel/<%= request.getAttribute("hotelId") %>/add-room" method="post">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Room</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Room Type</label>
                        <select name="roomType" class="form-select" required>
                            <option value="SINGLE">Single</option>
                            <option value="DOUBLE">Double</option>
                            <option value="DELUXE">Deluxe (Luxury Room)</option>
                            <option value="SUITE">Suite (Luxury Room)</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Price Per Night ($)</label>
                        <input type="number" step="0.01" class="form-control" name="pricePerNight" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Capacity (Persons)</label>
                        <input type="number" class="form-control" name="capacity" required min="1">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Total Rooms</label>
                        <input type="number" class="form-control" name="totalRooms" required min="1">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" name="description" rows="2"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-dark">Add Room</button>
                </div>
            </form>
        </div>
    </div>
</div>

</body>
</html>
