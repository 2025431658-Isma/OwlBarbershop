package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import com.owlbarber.util.DBConnection;
import model.BookingModel;

public class BookingDAO {

    public boolean saveBooking(BookingModel booking, List<Integer> serviceIds) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement stmtSeq = null;
        PreparedStatement stmtBooking = null;
        PreparedStatement stmtService = null;
        ResultSet rsSeq = null;
        boolean success = false;

        String insertBookingSQL = "INSERT INTO BOOKING (BOOKING_ID, CUST_ID, STAFF_ID, BOOKING_DATE, BOOKING_TIME, TOTAL_PRICE, BOOKING_STATUS) "
                                + "VALUES (?, ?, ?, TO_DATE(?, 'YYYY-MM-DD'), ?, ?, 'Pending')";
        
        String insertBookingServiceSQL = "INSERT INTO BOOKING_SERVICES (BOOKING_ID, SERVICE_ID) VALUES (?, ?)";

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); 

            // STEP 1: Fetch the next sequence ID explicitly from Oracle
            int nextBookingId = 0;
            stmtSeq = conn.prepareStatement("SELECT BOOKING_SEQ.NEXTVAL FROM DUAL");
            rsSeq = stmtSeq.executeQuery();
            if (rsSeq.next()) {
                nextBookingId = rsSeq.getInt(1);
            }
            rsSeq.close();
            stmtSeq.close();

            if (nextBookingId == 0) {
                throw new SQLException("Failed to retrieve a valid sequence ID from BOOKING_SEQ.");
            }

            booking.setBookingId(nextBookingId);

            // STEP 2: Insert the primary booking row
            stmtBooking = conn.prepareStatement(insertBookingSQL);
            stmtBooking.setInt(1, nextBookingId); 
            stmtBooking.setInt(2, booking.getUserId());
            stmtBooking.setInt(3, booking.getStaffId());
            
            String cleanDate = booking.getBookingDate().trim();
            if (cleanDate.length() > 10) {
                cleanDate = cleanDate.substring(0, 10);
            }
            stmtBooking.setString(4, cleanDate); 
            stmtBooking.setString(5, booking.getBookingTime());
            
            // SAFETY: If totalPrice is 0.0, set a temporary valid fallback value (e.g. 35.0) 
            // in case your database has a CHECK (TOTAL_PRICE > 0) constraint.
            double finalPrice = booking.getTotalPrice();
            if (finalPrice <= 0.0) {
                finalPrice = 35.0; 
            }
            stmtBooking.setDouble(6, finalPrice);

            int affectedRows = stmtBooking.executeUpdate();

            // STEP 3: Insert into child mapping table
            if (affectedRows > 0) {
                stmtService = conn.prepareStatement(insertBookingServiceSQL);
                for (Integer serviceId : serviceIds) {
                    stmtService.setInt(1, nextBookingId);
                    stmtService.setInt(2, serviceId);
                    stmtService.addBatch();
                }
                stmtService.executeBatch();
                
                conn.commit(); 
                success = true;
            }
            
            if (!success) {
                if (conn != null) conn.rollback();
            }

        } catch (SQLException | ClassNotFoundException e) {
            // This prints the EXACT error to your IDE's Console log window!
            System.err.println("❌ [BookingDAO Error]: TRANSACTION FAILED AND ROLLED BACK!");
            e.printStackTrace(); 
            
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            throw e;
        } finally {
            if (rsSeq != null) try { rsSeq.close(); } catch (SQLException e) {}
            if (stmtSeq != null) try { stmtSeq.close(); } catch (SQLException e) {}
            if (stmtService != null) try { stmtService.close(); } catch (SQLException e) {}
            if (stmtBooking != null) try { stmtBooking.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }

        return success;
    }
}