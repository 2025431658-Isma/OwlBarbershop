package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.owlbarber.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/StaffDashboardServlet")
public class StaffDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	
        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Object staffObj = session.getAttribute("staffId");

        if (staffObj == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int staffId;

        if (staffObj instanceof Number) {
            staffId = ((Number) staffObj).intValue();
        } else {
            staffId = Integer.parseInt(staffObj.toString());
        }

        int totalBooking = 0;
        int pendingBooking = 0;
        int completedBooking = 0;

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(
                        "SELECT " +
                        "COUNT(*) AS total, " +
                        "SUM(CASE WHEN BOOKING_STATUS='Pending' THEN 1 ELSE 0 END) AS pending, " +
                        "SUM(CASE WHEN BOOKING_STATUS='Completed' THEN 1 ELSE 0 END) AS completed " +
                        "FROM BOOKING WHERE STAFF_ID=?")
        ) {

            ps.setInt(1, staffId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    totalBooking = rs.getInt("total");
                    pendingBooking = rs.getInt("pending");
                    completedBooking = rs.getInt("completed");
                }

            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("totalBooking", totalBooking);
        request.setAttribute("pendingBooking", pendingBooking);
        request.setAttribute("completedBooking", completedBooking);

        request.getRequestDispatcher("/staff-dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);

    }

}