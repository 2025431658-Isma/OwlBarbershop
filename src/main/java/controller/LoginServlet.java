package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.mindrot.jbcrypt.BCrypt;
import com.owlbarber.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            // ==========================================
            // 1. CUSTOMER LOGIN CHECK (Using BCrypt)
            // ==========================================
            String customerSql = "SELECT Cust_ID, Cust_Name, Cust_Email, Cust_PhoneNum, Cust_Password FROM Customer WHERE Cust_Username = ?";
            stmt = conn.prepareStatement(customerSql);
            stmt.setString(1, username);
            rs = stmt.executeQuery();

            if (rs.next()) {
                String hashedPassword = rs.getString("Cust_Password");
                if (BCrypt.checkpw(password, hashedPassword)) {
                    HttpSession session = request.getSession(true);
                    session.setAttribute("userId", rs.getInt("Cust_ID"));
                    session.setAttribute("username", username);
                    session.setAttribute("fullName", rs.getString("Cust_Name"));
                    session.setAttribute("email", rs.getString("Cust_Email"));
                    session.setAttribute("phone", rs.getString("Cust_PhoneNum"));
                    session.setAttribute("userRole", "CUSTOMER");

                    response.sendRedirect(request.getContextPath() + "/index.jsp");
                    return;
                }
            }

            if (rs != null) rs.close();
            if (stmt != null) stmt.close();

            // ==========================================
            // 2. STAFF / ADMIN LOGIN CHECK 
            // ==========================================
            String staffSql = "SELECT Staff_ID, Staff_Name, Manager_ID FROM Staff WHERE Staff_Username = ? AND Staff_Password = ?";
            
            stmt = conn.prepareStatement(staffSql);
            stmt.setString(1, username);
            stmt.setString(2, password);
            rs = stmt.executeQuery();

            if (rs.next()) {
                int staffId = rs.getInt("Staff_ID");
                String staffName = rs.getString("Staff_Name");
                int managerId = rs.getInt("Manager_ID");
                boolean isAdmin = rs.wasNull();

                HttpSession session = request.getSession(true);
                session.setAttribute("staffId", staffId);
                session.setAttribute("staffName", staffName);
                
                // FIXED: Adding userName session attribute so profile-staff-dashboard.jsp doesn't redirect to login!
                session.setAttribute("userName", staffName);

                if (isAdmin) {
                    session.setAttribute("userRole", "ADMIN");
                    session.setAttribute("role", "ADMIN");
                    response.sendRedirect(request.getContextPath() + "/AdminDashboardServlet");
                } else {
                    session.setAttribute("userRole", "STAFF");
                    session.setAttribute("role", "STAFF");
                    session.setAttribute("managerId", managerId);
                    
                    // FIXED: Redirect to the StaffDashboardServlet instead of the raw .jsp file so data loads
                    response.sendRedirect(request.getContextPath() + "/StaffDashboardServlet");
                }
                return;
            }

            // ==========================================
            // 3. LOGIN FAILED 
            // ==========================================
            request.setAttribute("errorMessage", "Invalid username or password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "System Error: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}