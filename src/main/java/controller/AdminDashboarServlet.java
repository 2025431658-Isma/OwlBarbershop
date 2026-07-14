package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminDashboardServlet")
public class AdminDashboarServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    // Menggunakan credential local environment database anda yang sah
    private final String DB_URL = "jdbc:oracle:thin:@localhost:1521/FREEPDB1"; 
    private final String DB_USER = "CSC584";
    private final String DB_PASSWORD = "CSC584";

    private Connection getConnection() throws Exception {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String userRole = null;
        
        if (session != null) {
            userRole = (String) session.getAttribute("userRole");
            if (userRole == null) {
                userRole = (String) session.getAttribute("role");
            }
        }

        if (session == null || !"ADMIN".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        List<Map<String, String>> recentBookings = new ArrayList<>();
        int totalCustomers = 0;
        int totalBookings = 0;
        double totalRevenue = 0.0;
        int activeBarbers = 0;

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = getConnection();

            // 1. Ambil jumlah pelanggan
            String customerSql = "SELECT COUNT(*) FROM CUSTOMER";
            try (Statement stmt = conn.createStatement(); ResultSet rsCount = stmt.executeQuery(customerSql)) {
                if (rsCount.next()) {
                    totalCustomers = rsCount.getInt(1);
                }
            }

            // 2. Ambil jumlah tempahan
            String bookingSql = "SELECT COUNT(*) FROM BOOKING";
            try (Statement stmt = conn.createStatement(); ResultSet rsCount = stmt.executeQuery(bookingSql)) {
                if (rsCount.next()) {
                    totalBookings = rsCount.getInt(1);
                }
            }

            // 3. Ambil jumlah pendapatan dari table Payment
            String revenueSql = "SELECT SUM(PAYMENT_AMOUNT) FROM PAYMENT";
            try (Statement stmt = conn.createStatement(); ResultSet rsCount = stmt.executeQuery(revenueSql)) {
                if (rsCount.next()) {
                    totalRevenue = rsCount.getDouble(1);
                }
            }

            // 4. Ambil jumlah pekerja (Barber)
            String staffSql = "SELECT COUNT(*) FROM STAFF";
            try (Statement stmt = conn.createStatement(); ResultSet rsCount = stmt.executeQuery(staffSql)) {
                if (rsCount.next()) {
                    activeBarbers = rsCount.getInt(1);
                }
            }

            // 5. Ambil 5 data tempahan terbaru (Menepati format Oracle uppercase)
            String recentSql = "SELECT b.BOOKING_ID, c.CUST_NAME, TO_CHAR(b.BOOKING_DATE, 'YYYY-MM-DD') AS BDATE, "
                             + "       b.TOTAL_PRICE, b.BOOKING_STATUS "
                             + "FROM BOOKING b "
                             + "LEFT JOIN CUSTOMER c ON b.CUST_ID = c.CUST_ID "
                             + "ORDER BY b.BOOKING_DATE DESC, b.BOOKING_ID DESC";
            
            ps = conn.prepareStatement(recentSql);
            rs = ps.executeQuery();

            int counter = 0;
            while (rs.next() && counter < 5) {
                Map<String, String> booking = new HashMap<>();
                booking.put("id", "#ORD-" + rs.getString("BOOKING_ID"));
                booking.put("customer", rs.getString("CUST_NAME") != null ? rs.getString("CUST_NAME") : "Guest Customer");
                booking.put("date", rs.getString("BDATE") != null ? rs.getString("BDATE") : "N/A");
                
                double amount = rs.getDouble("TOTAL_PRICE");
                booking.put("amount", amount > 0 ? "RM " + String.format("%.2f", amount) : "RM 0.00");
                
                String status = rs.getString("BOOKING_STATUS");
                booking.put("status", status != null ? status.toUpperCase() : "PENDING");
                
                recentBookings.add(booking);
                counter++;
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        request.setAttribute("recentBookings", recentBookings);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("barberCount", activeBarbers); 

        request.getRequestDispatcher("admin-dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}