<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.hotelmanagement.system.model.Room" %>
<%@ page import="com.hotelmanagement.system.model.Hotel" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Room Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #eeeeee; }
        .header-box {
            background-color: #343a40;
            color: white;
            padding: 30px;
            margin-bottom: 20px;
            border-bottom: 5px solid #007bff;
        }
        .my-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0,0,0,0.1);
        }
        .bg-purple { background-color: #6f42c1 !important; }
    </style>
</head>
<body>

<%
    Hotel h = (Hotel) request.getAttribute("hotel");
    List<Room> roomList = (List<Room>) request.getAttribute("rooms");
    int hId = (h != null) ? h.getId() : 0;
%>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="#">Hotel Management System</a>
        <div class="navbar-nav ms-auto">
            <a href="/hotelowner/hotels" class="nav-link">My Hotels</a>
            <a href="/logout" class="btn btn-danger btn-sm text-white">Logout</a>
        </div>
    </div>
</nav>

<div class="header-box">
    <div class="container">
        <h1><%= (h != null) ? h.getName() : "Hotel Dashboard" %></h1>
        <p>
            Location: <%= (h != null) ? h.getCity() : "Unknown" %> |
            Rating: <%= (h != null) ? h.getStarRating() : "0" %> Stars |
            Status:
            <span class="badge <%= (h != null && "APPROVED".equals(h.getStatus())) ? "bg-success" : "bg-warning text-dark" %>">
                <%= (h != null) ? h.getStatus() : "UNKNOWN" %>
            </span>
        </p>
        <div class="badge bg-info">
            Total Rooms: <%= (roomList != null) ? roomList.size() : 0 %>
        </div>
    </div>
</div>

<div class="container mt-4">
    <div class="mb-4 d-flex gap-2">
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addModal">
            + Add New Room
        </button>
        <a href="/hotelowner/edit-hotel/<%= hId %>" class="btn btn-secondary">
            Edit Hotel Info
        </a>
    </div>

    <div class="my-card">
        <% if (roomList == null || roomList.isEmpty()) { %>
            <div class="alert alert-warning">
                No rooms found. Add a room to get started.
            </div>
        <% } else { %>
            <table class="table table-striped table-bordered align-middle">
                <thead class="table-dark">
                    <tr>
                        <th>Room Number</th>
                        <th>Floor</th>
                        <th>Type</th>
                        <th>Tier</th>
                        <th>Price (LKR)</th>
                        <th>Capacity</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Room r : roomList) {
                    String tierBadgeClass = "bg-secondary";
                    if ("VIP".equalsIgnoreCase(r.getRoomTier())) {
                        tierBadgeClass = "bg-purple text-white";
                    } else if ("GOLD".equalsIgnoreCase(r.getRoomTier())) {
                        tierBadgeClass = "bg-warning text-dark";
                    }

                    String statusBadge = "bg-success";
                    if ("OCCUPIED".equals(r.getStatus()))     statusBadge = "bg-danger";
                    if ("MAINTENANCE".equals(r.getStatus()))  statusBadge = "bg-secondary";
                %>
                    <tr>
                        <td><b><%= r.getRoomNumber() %></b></td>
                        <td>Floor <%= r.getFloor() %></td>
                        <td><%= r.getRoomType() %></td>
                        <td>
                            <span class="badge <%= tierBadgeClass %>">
                                <%= r.getTierLabel() %>
                            </span>
                        </td>
                        <td class="text-danger">Rs. <%= r.getPricePerNight() %></td>
                        <td><%= r.getCapacity() %> person(s)</td>
                        <td>
                            <span class="badge <%= statusBadge %>">
                                <%= r.getStatus() %>
                            </span>
                        </td>
                        <td>
                            <a href="/hotelowner/room/<%= r.getId() %>/availability"
                               class="btn btn-info btn-sm text-white me-1">Calendar</a>
                            <button class="btn btn-warning btn-sm"
                                    data-bs-toggle="modal"
                                    data-bs-target="#editModal<%= r.getId() %>">Edit</button>
                        </td>
                    </tr>

                    <!-- Edit Room Modal -->
                    <div class="modal fade" id="editModal<%= r.getId() %>" tabindex="-1">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <form action="/hotelowner/hotel/<%= hId %>/update-room/<%= r.getId() %>" method="post">
                                    <div class="modal-header">
                                        <h5 class="modal-title">
                                            Edit Room <%= r.getRoomNumber() %>
                                        </h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="mb-3">
                                            <label class="form-label">Price per Night (LKR)</label>
                                            <input type="number" step="0.01" class="form-control"
                                                   name="pricePerNight"
                                                   value="<%= r.getPricePerNight() %>" required>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Status</label>
                                            <select name="status" class="form-select">
                                                <option value="AVAILABLE"
                                                    <%= "AVAILABLE".equals(r.getStatus()) ? "selected" : "" %>>
                                                    Available
                                                </option>
                                                <option value="OCCUPIED"
                                                    <%= "OCCUPIED".equals(r.getStatus()) ? "selected" : "" %>>
                                                    Occupied
                                                </option>
                                                <option value="MAINTENANCE"
                                                    <%= "MAINTENANCE".equals(r.getStatus()) ? "selected" : "" %>>
                                                    Maintenance
                                                </option>
                                            </select>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Description</label>
                                            <textarea class="form-control" name="description" rows="2"><%= r.getDescription() != null ? r.getDescription() : "" %></textarea>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                                data-bs-dismiss="modal">Close</button>
                                        <button type="submit" class="btn btn-primary">
                                            Save Changes
                                        </button>
                                    </div>
                                </form>

                                <!-- Delete button separate from edit form -->
                                <div class="modal-footer border-top-0 pt-0">
                                    <form action="/hotelowner/hotel/<%= hId %>/delete-room/<%= r.getId() %>"
                                          method="post"
                                          onsubmit="return confirm('Are you sure? This permanently deletes Room <%= r.getRoomNumber() %>');"
                                          class="w-100">
                                        <button type="submit" class="btn btn-outline-danger btn-sm w-100">
                                            Delete Room <%= r.getRoomNumber() %>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</div>

<!-- Add Room Modal -->
<div class="modal fade" id="addModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="/hotelowner/hotel/<%= hId %>/add-room" method="post">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Room</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Room Number</label>
                        <input type="text" class="form-control" name="roomNumber"
                               placeholder="e.g. 101" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Floor</label>
                        <input type="number" class="form-control" name="floor"
                               value="1" min="1" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Room Type</label>
                        <select name="roomType" class="form-select" required>
                            <option value="SINGLE">Single</option>
                            <option value="DOUBLE">Double</option>
                            <option value="DELUXE">Deluxe</option>
                            <option value="SUITE">Suite</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Tier</label>
                        <select name="roomTier" class="form-select" required>
                            <option value="STANDARD">Standard</option>
                            <option value="GOLD">Gold Standard</option>
                            <option value="VIP">VIP Suite</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Price per Night (LKR)</label>
                        <input type="number" step="0.01" class="form-control"
                               name="pricePerNight" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Capacity</label>
                        <input type="number" class="form-control" name="capacity"
                               min="1" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" name="description" rows="2"></textarea>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Room Image URL</label>
                        <input type="text" name="imageUrl" class="form-control"
                               placeholder="https://example.com/room-photo.jpg">
                        <div class="form-text">Paste a link to your room image.</div>
                    </div>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary"
                            data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary">Add Room</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>