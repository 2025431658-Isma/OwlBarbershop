package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.owlbarber.util.DBConnection;
import model.MyBookingsModel;

public class MyBookingsDAO {

    public MyBookingsModel getCustomerBookingsData(int custId) throws SQLException, ClassNotFoundException {
        MyBookingsModel model = new MyBookingsModel();
        List<Map<String, Object>> bookingsList = new ArrayList<>();

        int statTotal = 0;
        int statUpcoming = 0;
        int statPending = 0;
        int statCancelled = 0;

        String sqlAutoCancel = "UPDATE BOOKING SET BOOKING_STATUS = 'Cancelled' "
                            + "WHERE UPPER(BOOKING_STATUS) = 'PENDING' "
                            + "AND (SYSTIMESTAMP - CREATED_AT) >= INTERVAL '2' HOUR";

        String sqlFetch = "SELECT b.BOOKING_ID, TO_CHAR(b.BOOKING_DATE, 'YYYY-MM-DD') AS FORM_DATE, "
                        + "b.BOOKING_TIME, b.BOOKING_STATUS, b.STAFF_ID, NVL(st.STAFF_NAME, 'Unassigned') AS STAFF_NAME, "
                        + "NVL(LISTAGG(s.SERVICE_NAME, ', ') WITHIN GROUP (ORDER BY s.SERVICE_ID), 'No Services Selected') AS COMBINED_SERVICES, "
                        + "NVL(SUM(s.SERVICE_PRICE), 0) AS TOTAL_PRICE, "
                        + "NVL(SUM(s.SERVICE_DURATION), 0) AS TOTAL_DURATION, "
                        + "b.CREATED_AT "
                        + "FROM BOOKING b "
                        + "LEFT JOIN STAFF st ON b.STAFF_ID = st.STAFF_ID "
                        + "LEFT JOIN BOOKING_SERVICES bs ON b.BOOKING_ID = bs.BOOKING_ID "
                        + "LEFT JOIN SERVICE s ON bs.SERVICE_ID = s.SERVICE_ID "
                        + "WHERE b.CUST_ID = ? "
                        + "GROUP BY b.BOOKING_ID, b.BOOKING_DATE, b.BOOKING_TIME, b.BOOKING_STATUS, b.STAFF_ID, st.STAFF_NAME, b.CREATED_AT "
                        + "ORDER BY b.BOOKING_DATE DESC, b.BOOKING_TIME DESC";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Step 1: Run expiration safety pipeline
            try (PreparedStatement stmtAuto = conn.prepareStatement(sqlAutoCancel)) {
                stmtAuto.executeUpdate();
            }
            conn.commit();

            // Step 2: Extract real-time row matrices
            try (PreparedStatement stmtFetch = conn.prepareStatement(sqlFetch)) {
                stmtFetch.setInt(1, custId);
                try (ResultSet rs = stmtFetch.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> row = new HashMap<>();
                        int id = rs.getInt("BOOKING_ID");
                        String date = rs.getString("FORM_DATE");
                        String time = rs.getString("BOOKING_TIME");
                        String statusRaw = rs.getString("BOOKING_STATUS");
                        String barber = rs.getString("STAFF_NAME");
                        String services = rs.getString("COMBINED_SERVICES");
                        double price = rs.getDouble("TOTAL_PRICE");
                        int duration = rs.getInt("TOTAL_DURATION");

                        String status = "Pending";
                        if (statusRaw != null) {
                            String check = statusRaw.trim().toUpperCase();
                            if ("CANCELLED".equals(check)) {
                                status = "Cancelled";
                            } else if ("CONFIRMED".equals(check)) {
                                status = "Confirmed";
                            } else if ("PAID".equals(check)) {
                                status = "Paid";
                            }
                        }

                        row.put("id", id);
                        row.put("date", date != null ? date : "N/A");
                        row.put("time", time != null ? time : "N/A");
                        row.put("status", status); 
                        row.put("barberName", barber);
                        row.put("serviceName", services);
                        row.put("price", price);
                        row.put("duration", duration + " mins");
                        row.put("barberId", rs.getInt("STAFF_ID"));

                        // Step 3: Handle Countdown Clock offsets
                        java.sql.Timestamp createdAt = rs.getTimestamp("CREATED_AT");
                        long millisLeft = 0;
                        if (createdAt != null && "Pending".equals(status)) {
                            long deadline = createdAt.getTime() + (2 * 60 * 60 * 1000); 
                            millisLeft = deadline - System.currentTimeMillis();
                            if (millisLeft < 0) millisLeft = 0;
                        }
                        row.put("millisLeft", millisLeft);
                        bookingsList.add(row);

                        // Step 4: Metric distribution tracking
                        statTotal++;
                        if ("Cancelled".equals(status)) {
                            statCancelled++;
                        } else if ("Pending".equals(status)) {
                            statPending++;
                        } else if ("Confirmed".equals(status) || "Paid".equals(status)) {
                            statUpcoming++;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            if (conn != null) { try { conn.rollback(); } catch (SQLException ex) {} }
            throw e;
        } finally {
            if (conn != null) { try { conn.close(); } catch (SQLException ex) {} }
        }

        model.setBookings(bookingsList);
        model.setStatTotal(statTotal);
        model.setStatUpcoming(statUpcoming);
        model.setStatPending(statPending);
        model.setStatCancelled(statCancelled);
        return model;
    }
}