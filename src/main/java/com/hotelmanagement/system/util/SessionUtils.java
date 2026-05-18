package com.hotelmanagement.system.util;

import com.hotelmanagement.system.model.User;
import jakarta.servlet.http.HttpSession;

public class SessionUtils {

    // Returns the logged in user or null if nobody is logged in
    public static User getLoggedInUser(HttpSession session) {
        Object obj = session.getAttribute("loggedUser");
        if (obj == null) return null;
        return (User) obj;
    }

    // Checks if anyone is logged in
    public static boolean isLoggedIn(HttpSession session) {
        return getLoggedInUser(session) != null;
    }

    // Checks if logged in user has a specific role
    public static boolean hasRole(HttpSession session, String role) {
        User user = getLoggedInUser(session);
        if (user == null) return false;
        return user.getRole().equals(role);
    }

    public static void logout(HttpSession session) {
        session.invalidate();
    }
}
