package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.owlbarber.util.DBConnection;
import model.GetBookingDataModel.ServiceItem;
import model.GetBookingDataModel.StaffItem;

public class GetBookingDataDAO {

    public List<ServiceItem> getAllServices() throws SQLException, ClassNotFoundException {
        List<ServiceItem> list = new ArrayList<>();
        String sql = "SELECT Service_ID, Service_Name, Service_Description, Service_Price, Service_Duration FROM Service ORDER BY Service_ID ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                ServiceItem item = new ServiceItem();
                item.setId(rs.getInt("Service_ID"));
                item.setName(rs.getString("Service_Name"));
                item.setDescription(rs.getString("Service_Description"));
                item.setPrice(rs.getDouble("Service_Price"));
                // Keep raw database string; helper handles formatting extraction
                item.setDescription(rs.getString("Service_Description") + "||" + rs.getString("Service_Duration"));
                list.add(item);
            }
        }
        return list;
    }

    public List<StaffItem> getAllStaff() throws SQLException, ClassNotFoundException {
        List<StaffItem> list = new ArrayList<>();
        String sql = "SELECT Staff_ID, Staff_Name, Staff_Specialty FROM Staff ORDER BY Staff_ID ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                StaffItem item = new StaffItem();
                item.setId(rs.getInt("Staff_ID"));
                item.setName(rs.getString("Staff_Name"));
                item.setRole(rs.getString("Staff_Specialty"));
                list.add(item);
            }
        }
        return list;
    }

    public List<String[]> getActiveBookings(int barberId, String dateStr) throws SQLException, ClassNotFoundException {
        List<String[]> activeBookings = new ArrayList<>();
        String sql = "SELECT b.BOOKING_TIME, SUM(REGEXP_REPLACE(s.SERVICE_DURATION, '[^0-9]', '')) AS AGG_DURATION "
                   + "FROM BOOKING b "
                   + "JOIN BOOKING_SERVICES bs ON b.BOOKING_ID = bs.BOOKING_ID "
                   + "JOIN SERVICE s ON bs.SERVICE_ID = s.SERVICE_ID "
                   + "WHERE b.STAFF_ID = ? "
                   + "AND TO_CHAR(b.BOOKING_DATE, 'YYYY-MM-DD') = ? "
                   + "AND UPPER(b.BOOKING_STATUS) != 'CANCELLED' "
                   + "GROUP BY b.BOOKING_ID, b.BOOKING_TIME";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, barberId);
            stmt.setString(2, dateStr);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    activeBookings.add(new String[]{ rs.getString("BOOKING_TIME"), rs.getString("AGG_DURATION") });
                }
            }
        }
        return activeBookings;
    }
}