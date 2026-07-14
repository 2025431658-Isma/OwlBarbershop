package model;

import java.io.Serializable;

public class BookingModel implements Serializable {
    private static final long serialVersionUID = 1L;

    private int bookingId;
    private int userId;
    private int staffId;
    private String bookingDate;
    private String bookingTime;
    private double totalPrice;
    private String bookingStatus;

    // Default Constructor
    public BookingModel() {}

    // Full Constructor
    public BookingModel(int bookingId, int userId, int staffId, String bookingDate, String bookingTime, double totalPrice, String bookingStatus) {
        this.bookingId = bookingId;
        this.userId = userId;
        this.staffId = staffId;
        this.bookingDate = bookingDate;
        this.bookingTime = bookingTime;
        this.totalPrice = totalPrice;
        this.bookingStatus = bookingStatus;
    }

    // Getters and Setters
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getStaffId() { return staffId; }
    public void setStaffId(int staffId) { this.staffId = staffId; }

    public String getBookingDate() { return bookingDate; }
    public void setBookingDate(String bookingDate) { this.bookingDate = bookingDate; }

    public String getBookingTime() { return bookingTime; }
    public void setBookingTime(String bookingTime) { this.bookingTime = bookingTime; }

    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }

    public String getBookingStatus() { return bookingStatus; }
    public void setBookingStatus(String bookingStatus) { this.bookingStatus = bookingStatus; }
}