package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.Service; 

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminServiceServlet")
public class AdminServiceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database connection parameters pointing to your local Oracle instance
    private final String DB_URL = "jdbc:oracle:thin:@localhost:1521/FREEPDB1";
    private final String DB_USER = "CSC584"; 
    private final String DB_PASSWORD = "CSC584"; 

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

        // Restrict access context exclusively to authorized ADMIN accounts 
        if (session == null || !"ADMIN".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        List<Service> servicesList = new ArrayList<>();
        int totalServices = 0; 
        double totalRevenue = 0.0;

        Connection conn = null;
        PreparedStatement stmtServices = null;
        PreparedStatement stmtStats = null;
        ResultSet rsServices = null; 
        ResultSet rsStats = null;

        try {
            conn = getConnection(); 

            // QUERY 1: Fetch all services matching your exact new "Service" database schema
            String sqlServices = "SELECT Service_ID, Service_Name, Service_Duration, Service_Description, Service_Price, Staff_ID " +
                                 "FROM Service ORDER BY Service_ID ASC";
            stmtServices = conn.prepareStatement(sqlServices);
            rsServices = stmtServices.executeQuery();

            while (rsServices.next()) {
                Service service = new Service();
                service.setServiceId(rsServices.getInt("Service_ID")); 
                service.setServiceName(rsServices.getString("Service_Name")); 
                service.setServiceDuration(rsServices.getInt("Service_Duration")); 
                service.setServiceDesc(rsServices.getString("Service_Description")); 
                service.setServicePrice(rsServices.getDouble("Service_Price")); 
                
                // Map the assigned staff ID column
                int staffId = rsServices.getInt("Staff_ID");
                if (!rsServices.wasNull()) {
                    service.setStaffId(staffId);
                } else {
                    service.setStaffId(0); // Represent unassigned with 0
                }
                
                servicesList.add(service);
            }

            // QUERY 2: Fetch the live count of total registered services and calculate revenue
            String sqlStats = "SELECT COUNT(*) as total_count, " +
                              "(SELECT NVL(SUM(TOTAL_PRICE), 0) FROM BOOKING WHERE UPPER(BOOKING_STATUS) IN ('CONFIRMED', 'COMPLETED')) as revenue " +
                              "FROM Service";
            stmtStats = conn.prepareStatement(sqlStats);
            rsStats = stmtStats.executeQuery();

            if (rsStats.next()) {
                // Dynamically retrieve the absolute count from the database
                totalServices = rsStats.getInt("total_count");
                totalRevenue = rsStats.getDouble("revenue"); 
            }

        } catch (Exception e) {
            System.err.println("Database execution fault triggered inside AdminServiceServlet layer trace:");
            e.printStackTrace();
        } finally {
            // Clean resource cleanup
            try { if (rsServices != null) rsServices.close(); } catch (Exception e) {} 
            try { if (rsStats != null) rsStats.close(); } catch (Exception e) {} 
            try { if (stmtServices != null) stmtServices.close(); } catch (Exception e) {}
            try { if (stmtStats != null) stmtStats.close(); } catch (Exception e) {} 
            try { if (conn != null) conn.close(); } catch (Exception e) {} 
        }

        // Bind the live database results onto the request scope 
        request.setAttribute("servicesList", servicesList); 
        request.setAttribute("totalServices", totalServices); 
        request.setAttribute("totalRevenue", totalRevenue); 

        // Forwards directly to your services dashboard JSP
        request.getRequestDispatcher("services-admin-dashboard.jsp").forward(request, response); 
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response); 
    }
}