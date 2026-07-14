package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.Staff;
import com.owlbarber.util.DBConnection;

/**
 * Data Access Object (DAO) providing CRUD database operations for the Staff table.
 */
public class StaffDAO {

    /**
     * Retrieves all staff entries from the Database to supply the Management tables.
     */
    public List<Staff> getAllStaff() {
        List<Staff> staffList = new ArrayList<>();
        String sql = "SELECT Staff_ID, Staff_Name, Staff_Username, Staff_Password, Staff_Email, Staff_PhoneNum, Manager_ID " +
                     "FROM Staff ORDER BY Staff_Name ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Staff staff = new Staff();
                staff.setStaffId(rs.getInt("Staff_ID"));
                staff.setStaffName(rs.getString("Staff_Name"));
                staff.setStaffUsername(rs.getString("Staff_Username"));
                staff.setStaffPassword(rs.getString("Staff_Password"));
                staff.setStaffEmail(rs.getString("Staff_Email"));
                staff.setStaffPhoneNum(rs.getString("Staff_PhoneNum"));
                
                // Safely handle potential null values inside the database for Manager IDs
                int managerId = rs.getInt("Manager_ID");
                if (rs.wasNull()) {
                    staff.setManagerId(null);
                } else {
                    staff.setManagerId(managerId);
                }

                staffList.add(staff);
            }
        } catch (Exception e) {
            System.err.println("Error inside StaffDAO.getAllStaff(): " + e.getMessage());
            e.printStackTrace();
        }
        return staffList;
    }

    /**
     * Deletes a specific staff member from the database given their ID.
     */
    public boolean deleteStaff(int staffId) {
        String sql = "DELETE FROM Staff WHERE Staff_ID = ?";
        boolean isDeleted = false;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, staffId);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                isDeleted = true;
            }
        } catch (Exception e) {
            System.err.println("Error inside StaffDAO.deleteStaff(): " + e.getMessage());
            e.printStackTrace();
        }
        return isDeleted;
    }
}