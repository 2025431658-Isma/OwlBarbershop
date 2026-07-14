package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import com.owlbarber.util.DBConnection;

public class ProcessPaymentDAO {

    public boolean updateBookingToPaid(int bookingId) throws SQLException, ClassNotFoundException {
        String sqlUpdate = "UPDATE BOOKING SET BOOKING_STATUS = 'Confirmed' WHERE BOOKING_ID = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); 

            try (PreparedStatement stmtUpdate = conn.prepareStatement(sqlUpdate)) {
                stmtUpdate.setInt(1, bookingId);
                int rowsUpdated = stmtUpdate.executeUpdate();
                
                if (rowsUpdated > 0) {
                    conn.commit();
                    return true;
                } else {
                    conn.rollback();
                    return false;
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException se) { se.printStackTrace(); }
            }
            throw e;
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }
}