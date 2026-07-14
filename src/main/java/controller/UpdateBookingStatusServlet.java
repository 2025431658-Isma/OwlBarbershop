package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.owlbarber.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/UpdateBookingStatusServlet")
public class UpdateBookingStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Unifies execution logic for both HTTP GET actions and POST transmissions.
     */
    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Session Protection Interceptor Layer
        HttpSession session = request.getSession(false);
        String userRole = null;
        
        if (session != null) {
            userRole = (String) session.getAttribute("userRole");
            if (userRole == null) {
                userRole = (String) session.getAttribute("role");
            }
        }

        // Global Security Guard Clause: Restricts access context to ADMIN or STAFF accounts only
        if (session == null || (!"ADMIN".equalsIgnoreCase(userRole) && !"STAFF".equalsIgnoreCase(userRole))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        // 2. Map incoming parameters flexibly (Supports both 'bookingId' links from admin and form 'id' from staff)
        String bookingIdStr = request.getParameter("bookingId");
        if (bookingIdStr == null || bookingIdStr.trim().isEmpty()) {
            bookingIdStr = request.getParameter("id");
        }
        
        String newStatus = request.getParameter("status");

        // Dynamic system target redirection string based on active session authorization
        String targetRedirect = "STAFF".equalsIgnoreCase(userRole) ? "StaffBookingServlet" : "AdminBookingServlet";

        if (bookingIdStr == null || newStatus == null || newStatus.trim().isEmpty()) {
            response.sendRedirect(targetRedirect + "?status=error");
            return;
        }

        // 3. Execute transactional update operations using your utility DB Connection pool
        String sql = "UPDATE BOOKING SET BOOKING_STATUS = ? WHERE BOOKING_ID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus.toUpperCase().trim());
            ps.setInt(2, Integer.parseInt(bookingIdStr.trim()));

            int rowsUpdated = ps.executeUpdate();
            if (rowsUpdated > 0) {
                response.sendRedirect(targetRedirect + "?status=success");
            } else {
                response.sendRedirect(targetRedirect + "?status=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(targetRedirect + "?status=error");
        }
    }
}