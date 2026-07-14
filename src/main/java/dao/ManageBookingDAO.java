package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.owlbarber.util.DBConnection;
import model.ManageBookingModel;

public class ManageBookingDAO {

    public boolean isModificationAllowed(int bookingId) throws SQLException, ClassNotFoundException {
        String sql = "SELECT COUNT(*) AS CAN_MODIFY FROM BOOKING "
                   + "WHERE BOOKING_ID = ? AND (TO_DATE(TO_CHAR(BOOKING_DATE, 'YYYY-MM-DD') || ' ' || BOOKING_TIME, 'YYYY-MM-DD HH24:MI') - SYSDATE) * 24 >= 24";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookingId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("CAN_MODIFY") > 0;
                }
            }
        }
        return false;
    }

    public boolean executeCancelOrDelete(int bookingId) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE BOOKING SET BOOKING_STATUS = 'Cancelled' WHERE BOOKING_ID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookingId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean executePayCard(int bookingId) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE BOOKING SET BOOKING_STATUS = 'Confirmed' WHERE BOOKING_ID = ? AND BOOKING_STATUS = 'Pending'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookingId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean executePayCash(int bookingId) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE BOOKING SET BOOKING_STATUS = 'Pending' WHERE BOOKING_ID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookingId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean hasScheduleClash(ManageBookingModel model) throws SQLException, ClassNotFoundException {
        String sql = "SELECT COUNT(*) AS CLASH_COUNT FROM BOOKING "
                   + "WHERE STAFF_ID = ? AND BOOKING_DATE = TO_DATE(?, 'YYYY-MM-DD') "
                   + "AND BOOKING_TIME = ? AND BOOKING_ID <> ? AND UPPER(BOOKING_STATUS) <> 'CANCELLED'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, model.getBarberId());
            stmt.setString(2, model.getBookingDate());
            stmt.setString(3, model.getBookingTime());
            stmt.setInt(4, model.getBookingId());
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("CLASH_COUNT") > 0;
                }
            }
        }
        return false;
    }

    public boolean executeUpdateBooking(ManageBookingModel model) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE BOOKING SET BOOKING_DATE = TO_DATE(?, 'YYYY-MM-DD'), BOOKING_TIME = ? WHERE BOOKING_ID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, model.getBookingDate());
            stmt.setString(2, model.getBookingTime());
            stmt.setInt(3, model.getBookingId());
            return stmt.executeUpdate() > 0;
        }
    }
}