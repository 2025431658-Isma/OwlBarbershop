package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.MyBookingsDAO;
import model.MyBookingsModel;
import helper.MyBookingsHelper;

@WebServlet("/MyBookingsServlet")
public class MyBookingsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MyBookingsDAO daoInstance;

    @Override
    public void init() throws ServletException {
        this.daoInstance = new MyBookingsDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        MyBookingsHelper.attachCacheControlHeaders(response);

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int custId = (Integer) session.getAttribute("userId");

        try {
            // Retrieve data model collection using the isolated DAO layer process
            MyBookingsModel userMetricsModel = daoInstance.getCustomerBookingsData(custId);

            // Forward variables down to the UI presentation view template layer
            request.setAttribute("bookings", userMetricsModel.getBookings());
            request.setAttribute("statTotal", userMetricsModel.getStatTotal());
            request.setAttribute("statUpcoming", userMetricsModel.getStatUpcoming());
            request.setAttribute("statPending", userMetricsModel.getStatPending());
            request.setAttribute("statCancelled", userMetricsModel.getStatCancelled());

            request.getRequestDispatcher("/my-bookings.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().print("Database Integration Failure Trace: " + e.getMessage());
        }
    }
}