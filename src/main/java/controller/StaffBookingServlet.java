package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.owlbarber.util.DBConnection;
import model.Booking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/StaffBookingServlet")
public class StaffBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Booking> bookingList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            // SQL Query matching your exact column description
            // Grabs TOTAL_PRICE and STATUS from Booking table, joining Customer and Staff tables
            String sql = "SELECT b.BOOKING_ID, b.BOOKING_DATE, b.BOOKING_TIME, b.BOOKING_STATUS, b.TOTAL_PRICE, " +
                         "       c.CUST_NAME, st.STAFF_NAME, st.STAFF_SPECIALTY " +
                         "FROM BOOKING b " +
                         "LEFT JOIN CUSTOMER c ON b.CUST_ID = c.CUST_ID " +
                         "LEFT JOIN STAFF st ON b.STAFF_ID = st.STAFF_ID " +
                         "ORDER BY b.BOOKING_DATE DESC, b.BOOKING_TIME DESC";

            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Booking booking = new Booking();
                
                // 1. Direct fields mapping (Strict Oracle Uppercase)
                booking.setBookingId(rs.getInt("BOOKING_ID"));
                booking.setBookingTime(rs.getString("BOOKING_TIME"));
                booking.setTotalPrice(rs.getDouble("TOTAL_PRICE"));
                
                // 2. Safe status string conversion
                String status = rs.getString("BOOKING_STATUS");
                booking.setBookingStatus(status != null ? status.toUpperCase() : "PENDING");
                
                // 3. Date parsing format management
                if (rs.getDate("BOOKING_DATE") != null) {
                    booking.setBookingDate(rs.getDate("BOOKING_DATE").toString());
                } else {
                    booking.setBookingDate("N/A");
                }
                
                // 4. Joined string relational definitions
                booking.setCustomerName(rs.getString("CUST_NAME") != null ? rs.getString("CUST_NAME") : "Unknown Customer");
                booking.setStaffName(rs.getString("STAFF_NAME") != null ? rs.getString("STAFF_NAME") : "Unassigned");
                
                // 5. Service Type Fallback handling:
                // Since Booking table doesn't have a service link, we fall back to the Staff's specialty name (e.g., "Haircut")
                String serviceName = rs.getString("STAFF_SPECIALTY");
                booking.setServiceType(serviceName != null ? serviceName : "General Service");

                bookingList.add(booking);
            }

            // Send array elements down to the request attribute container context
            request.setAttribute("allBookings", bookingList);
            
            // Forward back to dashboard page
            request.getRequestDispatcher("/booking-staff-dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            // Load clean list framework configuration to stop crashing page layout cycles
            request.setAttribute("allBookings", new ArrayList<Booking>());
            request.setAttribute("errorMessage", "Database error loading appointments: " + e.getMessage());
            request.getRequestDispatcher("/booking-staff-dashboard.jsp").forward(request, response);
        } finally {
            // Stream management components closure
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}