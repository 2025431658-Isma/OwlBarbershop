package model;

import java.io.Serializable;

public class GetBookingDataModel {

    public static class ServiceItem implements Serializable {
        private static final long serialVersionUID = 1L;
        private int id;
        private String name;
        private String description;
        private double price;
        private int durationMinutes;

        public ServiceItem() {}

        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
        public double getPrice() { return price; }
        public void setPrice(double price) { this.price = price; }
        public int getDurationMinutes() { return durationMinutes; }
        public void setDurationMinutes(int durationMinutes) { this.durationMinutes = durationMinutes; }
    }

    public static class StaffItem implements Serializable {
        private static final long serialVersionUID = 1L;
        private int id;
        private String name;
        private String role;

        public StaffItem() {}

        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public String getRole() { return role; }
        public void setRole(String role) { this.role = role; }
    }
}