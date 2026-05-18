<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservation Successful | StayScape</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #003580;
            --success-color: #008009;
        }
        body { background-color: #f5f5f5; font-family: 'Inter', sans-serif; height: 100vh; display: flex; align-items: center; justify-content: center; }
        .success-card { background: white; border-radius: 16px; padding: 40px; text-align: center; box-shadow: 0 10px 30px rgba(0,0,0,0.1); max-width: 500px; width: 100%; }
        .icon-box { background: #e6f4e7; color: var(--success-color); width: 80px; height: 80px; line-height: 80px; border-radius: 50%; font-size: 40px; margin: 0 auto 24px; }
        .btn-home { background-color: var(--primary-color); border: none; padding: 12px 30px; border-radius: 8px; font-weight: 600; }
    </style>
</head>
<body>

<div class="success-card">
    <div class="icon-box">
        <i class="fas fa-check"></i>
    </div>
    <h2 class="fw-bold mb-3">Reservation Received!</h2>
    <p class="text-muted mb-4">Your reservation has been submitted successfully and is currently <strong>Pending Verification</strong>.</p>
    
    <div class="bg-light p-3 rounded-3 mb-4 text-start">
        <div class="d-flex justify-content-between mb-2">
            <span class="text-muted">Reservation ID:</span>
            <span class="fw-bold">#RSV-${booking.id}</span>
        </div>
        <div class="d-flex justify-content-between">
            <span class="text-muted">Status:</span>
            <span class="badge bg-warning text-dark">Pending Verification</span>
        </div>
    </div>

    <p class="small text-muted mb-4">We will notify you once our team verifies your bank deposit receipt. Thank you for choosing StayScape!</p>

    <a href="/customer/home" class="btn btn-primary btn-home text-white">Back to Home</a>
</div>

</body>
</html>
