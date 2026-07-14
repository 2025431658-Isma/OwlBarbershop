package model;

import java.io.Serializable;

public class ManageBookingModel implements Serializable {
    private static final long serialVersionUID = 1L;

    private int bookingId;
    private String action;
    private String bookingDate;
    private String bookingTime;
    private int barberId;

    public ManageBookingModel() {}

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public String getAction() { return action; }
    public void setAction(String action) { this.action = action; }

    public String getBookingDate() { return bookingDate; }
    public void setBookingDate(String bookingDate) { this.bookingDate = bookingDate; }

    public String getBookingTime() { return bookingTime; }
    public void setBookingTime(String bookingTime) { this.bookingTime = bookingTime; }

    public int getBarberId() { return barberId; }
    public void setBarberId(int barberId) { this.barberId = barberId; }
}