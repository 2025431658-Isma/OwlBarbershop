package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import model.Staff; // Explicitly imported to prevent compilation 'cannot be resolved to a type' errors

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminProfileServlet")
public class AdminProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Standard database infrastructure properties pointing to local database instances
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
        String sessionUsername = null;
        
        if (session != null) {
            userRole = (String) session.getAttribute("userRole");
            if (userRole == null) {
                userRole = (String) session.getAttribute("role");
            }
            sessionUsername = (String) session.getAttribute("userName");
        }

        // Global Security Interceptor Guard Clause: Restricts access context exclusively to authorized ADMIN accounts
        if (session == null || !"ADMIN".equalsIgnoreCase(userRole) || sessionUsername == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        Staff adminProfile = null;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();

            // SQL query to pull the matching admin data records out of the STAFF relational table ledger
            String sql = "SELECT STAFF_ID, STAFF_NAME, STAFF_USERNAME, STAFF_PASSWORD, STAFF_EMAIL, " +
                         "STAFF_PHONENUM, MANAGER_ID, STAFF_SPECIALTY, STAFF_EXPERIENCE, STAFF_RATE " +
                         "FROM STAFF WHERE LOWER(STAFF_USERNAME) = LOWER(?)";
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, sessionUsername);
            rs = stmt.executeQuery();

            if (rs.next()) {
                adminProfile = new Staff();
                adminProfile.setStaffId(rs.getInt("STAFF_ID"));
                adminProfile.setStaffName(rs.getString("STAFF_NAME"));
                adminProfile.setStaffUsername(rs.getString("STAFF_USERNAME"));
                adminProfile.setStaffPassword(rs.getString("STAFF_PASSWORD"));
                adminProfile.setStaffEmail(rs.getString("STAFF_EMAIL"));
                adminProfile.setStaffPhoneNum(rs.getString("STAFF_PHONENUM"));
                adminProfile.setStaffSpecialty(rs.getString("STAFF_SPECIALTY"));
                adminProfile.setStaffExperience(rs.getInt("STAFF_EXPERIENCE"));
                adminProfile.setStaffRate(rs.getDouble("STAFF_RATE"));
                
                // Safely handling nullable database references for Manager ID keys
                int mgrId = rs.getInt("MANAGER_ID");
                if (!rs.wasNull()) {
                    adminProfile.setManagerId(mgrId);
                } else {
                    adminProfile.setManagerId(null);
                }
            }

        } catch (Exception e) {
            System.err.println("Database execution fault triggered inside AdminProfileServlet layer trace:");
            e.printStackTrace();
        } finally {
            // Resource cleanup block ensuring that active database resources close cleanly after operation lifecycle
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        // Bind data objects directly onto the request parameter collection space
        request.setAttribute("adminProfile", adminProfile);

        // Forward execution thread safely context back down to your presentation view dashboard template page
        request.getRequestDispatcher("admin-profile-dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}