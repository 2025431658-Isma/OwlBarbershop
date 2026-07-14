package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.owlbarber.util.DBConnection; // Matching your exact utility package
import model.Staff; // Importing your updated model package

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/StaffSettingServlet")
public class StaffSettingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * FETCH PROFILE DETAILS
     * Triggered when the user clicks the "Profile" link in the sidebar menu.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Session check to guarantee user is authenticated
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Object staffObj = session.getAttribute("staffId");
        if (staffObj == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Safely parse staffId from active session
        int staffId;
        if (staffObj instanceof Number) {
            staffId = ((Number) staffObj).intValue();
        } else {
            staffId = Integer.parseInt(staffObj.toString());
        }

        Staff currentStaff = null;

        // 2. Query database for the latest records
        String sql = "SELECT STAFF_ID, STAFF_NAME, STAFF_USERNAME, STAFF_PASSWORD, " +
                     "STAFF_EMAIL, STAFF_PHONENUM, MANAGER_ID, STAFF_SPECIALTY, STAFF_EXPERIENCE " +
                     "FROM STAFF WHERE STAFF_ID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, staffId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    currentStaff = new Staff();
                    currentStaff.setStaffId(rs.getInt("STAFF_ID"));
                    currentStaff.setStaffName(rs.getString("STAFF_NAME"));
                    currentStaff.setStaffUsername(rs.getString("STAFF_USERNAME"));
                    currentStaff.setStaffPassword(rs.getString("STAFF_PASSWORD"));
                    currentStaff.setStaffEmail(rs.getString("STAFF_EMAIL"));
                    currentStaff.setStaffPhoneNum(rs.getString("STAFF_PHONENUM"));
                    
                    int mgrId = rs.getInt("MANAGER_ID");
                    if (rs.wasNull()) {
                        currentStaff.setManagerId(null);
                    } else {
                        currentStaff.setManagerId(mgrId);
                    }
                    
                    currentStaff.setStaffSpecialty(rs.getString("STAFF_SPECIALTY"));
                    currentStaff.setStaffExperience(rs.getInt("STAFF_EXPERIENCE"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // 3. Attach object to request scope and route to profile JSP view
        if (currentStaff != null) {
            request.setAttribute("currentStaff", currentStaff);
            request.getRequestDispatcher("/profile-staff-dashboard.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=profile_not_found");
        }
    }

    /**
     * UPDATE PROFILE DETAILS
     * Triggered when the staff clicks "Save Changes" on the profile form submission.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Extract updated input elements from form request parameters
        String staffIdStr = request.getParameter("staffId");
        String name = request.getParameter("staffName");
        String username = request.getParameter("staffUsername");
        String email = request.getParameter("staffEmail");
        String phone = request.getParameter("staffPhoneNum");
        String specialty = request.getParameter("staffSpecialty");
        String experienceStr = request.getParameter("staffExperience");
        String password = request.getParameter("staffPassword");

        int staffId = Integer.parseInt(staffIdStr);
        int experience = 0;
        if (experienceStr != null && !experienceStr.trim().isEmpty()) {
            experience = Integer.parseInt(experienceStr);
        }

        // 2. Run update query on row corresponding to target staff ID
        String sql = "UPDATE STAFF SET STAFF_NAME = ?, STAFF_USERNAME = ?, STAFF_EMAIL = ?, " +
                     "STAFF_PHONENUM = ?, STAFF_SPECIALTY = ?, STAFF_EXPERIENCE = ?, STAFF_PASSWORD = ? " +
                     "WHERE STAFF_ID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, username);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, specialty);
            ps.setInt(6, experience);
            ps.setString(7, password);
            ps.setInt(8, staffId);

            int rowsUpdated = ps.executeUpdate();

            if (rowsUpdated > 0) {
                // Update session variables instantly so that the header menu matches the new name
                HttpSession session = request.getSession(false);
                if (session != null) {
                    session.setAttribute("userName", name);
                }
                
                // Redirect back to profile view with status token to trigger the success popup toast notice
                response.sendRedirect("StaffSettingServlet?status=success");
            } else {
                response.sendRedirect("StaffSettingServlet?status=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("StaffSettingServlet?status=error");
        }
    }
}