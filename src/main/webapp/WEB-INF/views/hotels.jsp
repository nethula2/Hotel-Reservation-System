<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Browse Hotels | StayScape</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .hotel-card { border: none; border-radius: 15px; overflow: hidden; transition: 0.3s; height: 100%; }
        .hotel-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1); }
        .hotel-img { height: 200px; object-fit: cover; }
        .star-rating { color: #febb02; }
    </style>
</head>
<body>
<nav class="navbar navbar-dark bg-dark px-4 py-3">
    <div class="container">
        <a class="navbar-brand fw-bold fs-4" href="/customer/home">🏨 StayScape</a>
        <a href="/logout" class="btn btn-outline-light btn-sm">Logout</a>
    </div>
</nav>

<div class="container mt-5 mb-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold mb-0">Explore Available Hotels</h2>
        <a href="/customer/home" class="btn btn-dark btn-sm"><i class="fas fa-arrow-left me-1"></i> Dashboard</a>
    </div>

    <div class="row g-4">
        <c:forEach var="hotel" items="${hotels}">
            <div class="col-md-4">
                <div class="card hotel-card shadow-sm">
                    <c:choose>
                        <c:when test="${not empty hotel.imageUrl}">
                            <img src="${hotel.imageUrl}" class="card-img-top hotel-img" alt="${hotel.name}">
                        </c:when>
                        <c:otherwise>
                            <div class="bg-secondary text-white d-flex align-items-center justify-content-center hotel-img">
                                <i class="fas fa-image fa-3x"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h5 class="card-title fw-bold mb-0">${hotel.name}</h5>
                            <div class="star-rating small">
                                <c:forEach begin="1" end="${hotel.starRating}">
                                    <i class="fas fa-star"></i>
                                </c:forEach>
                            </div>
                        </div>
                        <p class="text-muted small mb-2"><i class="fas fa-map-marker-alt me-1"></i> ${hotel.city}</p>
                        <p class="card-text text-muted small" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                            ${hotel.description}
                        </p>
                        <div class="d-grid mt-3">
                            <a href="/reservation?hotelId=${hotel.id}" class="btn btn-primary">Reserve Now</a>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
        
        <c:if test="${empty hotels}">
            <div class="col-12 text-center py-5">
                <div class="bg-white p-5 rounded-4 shadow-sm">
                    <i class="fas fa-hotel fa-4x text-muted mb-3"></i>
                    <h4 class="text-muted fw-bold">No Hotels Available</h4>
                    <p class="mb-0">Check back later for new properties or try searching again.</p>
                </div>
            </div>
        </c:if>
    </div>
</div>
</body>
</html>
