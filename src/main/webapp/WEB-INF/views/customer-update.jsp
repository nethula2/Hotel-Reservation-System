<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ page import="com.hotelmanagement.system.model.User" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Update Profile</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        </head>

        <body class="bg-light">

            <nav class="navbar navbar-dark bg-dark px-4">
                <span class="navbar-brand fw-bold">🏨 Hotel Reservation System</span>
                <a href="/customer/home" class="btn btn-outline-light btn-sm">← Back</a>
            </nav>

            <div class="container d-flex justify-content-center mt-5">
                <div class="card shadow p-4" style="width:480px">
                    <h3 class="mb-4 text-center">Update My Profile</h3>

                    <% if (request.getAttribute("success") !=null) { %>
                        <div class="alert alert-success">
                            <%= request.getAttribute("success") %>
                        </div>
                        <% } %>
                            <% if (request.getAttribute("error") !=null) { %>
                                <div class="alert alert-danger">
                                    <%= request.getAttribute("error") %>
                                </div>
                                <% } %>

                                    <% User customer=(User) request.getAttribute("customer"); %>

                                        <form action="/customer/update" method="post">
                                            <div class="mb-3">
                                                <label class="form-label">Full Name</label>
                                                <input type="text" name="name" class="form-control"
                                                    value="<%= customer != null ? customer.getName() : "" %>" required>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">Email Address</label>
                                                <input type="email" name="email" class="form-control"
                                                    value="<%= customer != null ? customer.getEmail() : "" %>" required>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">Phone Number</label>
                                                <input type="text" name="phone" class="form-control"
                                                    value="<%= customer != null ? customer.getPhone() : "" %>">
                                            </div>
                                            <button type="submit" class="btn btn-dark w-100">Save Changes</button>
                                        </form>

                                        <hr>

                                        <!-- Delete Profile -->
                                        <form action="/customer/delete" method="post"
                                            onsubmit="return confirm('Are you sure you want to delete your account? This cannot be undone.')">
                                            <button type="submit" class="btn btn-outline-danger w-100">
                                                Delete My Account
                                            </button>
                                        </form>

                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>
