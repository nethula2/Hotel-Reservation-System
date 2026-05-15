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
        .booking-container { max-width: 800px; margin: 50px auto; }
        .card { border: none; border-radius: 20px; }
        .price-summary { background-color: #e7f1ff; border-radius: 15px; padding: 20px; }
    </style>
</head>
<body>

<div class="container booking-container">
    <div class="card shadow-lg p-5">
        <h2 class="fw-bold mb-4">Complete Your Booking</h2>
        
        <%
            com.hotelmanagement.system.model.Room room = (com.hotelmanagement.system.model.Room) request.getAttribute("room");
        %>

        <div class="row">
            <div class="col-md-7">
                <form action="/book/confirm" method="post" id="bookingForm">
                    <input type="hidden" name="roomId" value="<%= room.getId() %>">
                    <input type="hidden" name="hotelId" value="<%= room.getHotelId() %>">
                    <input type="hidden" name="nights" id="nightsInput" value="1">
                    <input type="hidden" name="totalPrice" id="totalPriceInput" value="<%= room.getPricePerNight() %>">

                    <div class="mb-4">
                        <label class="form-label fw-semibold">Check-in Date</label>
                        <input type="date" name="checkIn" id="checkIn" class="form-control" required>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold">Check-out Date</label>
                        <input type="date" name="checkOut" id="checkOut" class="form-control" required>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold">Guests</label>
                        <select class="form-select" name="guests">
                            <% for(int i=1; i<=room.getCapacity(); i++) { %>
                                <option value="<%= i %>"><%= i %> Guest<%= i > 1 ? "s" : "" %></option>
                            <% } %>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 py-3 fw-bold rounded-pill shadow-sm">Confirm Reservation</button>
                </form>
            </div>

            <div class="col-md-5">
                <div class="price-summary h-100 d-flex flex-column justify-content-center">
                    <h5 class="fw-bold mb-3">Order Summary</h5>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Room Type</span>
                        <span class="fw-semibold"><%= room.getRoomType() %></span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Price per night</span>
                        <span class="fw-semibold">$<%= room.getPricePerNight() %></span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Nights</span>
                        <span id="nightCount" class="fw-semibold">0</span>
                    </div>
                    <hr>
                    <div class="d-flex justify-content-between">
                        <span class="h5 fw-bold">Total</span>
                        <span class="h5 fw-bold text-primary" id="displayTotal">$0.00</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    const checkIn = document.getElementById('checkIn');
    const checkOut = document.getElementById('checkOut');
    const pricePerNight = <%= room.getPricePerNight() %>;

    function calculateTotal() {
        if (checkIn.value && checkOut.value) {
            const date1 = new Date(checkIn.value);
            const date2 = new Date(checkOut.value);
            const diffTime = Math.abs(date2 - date1);
            const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

            if (diffDays > 0) {
                const total = diffDays * pricePerNight;
                document.getElementById('nightCount').innerText = diffDays;
                document.getElementById('displayTotal').innerText = '$' + total.toFixed(2);
                document.getElementById('totalPriceInput').value = total;
                document.getElementById('nightsInput').value = diffDays;
            }
        }
    }

    checkIn.addEventListener('change', calculateTotal);
    checkOut.addEventListener('change', calculateTotal);
</script>

</body>
</html>
