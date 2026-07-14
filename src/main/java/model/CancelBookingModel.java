package model;

import java.io.Serializable;

public class CancelBookingModel implements Serializable {
    private static final long serialVersionUID = 1L;

    private int bookingId;
    private String bookingStatus;

    public CancelBookingModel() {}

    public CancelBookingModel(int bookingId, String bookingStatus) {
        this.bookingId = bookingId;
        this.bookingStatus = bookingStatus;
    }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public String getBookingStatus() { return bookingStatus; }
    public void setBookingStatus(String bookingStatus) { this.bookingStatus = bookingStatus; }
}