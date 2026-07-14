package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ReportAdminServlet")
public class ReportAdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Local database configuration properties
    private final String DB_URL = "jdbc:oracle:thin:@localhost:1521/FREEPDB1"; 
    private final String DB_USER = "CSC584";
    private final String DB_PASSWORD = "CSC584";

    private Connection getConnection() throws Exception {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String userRole = null;
        
        if (session != null) {
            userRole = (String) session.getAttribute("userRole");
            if (userRole == null) {
                userRole = (String) session.getAttribute("role");
            }
        }

        // Global Security Interceptor: Restricts context context exclusively to authorized ADMIN accounts
        if (session == null || !"ADMIN".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        double totalRevenue = 0.0;
        int totalBookings = 0;

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();

            // Aggregate query evaluating total booking count metrics alongside real-time confirmed revenue
            String sql = "SELECT " +
                         "(SELECT NVL(SUM(TOTAL_PRICE), 0) FROM BOOKING WHERE UPPER(BOOKING_STATUS) IN ('CONFIRMED', 'COMPLETED')) as total_revenue, " +
                         "(SELECT COUNT(*) FROM BOOKING) as total_bookings " +
                         "FROM DUAL";
                         
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            if (rs.next()) {
                totalRevenue = rs.getDouble("total_revenue");
                totalBookings = rs.getInt("total_bookings");
            }

        } catch (Exception e) {
            System.err.println("Database execution fault triggered inside ReportAdminServlet layer trace:");
            e.printStackTrace();
        } finally {
            // Resource cleanup safely securing system connection instances
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        // Bind raw numeric values directly onto the request parameters scope
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalBookings", totalBookings);

        // Forward execution context downstream towards the dashboard view layout page
        request.getRequestDispatcher("report-admin-dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}