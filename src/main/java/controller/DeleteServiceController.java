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

@WebServlet("/DeleteServiceController")
public class DeleteServiceController extends HttpServlet {
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
        
        HttpSession session = request.getSession(false);
        String userRole = (session != null) ? (String) session.getAttribute("userRole") : null;
        if (userRole == null && session != null) {
            userRole = (String) session.getAttribute("role");
        }

        if (session == null || !"ADMIN".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        String serviceIdStr = request.getParameter("id");
        String feedbackMessage = "";

        try (Connection conn = getConnection()) {
            String deleteSql = "DELETE FROM Service WHERE Service_ID = ?";
            try (PreparedStatement ps = conn.prepareStatement(deleteSql)) {
                ps.setInt(1, Integer.parseInt(serviceIdStr.trim()));
                ps.executeUpdate();
                feedbackMessage = "Service record has been permanently deleted.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            feedbackMessage = "Error deleting service: " + e.getMessage().replace("'", "");
        }

        response.sendRedirect("AdminServiceServlet?msg=" + URLEncoder.encode(feedbackMessage, "UTF-8"));
    }
}