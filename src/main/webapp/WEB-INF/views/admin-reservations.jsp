<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Reservations | Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<nav class="navbar navbar-dark bg-dark px-4 py-3">
    <div class="container-fluid">
        <span class="navbar-brand fw-bold fs-4">🏨 Admin Dashboard</span>
        <a href="/logout" class="btn btn-outline-light btn-sm">Logout</a>
    </div>
</nav>

<div class="container mt-5 mb-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold">Manage Customer Reservations</h2>
        <a href="/admin/home" class="btn btn-dark btn-sm">Back to Dashboard</a>
    </div>

    <div class="card shadow-sm border-0" style="border-radius: 15px; overflow: hidden;">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-4">ID</th>
                            <th>Customer</th>
                            <th>Hotel</th>
                            <th>Room</th>
                            <th>Total Price</th>
                            <th>Payment Slip</th>
                            <th>Status</th>
                            <th class="pe-4 text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="booking" items="${bookings}">
                            <tr>
                                <td class="ps-4 fw-bold">#RSV-${booking.id}</td>
                                <td>
                                    <div class="fw-bold">${booking.customerName}</div>
                                    <div class="small text-muted">NIC: ${booking.nicPassport}</div>
                                </td>
                                <td>${booking.hotelName}</td>
                                <td>${booking.roomType}</td>
                                <td class="fw-bold text-primary">$${booking.totalPrice}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty booking.paymentSlipUrl}">
                                            <a href="${booking.paymentSlipUrl}" target="_blank" class="btn btn-sm btn-info text-white">
                                                <i class="fas fa-eye me-1"></i> View Slip
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted small">No Slip Uploaded</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${booking.status == 'PENDING_VERIFICATION' || booking.status == 'PENDING'}">
                                            <span class="badge bg-warning text-dark">Pending Verification</span>
                                        </c:when>
                                        <c:when test="${booking.status == 'CONFIRMED'}">
                                            <span class="badge bg-success">Confirmed</span>
                                        </c:when>
                                        <c:when test="${booking.status == 'REJECTED'}">
                                            <span class="badge bg-danger">Rejected</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">${booking.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="pe-4 text-end">
                                    <c:if test="${booking.status == 'PENDING_VERIFICATION' || booking.status == 'PENDING'}">
                                        <div class="btn-group">
                                            <form action="/admin/reservation/status" method="POST" style="display:inline;">
                                                <input type="hidden" name="bookingId" value="${booking.id}">
                                                <input type="hidden" name="status" value="CONFIRMED">
                                                <button type="submit" class="btn btn-sm btn-success">Approve</button>
                                            </form>
                                            <form action="/admin/reservation/status" method="POST" style="display:inline; margin-left: 5px;">
                                                <input type="hidden" name="bookingId" value="${booking.id}">
                                                <input type="hidden" name="status" value="REJECTED">
                                                <button type="submit" class="btn btn-sm btn-danger">Reject</button>
                                            </form>
                                        </div>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <c:if test="${empty bookings}">
                <div class="text-center py-5">
                    <i class="fas fa-calendar-times fa-4x text-muted mb-3"></i>
                    <h5 class="text-muted">No reservations to manage at the moment.</h5>
                </div>
            </c:if>
        </div>
    </div>
</div>
</body>
</html>
