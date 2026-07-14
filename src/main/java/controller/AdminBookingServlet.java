package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.Booking; // Ensure this matches your project's Model package structure

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminBookingServlet")
public class AdminBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Verified database configuration properties matching your local schema infrastructure
    private final String DB_URL = "jdbc:oracle:thin:@localhost:1521/FREEPDB1"; 
    private final String DB_USER = "CSC584";
    private final String DB_PASSWORD = "CSC584";

    /**
     * Instantiates a clean database connection instance leveraging the Oracle Thin Driver layer.
     */
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
            // Fallback variable alignment check
            if (userRole == null) {
                userRole = (String) session.getAttribute("role");
            }
        }

        // Global Security Interceptor Guard Clause: Restricts access context exclusively to authorized ADMIN accounts
        if (session == null || !"ADMIN".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        List<Booking> bookingList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();

            // SQL Join query designed to grab customer details and assigned barber details in a single loop
            String sql = "SELECT b.BOOKING_ID, b.BOOKING_DATE, b.BOOKING_TIME, b.BOOKING_STATUS, b.TOTAL_PRICE, " +
                         "       c.CUST_NAME, st.STAFF_NAME, st.STAFF_SPECIALTY " +
                         "FROM BOOKING b " +
                         "LEFT JOIN CUSTOMER c ON b.CUST_ID = c.CUST_ID " +
                         "LEFT JOIN STAFF st ON b.STAFF_ID = st.STAFF_ID " +
                         "ORDER BY b.BOOKING_DATE DESC, b.BOOKING_ID DESC";

            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            // Loop through the relational database entries and translate them into Java Model objects
            while (rs.next()) {
                Booking booking = new Booking();
                
                booking.setBookingId(rs.getInt("BOOKING_ID"));
                booking.setBookingTime(rs.getString("BOOKING_TIME"));
                booking.setTotalPrice(rs.getDouble("TOTAL_PRICE"));
                
                String status = rs.getString("BOOKING_STATUS");
                booking.setBookingStatus(status != null ? status.toUpperCase() : "PENDING");
                
                // Safe date serialization layer to intercept potential NullPointerException anomalies
                if (rs.getDate("BOOKING_DATE") != null) {
                    booking.setBookingDate(rs.getDate("BOOKING_DATE").toString());
                } else {
                    booking.setBookingDate("N/A");
                }
                
                // Fallback default strings handling missing relational data records
                booking.setCustomerName(rs.getString("CUST_NAME") != null ? rs.getString("CUST_NAME") : "Guest Customer");
                booking.setStaffName(rs.getString("STAFF_NAME") != null ? rs.getString("STAFF_NAME") : "Unassigned");
                
                // Uses the Specialty string field mapping configuration to feed the Service Presentation data field
                String serviceName = rs.getString("STAFF_SPECIALTY");
                booking.setServiceType(serviceName != null ? serviceName : "General Service");

                bookingList.add(booking);
            }

            // Bind the populated data array list structure into the active HttpServletRequest collection context
            request.setAttribute("allBookings", bookingList);
            
            // Forward execution thread safely context back down to your presentation view dashboard template page
            request.getRequestDispatcher("booking-admin-dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            // Internal error recovery framework fallbacks safely back to empty tables layout
            System.err.println("Database execution fault triggered inside AdminBookingServlet layer trace:");
            e.printStackTrace();
            
            request.setAttribute("allBookings", new ArrayList<Booking>());
            request.getRequestDispatcher("booking-admin-dashboard.jsp").forward(request, response);
        } finally {
            // Resource cleanup block ensuring that active server connections close immediately after request lifecycle termination
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Routes processing contexts back to standard execution configurations smoothly
        doGet(request, response);
    }
}