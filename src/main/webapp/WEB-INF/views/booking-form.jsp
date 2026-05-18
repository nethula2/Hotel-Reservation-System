<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.hotelmanagement.system.model.Room" %>
<%@ page import="com.hotelmanagement.system.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complete Your Booking</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Outfit', sans-serif; background-color: #f0f2f5; }
        .booking-container { max-width: 900px; margin: 50px auto; }
        .card { border: none; border-radius: 20px; }
        .price-summary { background-color: #e7f1ff; border-radius: 15px; padding: 20px; }
    </style>
</head>
<body>

<%
    Room room = (Room) request.getAttribute("room");
    int hotelId = (Integer) request.getAttribute("hotelId");
    User user = (User) session.getAttribute("loggedUser");
%>

<nav class="navbar navbar-dark bg-dark px-4">
    <span class="navbar-brand fw-bold">🏨 Hotel Reservation System</span>
    <a href="/hotels" class="btn btn-outline-light btn-sm">← Back to Hotels</a>
</nav>

<div class="container booking-container">
    <div class="card shadow-lg p-5">
        <h2 class="fw-bold mb-1">Complete Your Booking</h2>
        <p class="text-muted mb-4">
            Room <%= room.getRoomNumber() %> —
            <%= room.getRoomType() %> |
            Floor <%= room.getFloor() %> |
            <%= room.getTierLabel() %>
        </p>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
        <% } %>

        <div class="row g-4">

            <!-- Booking Form -->
            <div class="col-md-7">
                <form action="/booking/confirm"
                      method="post"
                      enctype="multipart/form-data"
                      id="bookingForm">

                    <input type="hidden" name="roomId"     value="<%= room.getId() %>">
                    <input type="hidden" name="hotelId"    value="<%= hotelId %>">
                    <input type="hidden" name="nights"     id="nightsInput" value="1">
                    <input type="hidden" name="totalPrice" id="totalPriceInput"
                           value="<%= room.getPricePerNight() %>">

                    <h5 class="fw-bold mb-3">Stay Details</h5>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Check-in Date</label>
                        <input type="date" name="checkIn" id="checkIn"
                               class="form-control" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Check-out Date</label>
                        <input type="date" name="checkOut" id="checkOut"
                               class="form-control" required>
                    </div>

                    <hr>
                    <h5 class="fw-bold mb-3">Guest Details</h5>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Full Name</label>
                        <input type="text" class="form-control"
                               value="<%= user.getName() %>" disabled>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">NIC / Passport Number</label>
                        <input type="text" name="nicPassport"
                               class="form-control"
                               placeholder="e.g. 123456789V" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Country</label>
                        <input type="text" name="country"
                               class="form-control"
                               placeholder="e.g. Sri Lanka" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Special Requests</label>
                        <textarea name="specialRequests" class="form-control"
                                  rows="2"
                                  placeholder="Any special requests or notes..."></textarea>
                    </div>

                    <hr>
                    <h5 class="fw-bold mb-3">Payment</h5>

                    <div class="mb-4">
                        <label class="form-label fw-semibold">Upload Payment Slip</label>
                        <input type="file" name="paymentSlip"
                               class="form-control"
                               accept="image/*,.pdf" required>
                        <div class="form-text">
                            Accepted formats: JPG, PNG, PDF. Max size: 5MB.
                        </div>
                    </div>

                    <button type="submit"
                            class="btn btn-dark w-100 py-3 fw-bold rounded-pill shadow-sm">
                        Confirm Reservation
                    </button>
                </form>
            </div>

            <!-- Order Summary -->
            <div class="col-md-5">
                <div class="price-summary h-100 d-flex flex-column justify-content-center">
                    <h5 class="fw-bold mb-3">Order Summary</h5>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Room</span>
                        <span class="fw-semibold">
                            #<%= room.getRoomNumber() %>
                        </span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Type</span>
                        <span class="fw-semibold"><%= room.getRoomType() %></span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Tier</span>
                        <span class="fw-semibold"><%= room.getTierLabel() %></span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Capacity</span>
                        <span class="fw-semibold">
                            <%= room.getCapacity() %> person(s)
                        </span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Price per night</span>
                        <span class="fw-semibold">
                            Rs. <%= room.getPricePerNight() %>
                        </span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Nights</span>
                        <span id="nightCount" class="fw-semibold">—</span>
                    </div>
                    <hr>
                    <div class="d-flex justify-content-between">
                        <span class="h5 fw-bold">Total</span>
                        <span class="h5 fw-bold text-primary" id="displayTotal">
                            Rs. 0.00
                        </span>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<script>
    const checkInEl  = document.getElementById('checkIn');
    const checkOutEl = document.getElementById('checkOut');
    const pricePerNight = <%= room.getPricePerNight() %>;

    // Set minimum date to today
    const today = new Date().toISOString().split('T')[0];
    checkInEl.setAttribute('min', today);
    checkOutEl.setAttribute('min', today);

    function calculateTotal() {
        if (checkInEl.value && checkOutEl.value) {
            const date1   = new Date(checkInEl.value);
            const date2   = new Date(checkOutEl.value);
            const diffMs  = date2 - date1;
            const nights  = Math.ceil(diffMs / (1000 * 60 * 60 * 24));

            if (nights > 0) {
                const total = nights * pricePerNight;
                document.getElementById('nightCount').innerText     = nights;
                document.getElementById('displayTotal').innerText   = 'Rs. ' + total.toFixed(2);
                document.getElementById('totalPriceInput').value    = total;
                document.getElementById('nightsInput').value        = nights;
            }
        }
    }

    checkInEl.addEventListener('change',  calculateTotal);
    checkOutEl.addEventListener('change', calculateTotal);

    // Validate dates before form submission
    document.getElementById('bookingForm').addEventListener('submit', function(e) {
        const checkInVal  = new Date(checkInEl.value);
        const checkOutVal = new Date(checkOutEl.value);
        const todayVal    = new Date();
        todayVal.setHours(0, 0, 0, 0);

        if (!checkInEl.value || !checkOutEl.value) {
            e.preventDefault();
            alert('Please select both check-in and check-out dates.');
            return;
        }

        if (checkInVal < todayVal) {
            e.preventDefault();
            alert('Check-in date cannot be in the past.');
            return;
        }

        if (checkOutVal <= checkInVal) {
            e.preventDefault();
            alert('Check-out date must be after check-in date.');
            return;
        }

        const nights = Math.ceil((checkOutVal - checkInVal) / (1000 * 60 * 60 * 24));
        if (nights < 1) {
            e.preventDefault();
            alert('Minimum stay is 1 night.');
            return;
        }
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>