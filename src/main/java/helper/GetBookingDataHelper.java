package helper;

import java.util.List;
import model.GetBookingDataModel.ServiceItem;
import model.GetBookingDataModel.StaffItem;

public class GetBookingDataHelper {

    public static int extractMinutes(String input) {
        if (input == null || input.trim().isEmpty()) return 0;
        try {
            String cleanNumber = input.replaceAll("[^0-9]", "");
            if (cleanNumber.isEmpty()) return 0;
            return Integer.parseInt(cleanNumber);
        } catch (Exception e) {
            return 0;
        }
    }

    public static int convertTimeToMinutes(String timeStr) {
        try {
            if (timeStr == null || !timeStr.contains(":")) return 0;
            String[] parts = timeStr.trim().split(":");
            int hours = Integer.parseInt(parts[0].replaceAll("[^0-9]", ""));
            int minutes = Integer.parseInt(parts[1].replaceAll("[^0-9]", ""));
            return (hours * 60) + minutes;
        } catch (Exception e) {
            return 0;
        }
    }

    public static String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }

    public static String buildServicesJson(List<ServiceItem> items) {
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < items.size(); i++) {
            if (i > 0) json.append(",");
            ServiceItem item = items.get(i);
            
            String[] descParts = item.getDescription().split("\\|\\|");
            String desc = descParts[0];
            int duration = extractMinutes(descParts.length > 1 ? descParts[1] : "30");

            json.append("{")
                .append("\"id\":").append(item.getId()).append(",")
                .append("\"name\":\"").append(escapeJson(item.getName())).append("\",")
                .append("\"description\":\"").append(escapeJson(desc)).append("\",")
                .append("\"price\":").append(item.getPrice()).append(",")
                .append("\"duration\":\"").append(duration).append(" mins\"")
                .append("}");
        }
        json.append("]");
        return json.toString();
    }

    public static String buildStaffJson(List<StaffItem> items) {
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < items.size(); i++) {
            if (i > 0) json.append(",");
            StaffItem item = items.get(i);
            json.append("{")
                .append("\"id\":").append(item.getId()).append(",")
                .append("\"name\":\"").append(escapeJson(item.getName())).append("\",")
                .append("\"role\":\"").append(escapeJson(item.getRole())).append("\"")
                .append("}");
        }
        json.append("]");
        return json.toString();
    }

    public static String calculateBusySlots(List<String[]> activeBookings, int newDuration) {
        String[] standardSlots = {"10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00", "15:30", "16:00", "16:30", "17:00", "17:30", "18:00", "18:30", "19:00", "19:30", "20:00"};
        StringBuilder json = new StringBuilder("[");
        boolean first = true;

        for (String slot : standardSlots) {
            boolean conflictFound = false;
            int slotStart = convertTimeToMinutes(slot);
            int slotEnd = slotStart + 30; 
            int prospectiveEnd = slotStart + newDuration;

            if (prospectiveEnd > 1260) { // Past 9:00 PM closing
                conflictFound = true;
            } else {
                for (String[] booking : activeBookings) {
                    int existingStart = convertTimeToMinutes(booking[0]);
                    int existingDuration = extractMinutes(booking[1]);
                    if (existingDuration <= 0) existingDuration = 30;
                    int existingEnd = existingStart + existingDuration;

                    boolean existingOverlapsSlot = (existingEnd > slotStart && existingStart < slotEnd);
                    boolean prospectiveOverlapsExisting = (prospectiveEnd > existingStart && slotStart < existingEnd);

                    if (existingOverlapsSlot || prospectiveOverlapsExisting) {
                        conflictFound = true;
                        break;
                    }
                }
            }

            if (conflictFound) {
                if (!first) json.append(",");
                json.append("\"").append(slot).append("\"");
                first = false;
            }
        }
        json.append("]");
        return json.toString();
    }
}