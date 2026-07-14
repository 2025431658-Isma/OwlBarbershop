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

import dao.CancelBookingDAO;
import helper.CancelBookingHelper;

@WebServlet("/CancelBookingServlet")
public class CancelBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CancelBookingDAO cancelBookingDAOInstance;

    @Override
    public void init() throws ServletException {
        this.cancelBookingDAOInstance = new CancelBookingDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            out.print(CancelBookingHelper.formatErrorJson("Unauthorized access. Please log in."));
            return;
        }

        String bookingIdStr = request.getParameter("bookingId");
        if (CancelBookingHelper.isAnyEmpty(bookingIdStr)) {
            out.print(CancelBookingHelper.formatErrorJson("Missing booking reference identifier."));
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdStr.trim());

            boolean isCancelled = cancelBookingDAOInstance.executeCancellation(bookingId);
            
            if (isCancelled) {
                out.print(CancelBookingHelper.formatSuccessMessageJson("Booking marked as Cancelled successfully."));
            } else {
                out.print(CancelBookingHelper.formatErrorJson("Target booking record not found in system storage matrix."));
            }

        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            out.print(CancelBookingHelper.formatErrorJson("Database update exception: " + e.getMessage()));
        } catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
}