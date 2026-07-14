package helper;

public class ManageBookingHelper {

    public static boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    public static String formatSuccessJson(String message) {
        return "{\"status\":\"success\",\"message\":\"" + escapeJson(message) + "\"}";
    }

    public static String formatErrorJson(String message) {
        return "{\"status\":\"error\",\"message\":\"" + escapeJson(message) + "\"}";
    }

    public static String escapeJson(String source) {
        if (source == null) return "";
        return source.replace("\\", "\\\\")
                     .replace("\"", "\\\"")
                     .replace("\b", "\\b")
                     .replace("\f", "\\f")
                     .replace("\n", "\\n")
                     .replace("\r", "\\r")
                     .replace("\t", "\\t");
    }
}