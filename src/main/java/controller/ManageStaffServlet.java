package controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ManageStaffServlet")
public class ManageStaffServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final String DB_URL = "jdbc:oracle:thin:@localhost:1521/FREEPDB1"; 
    private final String DB_USER = "CSC584";
    private final String DB_PASSWORD = "CSC584";

    private Connection getConnection() throws Exception {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String userRole = (session != null) ? (String) session.getAttribute("userRole") : null;
        if (userRole == null && session != null) {
            userRole = (String) session.getAttribute("role");
        }

        if (session == null || !"ADMIN".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        String action = request.getParameter("action");
        String staffIdStr = request.getParameter("staffId");
        String staffName = request.getParameter("staffName");
        String staffUsername = request.getParameter("staffUsername");
        String staffPassword = request.getParameter("staffPassword");
        String staffEmail = request.getParameter("staffEmail");
        String staffPhoneNum = request.getParameter("staffPhoneNum");
        String staffSpecialty = request.getParameter("staffSpecialty");
        String staffExperienceStr = request.getParameter("staffExperience");
        String staffRateStr = request.getParameter("staffRate");
        String managerIdStr = request.getParameter("managerId");

        String feedbackMessage = "";

        try (Connection conn = getConnection()) {
            if ("ADD".equalsIgnoreCase(action)) {
                // Generate next primary key sequence safely
                int nextId = 1;
                String seqSql = "SELECT NVL(MAX(Staff_ID), 0) + 1 FROM Staff";
                try (PreparedStatement psSeq = conn.prepareStatement(seqSql);
                     ResultSet rsSeq = psSeq.executeQuery()) {
                    if (rsSeq.next()) {
                        nextId = rsSeq.getInt(1);
                    }
                }

                String insertSql = "INSERT INTO Staff (Staff_ID, Staff_Name, Staff_PhoneNum, Staff_Email, " +
                                   "Staff_Username, Staff_Password, Staff_Rate, Staff_Specialty, " +
                                   "Staff_Experience, Manager_ID) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                
                try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                    ps.setInt(1, nextId);
                    ps.setString(2, staffName);
                    ps.setString(3, staffPhoneNum);
                    ps.setString(4, staffEmail);
                    ps.setString(5, staffUsername);
                    ps.setString(6, staffPassword != null ? staffPassword : "password123"); // Fallback password
                    
                    // Safe parsing for Double/Rate
                    if (staffRateStr != null && !staffRateStr.trim().isEmpty()) {
                        ps.setDouble(7, Double.parseDouble(staffRateStr.trim()));
                    } else {
                        ps.setDouble(7, 0.0);
                    }
                    
                    ps.setString(8, staffSpecialty);
                    
                    // Safe parsing for Experience
                    if (staffExperienceStr != null && !staffExperienceStr.trim().isEmpty()) {
                        ps.setInt(9, Integer.parseInt(staffExperienceStr.trim()));
                    } else {
                        ps.setInt(9, 0);
                    }
                    
                    // Safe null handling for Manager ID relation
                    if (managerIdStr != null && !managerIdStr.trim().isEmpty()) {
                        ps.setInt(10, Integer.parseInt(managerIdStr.trim()));
                    } else {
                        ps.setNull(10, Types.INTEGER);
                    }
                    
                    ps.executeUpdate();
                    feedbackMessage = "Barber profile entry saved successfully!";
                }
            } 
            else if ("UPDATE".equalsIgnoreCase(action)) {
                boolean modifyPassword = (staffPassword != null && !staffPassword.trim().isEmpty());
                String updateSql = modifyPassword ? 
                    "UPDATE Staff SET Staff_Name=?, Staff_PhoneNum=?, Staff_Email=?, Staff_Username=?, " +
                    "Staff_Password=?, Staff_Rate=?, Staff_Specialty=?, Staff_Experience=?, Manager_ID=? WHERE Staff_ID=?" :
                    "UPDATE Staff SET Staff_Name=?, Staff_PhoneNum=?, Staff_Email=?, Staff_Username=?, " +
                    "Staff_Rate=?, Staff_Specialty=?, Staff_Experience=?, Manager_ID=? WHERE Staff_ID=?";

                try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                    int index = 1;
                    ps.setString(index++, staffName);
                    ps.setString(index++, staffPhoneNum);
                    ps.setString(index++, staffEmail);
                    ps.setString(index++, staffUsername);
                    
                    if (modifyPassword) {
                        ps.setString(index++, staffPassword);
                    }
                    
                    // Safe numeric formatting for Double/Rate
                    if (staffRateStr != null && !staffRateStr.trim().isEmpty()) {
                        ps.setDouble(index++, Double.parseDouble(staffRateStr.trim()));
                    } else {
                        ps.setDouble(index++, 0.0);
                    }
                    
                    ps.setString(index++, staffSpecialty);
                    
                    // Safe numeric formatting for Experience
                    if (staffExperienceStr != null && !staffExperienceStr.trim().isEmpty()) {
                        ps.setInt(index++, Integer.parseInt(staffExperienceStr.trim()));
                    } else {
                        ps.setInt(index++, 0);
                    }
                    
                    // Safe null handling for Manager ID relation
                    if (managerIdStr != null && !managerIdStr.trim().isEmpty()) {
                        ps.setInt(index++, Integer.parseInt(managerIdStr.trim()));
                    } else {
                        ps.setNull(index++, Types.INTEGER);
                    }
                    
                    ps.setInt(index, Integer.parseInt(staffIdStr.trim()));
                    
                    ps.executeUpdate();
                    feedbackMessage = "Barber profile settings updated successfully!";
                }
            } 
            else if ("DELETE".equalsIgnoreCase(action)) {
                String deleteSql = "DELETE FROM Staff WHERE Staff_ID = ?";
                try (PreparedStatement ps = conn.prepareStatement(deleteSql)) {
                    ps.setInt(1, Integer.parseInt(staffIdStr.trim()));
                    ps.executeUpdate();
                    feedbackMessage = "Staff record removed successfully.";
                }
            }
        } catch (Exception e) {
            System.err.println("Database saving exception details:");
            e.printStackTrace();
            feedbackMessage = "Transaction error: " + e.getMessage().replace("'", "");
        }

        response.sendRedirect("BarberAdminServlet?msg=" + URLEncoder.encode(feedbackMessage, "UTF-8"));
    }
}