package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.owlbarber.util.DBConnection;
import model.Staff; // Importing your updated model package

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/StaffListServlet")
public class StaffListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Session check to make sure only logged-in users access this
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userName") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<Staff> allStaff = new ArrayList<>();

        // 2. Fetch all staff records from the database
        String sql = "SELECT STAFF_ID, STAFF_NAME, STAFF_USERNAME, STAFF_PASSWORD, " +
                     "STAFF_EMAIL, STAFF_PHONENUM, MANAGER_ID, STAFF_SPECIALTY, STAFF_EXPERIENCE " +
                     "FROM STAFF ORDER BY STAFF_NAME ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Staff s = new Staff();
                s.setStaffId(rs.getInt("STAFF_ID"));
                s.setStaffName(rs.getString("STAFF_NAME"));
                s.setStaffUsername(rs.getString("STAFF_USERNAME"));
                s.setStaffPassword(rs.getString("STAFF_PASSWORD"));
                s.setStaffEmail(rs.getString("STAFF_EMAIL"));
                s.setStaffPhoneNum(rs.getString("STAFF_PHONENUM"));
                
                // Handle potentially null Manager ID safely
                int managerId = rs.getInt("MANAGER_ID");
                if (rs.wasNull()) {
                    s.setManagerId(null);
                } else {
                    s.setManagerId(managerId);
                }
                
                s.setStaffSpecialty(rs.getString("STAFF_SPECIALTY"));
                s.setStaffExperience(rs.getInt("STAFF_EXPERIENCE"));
                
                allStaff.add(s);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // 3. Set the list as a request attribute and forward to the JSP dashboard
        request.setAttribute("allStaff", allStaff);
        request.getRequestDispatcher("/staff-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}