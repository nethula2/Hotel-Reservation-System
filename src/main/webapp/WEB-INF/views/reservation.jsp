<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secure Reservation | StayScape</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #003580;
            --secondary-color: #006ce4;
            --accent-color: #febb02;
            --bg-light: #f5f5f5;
        }
        body { background-color: var(--bg-light); font-family: 'Inter', sans-serif; }
        .navbar { background-color: var(--primary-color); }
        .card { border: none; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); margin-bottom: 24px; }
        .card-header { background: white; border-bottom: 1px solid #eee; padding: 20px; border-radius: 12px 12px 0 0 !important; font-weight: 700; }
        .section-title { color: var(--primary-color); font-weight: 700; margin-bottom: 20px; border-left: 5px solid var(--accent-color); padding-left: 15px; }
        .price-card { background-color: #ebf3ff; border: 1px solid var(--secondary-color); }
        .btn-primary { background-color: var(--secondary-color); border: none; padding: 12px 24px; font-weight: 600; }
        .btn-primary:hover { background-color: var(--primary-color); }
        .upload-area { border: 2px dashed #ccc; border-radius: 8px; padding: 40px; text-align: center; cursor: pointer; transition: 0.3s; background: white; }
        .upload-area:hover, .upload-area.active { border-color: var(--secondary-color); background: #f0f7ff; }
        .preview-img { max-width: 200px; max-height: 200px; border-radius: 8px; margin-top: 15px; display: none; }
    </style>
</head>
<body>

<nav class="navbar navbar-dark px-4 py-3">
    <div class="container">
        <a class="navbar-brand fw-bold fs-4" href="/customer/home">🏨 StayScape</a>
        <div class="text-white small">
            <i class="fas fa-user-circle me-1"></i> ${customer.name}
        </div>
    </div>
</nav>

<div class="container mt-4 mb-5">
    <div class="row">
        <!-- Left Column: Form -->
        <div class="col-lg-8">
            <h2 class="section-title">Complete Your Reservation</h2>
            
            <form id="reservationForm" action="/reservation/submit" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="hotelId" value="${hotel.id}">
                <input type="hidden" name="totalPrice" id="totalPriceInput">
                <input type="hidden" name="nights" id="nightsInput">
                
                <!-- Customer Details -->
                <div class="card">
                    <div class="card-header"><i class="fas fa-user me-2"></i>Customer Information</div>
                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Full Name</label>
                                <input type="text" class="form-control" name="customerName" value="${customer.name}" required readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Email Address</label>
                                <input type="email" class="form-control" name="email" value="${customer.email}" required readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Phone Number</label>
                                <input type="tel" class="form-control" name="phone" value="${customer.phone}" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">NIC / Passport Number</label>
                                <input type="text" class="form-control" name="nicPassport" placeholder="Enter ID number" required>
                            </div>
                            <div class="col-md-12">
                                <label class="form-label">Country</label>
                                <select class="form-select" name="country" required>
                                    <option value="" disabled selected>Select your country</option>
                                    <option value="Sri Lanka">Sri Lanka</option>
                                    <option value="USA">USA</option>
                                    <option value="UK">UK</option>
                                    <option value="Australia">Australia</option>
                                    <option value="India">India</option>
                                    <option value="Japan">Japan</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Special Requests (Optional)</label>
                                <textarea class="form-control" name="specialRequests" rows="3" placeholder="Any specific requirements for your stay?"></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Booking Details -->
                <div class="card">
                    <div class="card-header"><i class="fas fa-calendar-alt me-2"></i>Booking Details</div>
                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Select Room Type</label>
                                <select class="form-select" name="roomId" id="roomSelect" required onchange="calculateTotal()">
                                    <c:forEach var="room" items="${rooms}">
                                        <option value="${room.id}" data-price="${room.pricePerNight}" ${room.id == selectedRoomId ? 'selected' : ''}>
                                            ${room.roomType} - $${room.pricePerNight} / night
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Guests</label>
                                <input type="number" class="form-control" name="guests" value="1" min="1" max="10" required onchange="calculateTotal()">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Check-in Date</label>
                                <input type="date" class="form-control" name="checkIn" id="checkIn" required onchange="calculateTotal()">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Check-out Date</label>
                                <input type="date" class="form-control" name="checkOut" id="checkOut" required onchange="calculateTotal()">
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Payment Section -->
                <div class="card">
                    <div class="card-header"><i class="fas fa-credit-card me-2"></i>Bank Deposit Payment</div>
                    <div class="card-body">
                        <div class="alert alert-warning mb-4">
                            <strong>Bank Details:</strong><br>
                            Bank: Commercial Bank<br>
                            Account Name: StayScape PVT LTD<br>
                            Account Number: 1000234567<br>
                            Branch: Colombo 07
                        </div>
                        
                        <div class="upload-area" id="dropZone">
                            <i class="fas fa-cloud-upload-alt fa-3x text-muted mb-3"></i>
                            <h5>Drag & Drop Bank Receipt</h5>
                            <p class="text-muted">or click to browse (JPG, PNG, PDF)</p>
                            <input type="file" name="paymentSlip" id="fileInput" accept=".jpg,.jpeg,.png,.pdf" hidden required>
                            <div id="fileInfo" class="mt-2 text-primary fw-bold"></div>
                            <img id="imagePreview" class="preview-img mx-auto" alt="Payment preview">
                        </div>
                        <p class="small text-danger mt-3">
                            <i class="fas fa-info-circle me-1"></i> Please upload the exact bank deposit slip or payment receipt for reservation verification.
                        </p>
                    </div>
                </div>

                <div class="d-grid mb-5">
                    <button type="submit" class="btn btn-primary btn-lg">Confirm Reservation</button>
                </div>
            </form>
        </div>

        <!-- Right Column: Summary -->
        <div class="col-lg-4">
            <div class="sticky-top" style="top: 20px;">
                <div class="card">
                    <img src="${hotel.imageUrl}" class="card-img-top" alt="${hotel.name}" style="height: 180px; object-fit: cover;">
                    <div class="card-body">
                        <h5 class="fw-bold">${hotel.name}</h5>
                        <div class="text-warning mb-2">
                            <c:forEach begin="1" end="${hotel.starRating}">
                                <i class="fas fa-star"></i>
                            </c:forEach>
                        </div>
                        <p class="small text-muted"><i class="fas fa-map-marker-alt me-1"></i> ${hotel.city}</p>
                    </div>
                </div>

                <div class="card price-card">
                    <div class="card-header border-0 pb-0" style="background: transparent;">Your Price Summary</div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between mb-2">
                            <span>Room Charge</span>
                            <span id="roomCharge">$0.00</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Taxes (10%)</span>
                            <span id="taxCharge">$0.00</span>
                        </div>
                        <div class="d-flex justify-content-between mb-3">
                            <span>Service Fee</span>
                            <span id="serviceCharge">$5.00</span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between">
                            <h5 class="fw-bold">Total Price</h5>
                            <h5 class="fw-bold text-primary" id="finalPrice">$0.00</h5>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    const dropZone = document.getElementById('dropZone');
    const fileInput = document.getElementById('fileInput');
    const fileInfo = document.getElementById('fileInfo');
    const imagePreview = document.getElementById('imagePreview');

    dropZone.onclick = () => fileInput.click();

    fileInput.onchange = (e) => handleFiles(e.target.files);

    dropZone.ondragover = (e) => {
        e.preventDefault();
        dropZone.classList.add('active');
    };

    dropZone.ondragleave = () => dropZone.classList.remove('active');

    dropZone.ondrop = (e) => {
        e.preventDefault();
        dropZone.classList.remove('active');
        handleFiles(e.dataTransfer.files);
    };

    function handleFiles(files) {
        if (files.length > 0) {
            const file = files[0];
            fileInfo.textContent = file.name;
            
            if (file.type.startsWith('image/')) {
                const reader = new FileReader();
                reader.onload = (e) => {
                    imagePreview.src = e.target.result;
                    imagePreview.style.display = 'block';
                };
                reader.readAsDataURL(file);
            } else {
                imagePreview.style.display = 'none';
            }
        }
    }

    function calculateTotal() {
        const roomSelect = document.getElementById('roomSelect');
        const pricePerNight = parseFloat(roomSelect.options[roomSelect.selectedIndex].getAttribute('data-price'));
        const checkInVal = document.getElementById('checkIn').value;
        const checkOutVal = document.getElementById('checkOut').value;
        
        if (checkInVal && checkOutVal) {
            const checkIn = new Date(checkInVal);
            const checkOut = new Date(checkOutVal);
            
            if (checkOut > checkIn) {
                const diffTime = Math.abs(checkOut - checkIn);
                const nights = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
                
                const subtotal = pricePerNight * nights;
                const tax = subtotal * 0.1;
                const service = 5.00;
                const total = subtotal + tax + service;

                document.getElementById('roomCharge').textContent = '$' + subtotal.toFixed(2);
                document.getElementById('taxCharge').textContent = '$' + tax.toFixed(2);
                document.getElementById('serviceCharge').textContent = '$' + service.toFixed(2);
                document.getElementById('finalPrice').textContent = '$' + total.toFixed(2);
                
                document.getElementById('totalPriceInput').value = total.toFixed(2);
                document.getElementById('nightsInput').value = nights;
            }
        }
    }

    // Set default dates
    window.onload = () => {
        const today = new Date().toISOString().split('T')[0];
        const tomorrow = new Date(new Date().getTime() + 24 * 60 * 60 * 1000).toISOString().split('T')[0];
        document.getElementById('checkIn').value = today;
        document.getElementById('checkOut').value = tomorrow;
        calculateTotal();
    };
</script>

</body>
</html>
