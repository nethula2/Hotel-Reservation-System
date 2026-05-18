<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.hotelmanagement.system.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>All Hotel Owners</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark px-4">
    <span class="navbar-brand fw-bold">🏨 Hotel Reservation System — Admin</span>
    <a href="/admin/home" class="btn btn-outline-light btn-sm">← Back</a>
</nav>

<div class="container mt-5">
    <h3 class="mb-4">All Registered Hotel Owners</h3>

    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
    <% } %>

    <%
        List<User> owners = (List<User>) request.getAttribute("owners");
    %>

    <% if (owners == null || owners.isEmpty()) { %>
        <div class="alert alert-info">No hotel owners registered.</div>
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
                <% for (User o : owners) { %>
                    <tr>
                        <td><%= o.getId() %></td>
                        <td><%= o.getName() %></td>
                        <td><%= o.getEmail() %></td>
                        <td><%= o.getPhone() != null ? o.getPhone() : "—" %></td>
                        <td>
                            <form action="/admin/hotelowner/delete"
                                  method="post"
                                  style="display:inline"
                                  onsubmit="return confirm('Permanently delete this hotel owner and all their hotels?')">
                                <input type="hidden" name="id" value="<%= o.getId() %>">
                                <button type="submit" class="btn btn-danger btn-sm">
                                    Delete
                                </button>
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