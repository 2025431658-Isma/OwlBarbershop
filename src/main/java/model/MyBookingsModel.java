package model;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

public class MyBookingsModel implements Serializable {
    private static final long serialVersionUID = 1L;

    private List<Map<String, Object>> bookings;
    private int statTotal;
    private int statUpcoming;
    private int statPending;
    private int statCancelled;

    public MyBookingsModel() {}

    public List<Map<String, Object>> getBookings() { return bookings; }
    public void setBookings(List<Map<String, Object>> bookings) { this.bookings = bookings; }

    public int getStatTotal() { return statTotal; }
    public void setStatTotal(int statTotal) { this.statTotal = statTotal; }

    public int getStatUpcoming() { return statUpcoming; }
    public void setStatUpcoming(int statUpcoming) { this.statUpcoming = statUpcoming; }

    public int getStatPending() { return statPending; }
    public void setStatPending(int statPending) { this.statPending = statPending; }

    public int getStatCancelled() { return statCancelled; }
    public void setStatCancelled(int statCancelled) { this.statCancelled = statCancelled; }
}