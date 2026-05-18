<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.hotelmanagement.system.model.Customer" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>All Customers</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark px-4">
    <span class="navbar-brand fw-bold">🏨 Hotel Reservation System — Admin</span>
    <a href="/admin/home" class="btn btn-outline-light btn-sm">← Back</a>
</nav>

<div class="container mt-5">
    <h3 class="mb-4">All Registered Customers</h3>

    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
    <% } %>

    <%
        List<Customer> customers = (List<Customer>) request.getAttribute("customers");
    %>

    <% if (customers == null || customers.isEmpty()) { %>
        <div class="alert alert-info">No customers found.</div>
    <% } else { %>
        <div class="card shadow-sm">
            <table class="table table-hover mb-0">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Customer c : customers) { %>
                    <tr>
                        <td><%= c.getId() %></td>
                        <td><%= c.getName() %></td>
                        <td><%= c.getEmail() %></td>
                        <td><%= c.getPhone() != null ? c.getPhone() : "—" %></td>
                        <td>
                            <form action="/admin/customer/delete" method="post"
                                  style="display:inline"
                                  onsubmit="return confirm('Permanently delete this customer? This cannot be undone.')">
                                <input type="hidden" name="id" value="<%= c.getId() %>">
                                <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                            </form>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>