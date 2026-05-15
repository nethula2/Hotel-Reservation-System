<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Confirmed!</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Outfit', sans-serif; background-color: #f8f9fa; display: flex; align-items: center; justify-content: center; height: 100vh; margin: 0; }
        .confirmation-card { max-width: 500px; text-align: center; padding: 50px; border-radius: 30px; background: white; border: none; }
        .success-icon { font-size: 80px; color: #198754; margin-bottom: 20px; }
    </style>
</head>
<body>

<div class="card confirmation-card shadow-lg">
    <div class="success-icon">✓</div>
    <h1 class="fw-bold mb-3">Reservation Received!</h1>
    <p class="text-muted mb-4">Your booking request has been sent to the hotel owner for approval. You will receive a confirmation email shortly.</p>
    
    <div class="alert alert-success-subtle border-0 rounded-pill py-2">
        Status: <span class="fw-bold">PENDING APPROVAL</span>
    </div>

    <div class="mt-5">
        <a href="/rooms/search" class="btn btn-primary rounded-pill px-5 py-2 fw-semibold">Back to Search</a>
    </div>
</div>

</body>
</html>
