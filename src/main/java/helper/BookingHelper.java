package helper;

public class BookingHelper {
    
    /**
     * Formats an error message into a valid JSON string.
     */
    public static String formatErrorJson(String message) {
        return "{\"status\":\"error\",\"message\":\"" + escapeJson(message) + "\"}";
    }

    /**
     * Checks if any of the provided string fields are null or empty.
     */
    public static boolean isAnyEmpty(String... fields) {
        for (String field : fields) {
            if (field == null || field.trim().isEmpty()) {
                return true;
            }
        }
        return false;
    }

    /**
     * Escapes special characters to keep JSON strings valid.
     */
    public static String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r");
    }
}