package model;

import java.io.Serializable;

public class ProcessPaymentModel implements Serializable {
    private static final long serialVersionUID = 1L;

    private int bookingId;
    private String status;

    public ProcessPaymentModel() {}

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}