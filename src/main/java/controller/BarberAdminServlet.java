package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.Staff; // Explicit import to prevent model compilation failures

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/BarberAdminServlet")
public class BarberAdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Local Oracle Database Configuration
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
        
        if (session != null) {
            userRole = (String) session.getAttribute("userRole");
            if (userRole == null) {
                userRole = (String) session.getAttribute("role");
            }
        }

        // Global Security Interceptor Guard Clause: Restricts access context exclusively to authorized ADMIN accounts
        if (session == null || !"ADMIN".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        List<Staff> barberList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();

            // SQL Query to extract all crew records from the STAFF relational table ledger
            String sql = "SELECT STAFF_ID, STAFF_NAME, STAFF_USERNAME, STAFF_EMAIL, STAFF_PHONENUM, " +
                         "STAFF_SPECIALTY, STAFF_EXPERIENCE, STAFF_RATE, MANAGER_ID FROM STAFF " +
                         "ORDER BY STAFF_ID ASC";

            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Staff barber = new Staff();
                barber.setStaffId(rs.getInt("STAFF_ID"));
                barber.setStaffName(rs.getString("STAFF_NAME"));
                barber.setStaffUsername(rs.getString("STAFF_USERNAME"));
                barber.setStaffEmail(rs.getString("STAFF_EMAIL"));
                barber.setStaffPhoneNum(rs.getString("STAFF_PHONENUM"));
                barber.setStaffSpecialty(rs.getString("STAFF_SPECIALTY"));
                barber.setStaffExperience(rs.getInt("STAFF_EXPERIENCE"));
                barber.setStaffRate(rs.getDouble("STAFF_RATE"));
                
                int mgrId = rs.getInt("MANAGER_ID");
                if (!rs.wasNull()) {
                    barber.setManagerId(mgrId);
                } else {
                    barber.setManagerId(null);
                }

                barberList.add(barber);
            }

        } catch (Exception e) {
            System.err.println("Database execution fault triggered inside BarberAdminServlet layer trace:");
            e.printStackTrace();
        } finally {
            // Resource cleanup block ensuring that database connection streams close cleanly after context use
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        // Bind data objects directly onto the request parameter collection space for consumption by the view page
        request.setAttribute("barberList", barberList);

        // Forward execution thread safely down to presentation dashboard layer view page
        request.getRequestDispatcher("barber-admin-dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}