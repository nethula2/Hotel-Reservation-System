<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Hotel Room Reservation System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            margin: 0;
            padding: 0;
            min-height: 100vh;
            background-image: url('https://img.freepik.com/premium-photo/abstract-blur-defocused-hotel-lobby-interior-background-vintage-filter_875825-64135.jpg?semt=ais_hybrid&w=740&q=80');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }

        .overlay {
            min-height: 100vh;
            background: rgba(0, 0, 0, 0.55);
            display: flex;
            flex-direction: column;
        }

        .hero {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 60px 20px;
            color: white;
        }

        .group-badge {
            display: inline-block;
            background: rgba(255,255,255,0.15);
            border: 1px solid rgba(255,255,255,0.3);
            color: white;
            font-size: 13px;
            letter-spacing: 0.1em;
            padding: 6px 18px;
            border-radius: 50px;
            margin-bottom: 24px;
        }

        .hero h1 {
            font-size: 3rem;
            font-weight: 700;
            letter-spacing: -0.5px;
            margin-bottom: 16px;
            text-shadow: 0 2px 8px rgba(0,0,0,0.4);
        }

        .hero p {
            font-size: 1.15rem;
            color: rgba(255,255,255,0.8);
            max-width: 480px;
            margin-bottom: 36px;
        }

        .btn-hero-primary {
            background: white;
            color: #111;
            font-weight: 600;
            padding: 12px 36px;
            border-radius: 50px;
            border: none;
            font-size: 1rem;
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .btn-hero-primary:hover {
            background: #f0f0f0;
            color: #111;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.3);
        }

        .btn-hero-secondary {
            background: transparent;
            color: white;
            font-weight: 500;
            padding: 12px 36px;
            border-radius: 50px;
            border: 2px solid rgba(255,255,255,0.6);
            font-size: 1rem;
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .btn-hero-secondary:hover {
            background: rgba(255,255,255,0.1);
            color: white;
            border-color: white;
            transform: translateY(-2px);
        }

        .footer-credit {
            text-align: center;
            color: rgba(255,255,255,0.4);
            font-size: 12px;
            padding: 16px;
        }
    </style>
</head>
<body>

<div class="overlay">

    <nav class="navbar px-4" style="background: rgba(0,0,0,0.3);">
        <span class="navbar-brand fw-bold text-white" style="font-size:1.1rem;">
          Hotel Room Reservation System
        </span>
        <a href="/login" class="btn btn-outline-light btn-sm">Login</a>
    </nav>

    <div class="hero">
        <div class="group-badge">Group WD034</div>
        <h1>Hotel Room Reservation System</h1>
        <p>Find and book your perfect stay with ease. Browse hotels, choose your room and reserve in minutes.</p>
        <div class="d-flex gap-3 flex-wrap justify-content-center">
            <a href="/register" class="btn-hero-primary">Get Started</a>
            <a href="/login" class="btn-hero-secondary">Login</a>
        </div>
    </div>

    <div class="footer-credit">
        © 2026 Hotel Room Reservation System — WD034
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>