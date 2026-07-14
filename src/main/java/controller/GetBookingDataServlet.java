package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dao.GetBookingDataDAO;
import helper.GetBookingDataHelper;
import model.GetBookingDataModel.ServiceItem;
import model.GetBookingDataModel.StaffItem;

@WebServlet("/GetBookingDataServlet")
public class GetBookingDataServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private GetBookingDataDAO dao;

    @Override
    public void init() throws ServletException {
        this.dao = new GetBookingDataDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String action = request.getParameter("action");
        
        try {
            if ("getServices".equals(action)) {
                List<ServiceItem> services = dao.getAllServices();
                out.print(GetBookingDataHelper.buildServicesJson(services));
                
            } else if ("getStaff".equals(action)) {
                List<StaffItem> staff = dao.getAllStaff();
                out.print(GetBookingDataHelper.buildStaffJson(staff));

            } else if ("getBusySlots".equals(action)) {
                String barberIdStr = request.getParameter("barberId");
                String dateStr = request.getParameter("date");
                String totalDurationStr = request.getParameter("totalDuration");
                
                int newDuration = GetBookingDataHelper.extractMinutes(totalDurationStr);
                if (newDuration <= 0) newDuration = 30;
                
                int barberId = Integer.parseInt(barberIdStr);
                List<String[]> activeBookings = dao.getActiveBookings(barberId, dateStr);
                
                String busySlotsJson = GetBookingDataHelper.calculateBusySlots(activeBookings, newDuration);
                out.print(busySlotsJson);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"" + GetBookingDataHelper.escapeJson(e.getMessage()) + "\"}");
        }
    }
}