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

import dao.ManageBookingDAO;
import model.ManageBookingModel;
import helper.ManageBookingHelper;

@WebServlet("/ManageBookingServlet")
public class ManageBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ManageBookingDAO daoInstance;

    @Override
    public void init() throws ServletException {
        this.daoInstance = new ManageBookingDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            out.print(ManageBookingHelper.formatErrorJson("Unauthorized access. Session expired."));
            return;
        }

        String action = request.getParameter("action");
        String bookingIdStr = request.getParameter("bookingId");
        
        if (ManageBookingHelper.isEmpty(action) || ManageBookingHelper.isEmpty(bookingIdStr)) {
            out.print(ManageBookingHelper.formatErrorJson("Missing structural execution parameters."));
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdStr.trim());

            // 1. Enforce 24-hour business restriction check logic
            if ("CANCEL".equalsIgnoreCase(action) || "DELETE".equalsIgnoreCase(action) || "UPDATE".equalsIgnoreCase(action)) {
                if (!daoInstance.isModificationAllowed(bookingId)) {
                    out.print(ManageBookingHelper.formatErrorJson("Action restricted. Changes must be finalized at least 24 hours prior to appointment time."));
                    return;
                }
            }

            // 2. Map route processes to granular operations pipelines
            if ("CANCEL".equalsIgnoreCase(action) || "DELETE".equalsIgnoreCase(action)) {
                if (daoInstance.executeCancelOrDelete(bookingId)) {
                    out.print(ManageBookingHelper.formatSuccessJson("Booking status flagged as Cancelled successfully."));
                } else {
                    out.print(ManageBookingHelper.formatErrorJson("Booking record identifier reference location mismatch error."));
                }

            } else if ("PAY_CARD".equalsIgnoreCase(action)) {
                if (daoInstance.executePayCard(bookingId)) {
                    out.print(ManageBookingHelper.formatSuccessJson("Payment processed! Slot is locked down securely."));
                } else {
                    out.print(ManageBookingHelper.formatErrorJson("Payment rejected. Hold may have already expired or been processed."));
                }

            } else if ("PAY_CASH".equalsIgnoreCase(action)) {
                if (daoInstance.executePayCash(bookingId)) {
                    out.print(ManageBookingHelper.formatSuccessJson("Cash selection logged! Your appointment is temporarily held for 2 hours. Pay your barber in person at check-out."));
                } else {
                    out.print(ManageBookingHelper.formatErrorJson("Cash confirmation rejected. Booking not found."));
                }

            } else if ("UPDATE".equalsIgnoreCase(action)) {
                String newDateStr = request.getParameter("bookingDate");
                String newTimeStr = request.getParameter("bookingTime"); 
                String barberIdStr = request.getParameter("barberId");

                if (ManageBookingHelper.isEmpty(newDateStr) || ManageBookingHelper.isEmpty(newTimeStr) || ManageBookingHelper.isEmpty(barberIdStr)) {
                    out.print(ManageBookingHelper.formatErrorJson("Missing required data updates values context."));
                    return;
                }

                ManageBookingModel model = new ManageBookingModel();
                model.setBookingId(bookingId);
                model.setBookingDate(newDateStr.trim());
                model.setBookingTime(newTimeStr.trim());
                model.setBarberId(Integer.parseInt(barberIdStr.trim()));

                if (daoInstance.hasScheduleClash(model)) {
                    out.print(ManageBookingHelper.formatErrorJson("Schedule Conflict: The requested barber slot is already reserved."));
                    return;
                }

                if (daoInstance.executeUpdateBooking(model)) {
                    out.print("{\"status\":\"success\"}");
                } else {
                    out.print(ManageBookingHelper.formatErrorJson("Failed to apply update metrics configuration."));
                }
            }

        } catch (SQLException | ClassNotFoundException | NumberFormatException e) {
            e.printStackTrace();
            out.print(ManageBookingHelper.formatErrorJson("Transaction failure operational breakdown: " + e.getMessage()));
        }
    }
}