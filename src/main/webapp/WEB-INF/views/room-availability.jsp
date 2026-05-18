<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.hotelmanagement.system.model.Room" %>
<%@ page import="com.hotelmanagement.system.model.Booking" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.YearMonth" %>
<%@ page import="java.util.ArrayList" %>
<%
    Room room = (Room) request.getAttribute("room");
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Room Availability - Hotel Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .calendar-day {
            height: 45px;
            width: 14.28%;
            border: 1px solid #dee2e6;
            padding: 1px 3px;
            position: relative;
        }
        .available {
            background-color: #d4edda !important;
            color: #155724 !important;
        }

        .reserved {
            background-color: #f8d7da !important;
            color: #721c24 !important;
        }

        .today {
            border: 2px solid #007bff !important;
        }
        .day-number {
            font-weight: bold;
            font-size: 0.9rem;
        }
        .status-text {
            font-size: 0.6rem;
            position: absolute;
            bottom: 2px;
            right: 5px;
        }
    </style>
</head>
<body class="bg-light">

    <nav class="navbar navbar-dark bg-dark">
        <div class="container">
            <span class="navbar-brand">Availability Checker</span>
            <%
                com.hotelmanagement.system.model.User user = (com.hotelmanagement.system.model.User) session.getAttribute("loggedUser");
                if (user != null && user.getRole().equals("HOTEL_OWNER")) {
            %>
                <a href="/hotelowner/hotel/<%= room.getHotelId() %>" class="btn btn-outline-light btn-sm">Back to Management</a>
            <% } else { %>
                <button onclick="window.close();" class="btn btn-outline-light btn-sm">Close & Return to Booking</button>
            <% } %>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-9">
                <div class="card shadow-sm mb-4">
                    <div class="card-body">
                        <h3>Availability for <%= room.getRoomType() %> - Room #<%= room.getRoomNumber() %></h3>
                        <p class="text-muted">Viewing availability for <strong><%= LocalDate.now().getMonth() %> <%= LocalDate.now().getYear() %></strong></p>
                        <div class="d-flex gap-3 mb-3">
                            <span><span class="badge bg-success">&nbsp;&nbsp;</span> Available</span>
                            <span><span class="badge bg-danger">&nbsp;&nbsp;</span> Reserved / Occupied</span>
                        </div>
                    </div>
                </div>

                <div class="card shadow-sm">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-bordered mb-0" style="table-layout: fixed;">
                                <thead class="bg-secondary text-white text-center">
                                    <tr>
                                        <th>Mon</th>
                                        <th>Tue</th>
                                        <th>Wed</th>
                                        <th>Thu</th>
                                        <th>Fri</th>
                                        <th>Sat</th>
                                        <th>Sun</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        LocalDate today = LocalDate.now();
                                        YearMonth yearMonth = YearMonth.from(today);
                                        LocalDate firstOfMonth = yearMonth.atDay(1);
                                        int daysInMonth = yearMonth.lengthOfMonth();
                                        int startOffset = firstOfMonth.getDayOfWeek().getValue() - 1; // 0 for Mon, 6 for Sun

                                        int dayCounter = 1;
                                        for (int r = 0; r < 6; r++) { // Up to 6 weeks
                                    %>
                                    <tr>
                                        <%
                                            for (int c = 0; c < 7; c++) {
                                                int currentIdx = r * 7 + c;
                                                if (currentIdx < startOffset || dayCounter > daysInMonth) {
                                        %>
                                        <td class="calendar-day bg-white"></td>
                                        <%
                                                } else {
                                                    LocalDate currentDate = firstOfMonth.withDayOfMonth(dayCounter);
                                                    boolean isReserved = false;

                                                    // Simple check if this date is within any booking range
                                                    if (bookings != null) {
                                                        for (Booking b : bookings) {
                                                            LocalDate checkIn = b.getCheckIn().toLocalDate();
                                                            LocalDate checkOut = b.getCheckOut().toLocalDate();

                                                            // If date is >= checkIn and < checkOut (last day is checkout day)
                                                            if (!currentDate.isBefore(checkIn) && currentDate.isBefore(checkOut)) {
                                                                isReserved = true;
                                                                break;
                                                            }
                                                        }
                                                    }

                                                    String statusClass = isReserved ? "reserved" : "available";
                                                    if (currentDate.equals(today)) statusClass += " today";
                                        %>
                                        <td class="calendar-day <%= statusClass %>">
                                            <div class="day-number"><%= dayCounter %></div>
                                            <div class="status-text">
                                                <%= isReserved ? "Reserved" : "Free" %>
                                            </div>
                                        </td>
                                        <%
                                                    dayCounter++;
                                                }
                                            }
                                        %>
                                    </tr>
                                    <%
                                            if (dayCounter > daysInMonth) break;
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-md-9 mt-2 mb-5">

                <div class="card shadow-sm">

                    <div class="card-header bg-dark text-white">
                        <h5 class="mb-0">Current Bookings List</h5>
                    </div>

                    <div class="card-body">
                        <table class="table table-sm table-hover">
                            <thead>
                                <tr>
                                    <th>Check In</th>
                                    <th>Check Out</th>
                                    <th>Status</th>
                                </tr>
                            </thead>

                            <tbody>
                                <% if (bookings == null || bookings.isEmpty()) { %>

                                    <tr>
                                        <td colspan="3" class="text-center text-muted">
                                            No bookings found for this room.
                                        </td>
                                    </tr>

                                <% } else {
                                    for (Booking b : bookings) { %>

                                    <tr>
                                        <td><%= b.getCheckIn() %></td>
                                        <td><%= b.getCheckOut() %></td>
                                        <td>
                                            <span class="badge bg-primary">
                                                <%= b.getStatus() %>
                                            </span>
                                        </td>
                                    </tr>

                                <%  }
                                   } %>

                            </tbody>
                        </table>
                    </div>

                </div>

            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
