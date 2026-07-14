package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.ProcessPaymentDAO;
import helper.ProcessPaymentHelper;

@WebServlet("/ProcessPaymentServlet")
public class ProcessPaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProcessPaymentDAO paymentDAOInstance;

    @Override
    public void init() throws ServletException {
        this.paymentDAOInstance = new ProcessPaymentDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            out.print(ProcessPaymentHelper.formatErrorJson("Unauthorized entry or session expired."));
            return;
        }

        String bookingIdStr = request.getParameter("bookingId");
        if (ProcessPaymentHelper.isEmpty(bookingIdStr)) {
            out.print(ProcessPaymentHelper.formatErrorJson("Missing target booking reference ID."));
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdStr.trim());

            boolean isUpdated = paymentDAOInstance.updateBookingToPaid(bookingId);
            
            if (isUpdated) {
                int currentUserId = Integer.parseInt(session.getAttribute("userId").toString());
                session.setAttribute("userId", currentUserId);
                if (session.getAttribute("fullName") != null) {
                    session.setAttribute("fullName", session.getAttribute("fullName").toString());
                }
                
                out.print("{\"status\":\"success\"}"); 
            } else {
                out.print(ProcessPaymentHelper.formatErrorJson("Booking ID not found or could not be updated."));
            }

        } catch (SQLException | ClassNotFoundException | NumberFormatException e) {
            e.printStackTrace();
            out.print(ProcessPaymentHelper.formatErrorJson("Oracle DB Error: " + e.getMessage()));
        }
    }
}