package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.BookingDAO;
import model.BookingModel;
import helper.BookingHelper;

// MATCHES: Explicitly mapped to match exactly what bookings.jsp fetches
@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookingDAO bookingDAOInstance;

    @Override
    public void init() throws ServletException {
        this.bookingDAOInstance = new BookingDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            out.print(BookingHelper.formatErrorJson("Unauthorized access. Please log in."));
            return;
        }

        int custId = (Integer) session.getAttribute("userId");
        String serviceIdStr = request.getParameter("serviceId");
        String barberIdStr = request.getParameter("barberId");
        String bookingDateStr = request.getParameter("bookingDate");
        String bookingTime = request.getParameter("bookingTime");
        String totalPriceStr = request.getParameter("totalPrice"); // FIXED: Extract the calculation parameter from JSP

        if (BookingHelper.isAnyEmpty(serviceIdStr, barberIdStr, bookingDateStr, bookingTime)) {
            out.print(BookingHelper.formatErrorJson("Missing required form data fields."));
            return;
        }

        try {
            // FIXED: Parse price properly with a safety check fallback value
            double totalPrice = 0.0;
            if (totalPriceStr != null && !totalPriceStr.trim().isEmpty()) {
                totalPrice = Double.parseDouble(totalPriceStr.trim());
            }

            BookingModel booking = new BookingModel();
            booking.setUserId(custId);
            booking.setStaffId(Integer.parseInt(barberIdStr.trim()));
            booking.setBookingDate(bookingDateStr.trim());
            booking.setBookingTime(bookingTime.trim());
            booking.setTotalPrice(totalPrice); // FIXED: Assign real transaction valuation price

            String[] serviceIdArray = serviceIdStr.split(",");
            List<Integer> serviceIdsList = new ArrayList<>();
            for (String id : serviceIdArray) {
                serviceIdsList.add(Integer.parseInt(id.trim()));
            }

            boolean isSaved = bookingDAOInstance.saveBooking(booking, serviceIdsList);
            
            if (isSaved) {
                out.print("{\"status\":\"success\","
                        + "\"id\":" + booking.getBookingId() + ","
                        + "\"bookingId\":" + booking.getBookingId() + ","
                        + "\"message\":\"Booking committed successfully.\"}");
            } else {
                out.print(BookingHelper.formatErrorJson("Critical data link communication loss occurred during transaction execution."));
            }

        } catch (SQLException | NumberFormatException | ClassNotFoundException e) {
            e.printStackTrace();
            out.print(BookingHelper.formatErrorJson("Transaction failed: " + e.getMessage()));
        }
    }
}