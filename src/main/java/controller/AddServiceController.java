package controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AddServiceController")
public class AddServiceController extends HttpServlet {
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

        String serviceName = request.getParameter("serviceName");
        String serviceDesc = request.getParameter("serviceDesc");
        String servicePriceStr = request.getParameter("servicePrice");
        String serviceDurationStr = request.getParameter("serviceDuration");
        String staffIdStr = request.getParameter("staffId"); // New assigned staff input

        String feedbackMessage = "";

        try (Connection conn = getConnection()) {
            int nextId = 1;
            String seqSql = "SELECT NVL(MAX(Service_ID), 0) + 1 FROM Service";
            try (PreparedStatement psSeq = conn.prepareStatement(seqSql);
                 ResultSet rsSeq = psSeq.executeQuery()) {
                if (rsSeq.next()) {
                    nextId = rsSeq.getInt(1);
                }
            }

            String insertSql = "INSERT INTO Service (Service_ID, Service_Name, Service_Duration, Service_Description, Service_Price, Staff_ID) " +
                               "VALUES (?, ?, ?, ?, ?, ?)";
            
            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setInt(1, nextId);
                ps.setString(2, serviceName);
                
                int duration = (serviceDurationStr != null && !serviceDurationStr.trim().isEmpty()) ? Integer.parseInt(serviceDurationStr.trim()) : 0;
                ps.setInt(3, duration);
                
                ps.setString(4, serviceDesc);
                
                double price = (servicePriceStr != null && !servicePriceStr.trim().isEmpty()) ? Double.parseDouble(servicePriceStr.trim()) : 0.0;
                ps.setDouble(5, price);
                
                if (staffIdStr != null && !staffIdStr.trim().isEmpty()) {
                    ps.setInt(6, Integer.parseInt(staffIdStr.trim()));
                } else {
                    ps.setNull(6, java.sql.Types.INTEGER);
                }

                ps.executeUpdate();
                feedbackMessage = "New service successfully created and assigned!";
            }
        } catch (Exception e) {
            e.printStackTrace();
            feedbackMessage = "Error adding service: " + e.getMessage().replace("'", "");
        }

        response.sendRedirect("AdminServiceServlet?msg=" + URLEncoder.encode(feedbackMessage, "UTF-8"));
    }
}