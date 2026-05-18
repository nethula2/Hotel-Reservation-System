<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Hotel - ${hotel.name}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark px-4">
    <span class="navbar-brand fw-bold">🏨 Hotel Reservation System</span>
    <div>
        <a href="/hotelowner/hotels" class="btn btn-outline-light btn-sm me-2">Back to My Hotels</a>
        <a href="/logout" class="btn btn-outline-light btn-sm">Logout</a>
    </div>
</nav>

<div class="container mt-5 mb-5">
    <div class="row">
        <!-- Hotel Info -->
        <div class="col-md-12 mb-4">
            <div class="card shadow-sm border-0">
                <div class="card-body">
                    <h2 class="fw-bold">${hotel.name}</h2>
                    <p class="text-muted mb-1">${hotel.address}, ${hotel.city}</p>
                    <p class="text-muted">Status: 
                        <c:choose>
                            <c:when test="${hotel.status == 'APPROVED'}">
                                <span class="badge bg-success">Approved</span>
                            </c:when>
                            <c:when test="${hotel.status == 'PENDING'}">
                                <span class="badge bg-warning text-dark">Pending</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-danger">Rejected</span>
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <p>${hotel.description}</p>
                </div>
            </div>
        </div>

        <!-- Add Room Form -->
        <div class="col-md-4">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white fw-bold">
                    Add New Room
                </div>
                <div class="card-body">
                    <form action="/hotelowner/hotel/${hotel.id}/add-room" method="post">
                        <div class="mb-3">
                            <label class="form-label">Room Type</label>
                            <select name="roomType" class="form-select" required>
                                <option value="SINGLE">Single</option>
                                <option value="DOUBLE">Double</option>
                                <option value="SUITE">Suite</option>
                                <option value="DELUXE">Deluxe</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Price Per Night ($)</label>
                            <input type="number" step="0.01" name="pricePerNight" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Capacity (Persons)</label>
                            <input type="number" name="capacity" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Total Rooms</label>
                            <input type="number" name="totalRooms" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea name="description" class="form-control" rows="3"></textarea>
                        </div>
                        <button type="submit" class="btn btn-dark w-100">Save Room</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Rooms List -->
        <div class="col-md-8">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white fw-bold">
                    Existing Rooms
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-3">Type</th>
                                    <th>Price/Night</th>
                                    <th>Capacity</th>
                                    <th>Total/Avail</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="room" items="${rooms}">
                                    <tr>
                                        <td class="ps-3 fw-bold">${room.roomType}</td>
                                        <td class="text-primary">$${room.pricePerNight}</td>
                                        <td>${room.capacity} Person(s)</td>
                                        <td>${room.availableRooms} / ${room.totalRooms}</td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty rooms}">
                                    <tr>
                                        <td colspan="4" class="text-center py-4 text-muted">
                                            No rooms added yet.
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>