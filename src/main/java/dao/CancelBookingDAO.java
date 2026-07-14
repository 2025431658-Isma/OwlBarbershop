package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import com.owlbarber.util.DBConnection;

public class CancelBookingDAO {

    /**
     * Updates the status of a booking record to 'Cancelled'.
     * @throws ClassNotFoundException 
     */
    public boolean executeCancellation(int bookingId) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement stmt = null;
        String sql = "UPDATE BOOKING SET BOOKING_STATUS = 'Cancelled' WHERE BOOKING_ID = ?";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, bookingId);
            
            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;

        } finally {
            if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    }
}