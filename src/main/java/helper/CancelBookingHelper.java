package helper;

public class CancelBookingHelper {
    
    public static String formatErrorJson(String message) {
        return "{\"status\":\"error\",\"message\":\"" + escapeJson(message) + "\"}";
    }

    public static String formatSuccessMessageJson(String message) {
        return "{\"status\":\"success\",\"message\":\"" + escapeJson(message) + "\"}";
    }

    public static boolean isAnyEmpty(String... fields) {
        for (String field : fields) {
            if (field == null || field.trim().isEmpty()) {
                return true;
            }
        }
        return false;
    }

    public static String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r");
    }
}