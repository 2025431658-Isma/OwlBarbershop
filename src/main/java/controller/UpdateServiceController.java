package controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/UpdateServiceController")
public class UpdateServiceController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final String DB_URL = "jdbc:oracle:thin:@localhost:1521/FREEPDB1"; 
    private final String DB_USER = "CSC584";
    private final String DB_PASSWORD = "CSC584";

    private Connection getConnection() throws Exception {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
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

        String serviceIdStr = request.getParameter("serviceId");
        String serviceName = request.getParameter("serviceName");
        String serviceDesc = request.getParameter("serviceDesc");
        String servicePriceStr = request.getParameter("servicePrice");
        String serviceDurationStr = request.getParameter("serviceDuration");
        String staffIdStr = request.getParameter("staffId"); // Updated assigned staff input

        String feedbackMessage = "";

        try (Connection conn = getConnection()) {
            String updateSql = "UPDATE Service SET Service_Name = ?, Service_Duration = ?, Service_Description = ?, " +
                               "Service_Price = ?, Staff_ID = ? WHERE Service_ID = ?";
            
            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setString(1, serviceName);
                
                int duration = (serviceDurationStr != null && !serviceDurationStr.trim().isEmpty()) ? Integer.parseInt(serviceDurationStr.trim()) : 0;
                ps.setInt(2, duration);
                
                ps.setString(3, serviceDesc);
                
                double price = (servicePriceStr != null && !servicePriceStr.trim().isEmpty()) ? Double.parseDouble(servicePriceStr.trim()) : 0.0;
                ps.setDouble(4, price);
                
                if (staffIdStr != null && !staffIdStr.trim().isEmpty()) {
                    ps.setInt(5, Integer.parseInt(staffIdStr.trim()));
                } else {
                    ps.setNull(5, java.sql.Types.INTEGER);
                }
                
                ps.setInt(6, Integer.parseInt(serviceIdStr.trim()));

                ps.executeUpdate();
                feedbackMessage = "Service record updated successfully.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            feedbackMessage = "Error updating service: " + e.getMessage().replace("'", "");
        }

        response.sendRedirect("AdminServiceServlet?msg=" + URLEncoder.encode(feedbackMessage, "UTF-8"));
    }
}